#!/usr/bin/env bash
set -euo pipefail

show_help() {
  cat <<'EOF'
Usage:
  sync-remote-pr.sh [--parent-branch name] [--parent-source value] [--description-file path] [--confirm-update-existing] [--draft]

Description:
  - Loads PR description from .github/pr_descriptions/<current-branch>.md by default.
  - Extracts PR title from the first non-empty line of the markdown.
  - If --parent-branch is missing, proposes the most likely parent branch and stops.
  - Syncs the remote branch (push if missing or local ahead).
  - Stops if divergent/rewritten history detected (non fast-forward).
  - Creates PR if missing, or requests confirmation before update if already exists.
  - With --draft, creates PR as draft and ensures an existing PR is draft.

Exit codes:
  0  : action completed (create/update) or execution without blocking
  20 : waiting for parent branch confirmation
  30 : waiting for existing PR update confirmation
EOF
}

print_state() {
  printf 'CURRENT_BRANCH=%s\n' "$CURRENT_BRANCH"
  printf 'PARENT_BRANCH=%s\n' "${PARENT_BRANCH:-}"
  printf 'PARENT_SOURCE=%s\n' "${PARENT_SOURCE:-}"
  printf 'DESCRIPTION_FILE=%s\n' "$DESCRIPTION_FILE"
  printf 'PR_TITLE=%s\n' "$PR_TITLE"
  printf 'BRANCH_SYNC_STATUS=%s\n' "${BRANCH_SYNC_STATUS:-unknown}"
  printf 'ACTION=%s\n' "${ACTION:-unknown}"
  printf 'PR_URL=%s\n' "${PR_URL:-}"
  printf 'NEXT_INPUT=%s\n' "${NEXT_INPUT:-}"
}

DESCRIPTION_FILE=""
PARENT_BRANCH=""
PARENT_SOURCE=""
PARENT_SOURCE_INPUT=""
CONFIRM_UPDATE_EXISTING="false"
DRAFT="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --parent-branch)
      PARENT_BRANCH="${2:-}"
      shift 2
      ;;
    --parent-source)
      PARENT_SOURCE_INPUT="${2:-}"
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
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Error: unknown option '$1'" >&2
      show_help >&2
      exit 1
      ;;
  esac
done

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: this folder is not a git repository." >&2
  exit 1
fi

CURRENT_BRANCH="$(git symbolic-ref --quiet --short HEAD || true)"
if [[ -z "$CURRENT_BRANCH" ]]; then
  echo "Error: detached HEAD. Checkout a branch first." >&2
  exit 1
fi

if [[ -z "$DESCRIPTION_FILE" ]]; then
  DESCRIPTION_FILE=".github/pr_descriptions/${CURRENT_BRANCH}.md"
fi

if [[ ! -f "$DESCRIPTION_FILE" ]]; then
  echo "Error: PR description file not found: $DESCRIPTION_FILE" >&2
  ACTION="blocked"
  NEXT_INPUT="create-description-file"
  BRANCH_SYNC_STATUS="unknown"
  PR_TITLE=""
  PR_URL=""
  print_state
  exit 1
fi

PR_TITLE="$(awk 'NF { gsub(/\r$/, "", $0); print; exit }' "$DESCRIPTION_FILE")"
if [[ -z "${PR_TITLE//[[:space:]]/}" ]]; then
  echo "Error: first non-empty line of markdown is empty/invalid." >&2
  ACTION="blocked"
  NEXT_INPUT="fix-description-title"
  BRANCH_SYNC_STATUS="unknown"
  PR_URL=""
  print_state
  exit 1
fi

infer_parent_from_reflog() {
  local branch="$1"
  local line candidate

  line="$( (git reflog --format='%gs' | grep -E "checkout: moving from .* to ${branch}$" || true) | tail -n 1 )"
  if [[ -n "$line" ]]; then
    candidate="$(printf '%s\n' "$line" | sed -E "s/^checkout: moving from (.*) to ${branch}$/\\1/")"
    if [[ -n "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  fi

  for b in main master develop dev; do
    if git show-ref --verify --quiet "refs/heads/$b" || git show-ref --verify --quiet "refs/remotes/origin/$b"; then
      printf '%s\n' "$b"
      return 0
    fi
  done

  return 1
}

if [[ -z "$PARENT_BRANCH" ]]; then
  if ! PARENT_BRANCH="$(infer_parent_from_reflog "$CURRENT_BRANCH")"; then
    echo "Error: unable to propose a likely parent branch." >&2
    ACTION="blocked"
    NEXT_INPUT="provide-parent-branch"
    BRANCH_SYNC_STATUS="unknown"
    PARENT_SOURCE="unresolved"
    PR_URL=""
    print_state
    exit 1
  fi

  PARENT_SOURCE="inferred"
  ACTION="waiting-for-confirmation"
  NEXT_INPUT="confirm-parent-branch"
  BRANCH_SYNC_STATUS="unknown"
  PR_URL=""
  print_state
  exit 20
fi

if [[ -n "$PARENT_SOURCE_INPUT" ]]; then
  PARENT_SOURCE="$PARENT_SOURCE_INPUT"
else
  PARENT_SOURCE="user-provided"
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: GitHub CLI not authenticated (gh auth status)." >&2
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
