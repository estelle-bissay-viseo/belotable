#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=dev-scripts/lib/global-common.sh
source "$SCRIPT_DIR/../lib/global-common.sh"
# shellcheck source=dev-scripts/lib/git-common.sh
source "$SCRIPT_DIR/../lib/git-common.sh"

show_help() {
  cat <<'EOF'
Usage:
  sync-remote-pr.sh [--parent-branch name] [--description-file path] [--confirm-update-existing] [--no-draft]

Description:
  - Loads PR description from .github/pr_descriptions/<current-branch>.md by default.
  - Extracts PR title from the first non-empty line of the markdown.
  - If --parent-branch is missing, proposes the most likely parent branch and stops.
  - Syncs the remote branch (push if missing or local ahead).
  - Stops if divergent/rewritten history detected (non fast-forward).
  - Creates PR if missing, or requests confirmation before update if already exists.
  - Draft mode is enabled by default: creates PR as draft and ensures an existing PR is draft.
  - Use --no-draft to create/update PR as ready for review (non-draft).

Exit codes:
  0  : action completed (create/update) or execution without blocking
  20 : waiting for parent branch confirmation
  30 : waiting for existing PR update confirmation
EOF
}

print_state() {
  printf 'CURRENT_BRANCH=%s\n' "$CURRENT_BRANCH"
  printf 'PARENT_BRANCH=%s\n' "${PARENT_BRANCH:-}"
  printf 'DESCRIPTION_FILE=%s\n' "$DESCRIPTION_FILE"
  printf 'PR_TITLE=%s\n' "$PR_TITLE"
  printf 'BRANCH_SYNC_STATUS=%s\n' "${BRANCH_SYNC_STATUS:-unknown}"
  printf 'ACTION=%s\n' "${ACTION:-unknown}"
  printf 'PR_URL=%s\n' "${PR_URL:-}"
  printf 'NEXT_INPUT=%s\n' "${NEXT_INPUT:-}"
}

DESCRIPTION_FILE=""
PARENT_BRANCH=""
CONFIRM_UPDATE_EXISTING="false"
DRAFT="true"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --parent-branch)
      PARENT_BRANCH="${2:-}"
      shift 2
      ;;
    --description-file)
      DESCRIPTION_FILE="${2:-}"
      shift 2
      ;;
    --confirm-update-existing)
      CONFIRM_UPDATE_EXISTING="true"
      shift 1
      ;;
    --draft)
      DRAFT="true"
      shift 1
      ;;
    --no-draft)
      DRAFT="false"
      shift 1
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      log_error "unknown option '$1'"
      show_help >&2
      exit 1
      ;;
  esac
done

if ! is_git_repository; then
  log_error "this folder is not a git repository."
  exit 1
fi

CURRENT_BRANCH="$(get_current_branch)"
if [[ -z "$CURRENT_BRANCH" ]]; then
  log_error "detached HEAD. Checkout a branch first."
  exit 1
fi

if [[ -z "$DESCRIPTION_FILE" ]]; then
  SANITIZED_BRANCH="$(sanitize_branch_for_filename "$CURRENT_BRANCH")"
  DESCRIPTION_FILE=".github/pr_descriptions/${SANITIZED_BRANCH}.md"
fi

if [[ ! -f "$DESCRIPTION_FILE" ]]; then
  log_error "PR description file not found: $DESCRIPTION_FILE"
  ACTION="blocked"
  NEXT_INPUT="create-description-file"
  BRANCH_SYNC_STATUS="unknown"
  PR_TITLE=""
  PR_URL=""
  print_state
  exit 1
fi

PR_TITLE="$(read_first_non_empty_line "$DESCRIPTION_FILE")"
if [[ -z "${PR_TITLE//[[:space:]]/}" ]]; then
  log_error "first non-empty line of markdown is empty/invalid."
  ACTION="blocked"
  NEXT_INPUT="fix-description-title"
  BRANCH_SYNC_STATUS="unknown"
  PR_URL=""
  print_state
  exit 1
fi

if [[ -z "$PARENT_BRANCH" ]]; then
  if ! PARENT_BRANCH="$(infer_parent_from_reflog "$CURRENT_BRANCH" "true")"; then
    log_error "unable to propose a likely parent branch."
    ACTION="blocked"
    NEXT_INPUT="provide-parent-branch"
    BRANCH_SYNC_STATUS="unknown"
    PR_URL=""
    print_state
    exit 1
  fi

  ACTION="waiting-for-confirmation"
  NEXT_INPUT="confirm-parent-branch"
  BRANCH_SYNC_STATUS="unknown"
  PR_URL=""
  print_state
  exit 20
fi

if ! gh auth status >/dev/null 2>&1; then
  log_error "GitHub CLI not authenticated (gh auth status)."
  ACTION="blocked"
  NEXT_INPUT="gh-auth-login"
  BRANCH_SYNC_STATUS="unknown"
  PR_URL=""
  print_state
  exit 1
fi

git fetch --prune origin >/dev/null 2>&1

REMOTE_REF="refs/remotes/origin/${CURRENT_BRANCH}"
if git rev-parse --verify --quiet "$REMOTE_REF" >/dev/null; then
  if git merge-base --is-ancestor "origin/${CURRENT_BRANCH}" "$CURRENT_BRANCH"; then
    if git merge-base --is-ancestor "$CURRENT_BRANCH" "origin/${CURRENT_BRANCH}"; then
      BRANCH_SYNC_STATUS="already-up-to-date"
    else
      git push origin "$CURRENT_BRANCH"
      BRANCH_SYNC_STATUS="pushed"
    fi
  else
    BRANCH_SYNC_STATUS="diverged-history-detected"
    ACTION="blocked"
    NEXT_INPUT="resolve-branch-history-manually"
    PR_URL=""
    print_state
    exit 1
  fi
else
  git push -u origin "$CURRENT_BRANCH"
  BRANCH_SYNC_STATUS="pushed"
fi

PR_URL="$(gh pr list --head "$CURRENT_BRANCH" --base "$PARENT_BRANCH" --state open --json url --jq '.[0].url // ""')"

if [[ -n "$PR_URL" ]]; then
  if [[ "$CONFIRM_UPDATE_EXISTING" != "true" ]]; then
    ACTION="waiting-for-confirmation"
    NEXT_INPUT="confirm-update-existing-pr"
    print_state
    exit 30
  fi

  gh pr edit "$PR_URL" --title "$PR_TITLE" --body-file "$DESCRIPTION_FILE"

  if [[ "$DRAFT" == "true" ]]; then
    # `gh pr edit` does not support `--draft`. For existing PRs, switch back to draft explicitly.
    PR_IS_DRAFT="$(gh pr view "$PR_URL" --json isDraft --jq '.isDraft')"
    if [[ "$PR_IS_DRAFT" != "true" ]]; then
      gh pr ready "$PR_URL" --undo
    fi
  fi
  ACTION="updated"
  NEXT_INPUT=""
  print_state
  exit 0
fi

if [[ "$DRAFT" == "true" ]]; then
  PR_URL="$(gh pr create --base "$PARENT_BRANCH" --head "$CURRENT_BRANCH" --title "$PR_TITLE" --body-file "$DESCRIPTION_FILE" --draft)"
else
  PR_URL="$(gh pr create --base "$PARENT_BRANCH" --head "$CURRENT_BRANCH" --title "$PR_TITLE" --body-file "$DESCRIPTION_FILE")"
fi
ACTION="created"
NEXT_INPUT=""
print_state
