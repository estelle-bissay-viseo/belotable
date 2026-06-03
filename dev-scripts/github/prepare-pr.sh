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
  prepare-pr.sh [--description "text" | --description-file path] [--parent-branch name]

Description:
  0) By default, loads PR description from .github/pr_descriptions/<current-branch>.md.
  1) Detects parent branch (from branch creation reflog) unless --parent-branch is provided.
  2) Squashes all commits on current branch since divergence from parent branch.
  3) Creates one commit with message derived from PR description.
  4) Rebases the branch onto parent branch.

Notes:
  - Never pushes to remote.
  - Fails if the working tree is not clean.
EOF
}

DESCRIPTION=""
DESCRIPTION_FILE=""
PARENT_BRANCH=""
AUTO_DESCRIPTION_FILE="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --description)
      DESCRIPTION="${2:-}"
      shift 2
      ;;
    --description-file)
      DESCRIPTION_FILE="${2:-}"
      shift 2
      ;;
    --parent-branch)
      PARENT_BRANCH="${2:-}"
      shift 2
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

if [[ -n "$DESCRIPTION" && -n "$DESCRIPTION_FILE" ]]; then
  log_error "use either --description or --description-file, not both."
  exit 1
fi

if ! is_git_repository; then
  log_error "this folder is not a git repository."
  exit 1
fi

if ! is_working_tree_clean; then
  log_error "working tree is not clean. Commit or stash your changes before running this script."
  exit 1
fi

CURRENT_BRANCH="$(get_current_branch)"
if [[ -z "$CURRENT_BRANCH" ]]; then
  log_error "detached HEAD. Checkout a branch first."
  exit 1
fi

if [[ -z "$DESCRIPTION" && -z "$DESCRIPTION_FILE" ]]; then
  DESCRIPTION_FILE=".github/pr_descriptions/${CURRENT_BRANCH}.md"
  AUTO_DESCRIPTION_FILE="true"
fi

if [[ -n "$DESCRIPTION_FILE" ]]; then
  if [[ ! -f "$DESCRIPTION_FILE" ]]; then
    if [[ "$AUTO_DESCRIPTION_FILE" == "true" ]]; then
      log_error "PR description file not found: $DESCRIPTION_FILE"
      log_info "Provide an explicit path with --description-file <path>."
    else
      log_error "file not found: $DESCRIPTION_FILE"
    fi
    exit 1
  fi
  # When a markdown file is provided, use only the first non-empty line.
  DESCRIPTION="$(read_first_non_empty_line "$DESCRIPTION_FILE")"
fi

if [[ -z "${DESCRIPTION//[[:space:]]/}" ]]; then
  log_error "PR description is empty."
  exit 1
fi

if [[ -z "$PARENT_BRANCH" ]]; then
  if ! PARENT_BRANCH="$(infer_parent_from_reflog "$CURRENT_BRANCH")"; then
    log_error "unable to automatically determine parent branch."
    log_info "Run again with --parent-branch <branch-name>."
    exit 1
  fi
fi

if ! PARENT_REF="$(resolve_parent_ref "$PARENT_BRANCH")"; then
  log_error "parent branch not found locally: $PARENT_BRANCH"
  exit 1
fi

log_info "Current branch: $CURRENT_BRANCH"
log_info "Parent branch : $PARENT_REF"

MERGE_BASE="$(git merge-base "$PARENT_REF" HEAD)"
COMMITS_AHEAD_COUNT="$(git rev-list --count "${MERGE_BASE}..HEAD")"

if [[ "$COMMITS_AHEAD_COUNT" -eq 0 ]]; then
  log_info "No commits to squash since divergence point."
else
  SUBJECT="$(printf '%s\n' "$DESCRIPTION" | sed '/^[[:space:]]*$/d' | sed -E 's/^[[:space:]]*#+[[:space:]]*//' | sed -E 's/^[[:space:]]*[-*][[:space:]]*//' | sed -E 's/^[[:space:]]*[0-9]+[.)][[:space:]]*//' | head -n 1 | tr -d '\r')"

  if [[ -z "$SUBJECT" ]]; then
    SUBJECT="chore: prepare pull request"
  fi

  if [[ ${#SUBJECT} -gt 72 ]]; then
    SUBJECT="${SUBJECT:0:69}..."
  fi

  TMP_MSG_FILE="$(mktemp)"
  {
    printf '%s\n\n' "$SUBJECT"
    printf '%s\n' "$DESCRIPTION"
  } > "$TMP_MSG_FILE"

  log_info "Squashing $COMMITS_AHEAD_COUNT commit(s) into a single commit..."
  git reset --soft "$MERGE_BASE"
  git commit -F "$TMP_MSG_FILE"
  rm -f "$TMP_MSG_FILE"
fi

log_info "Rebasing onto parent branch..."
git rebase "$PARENT_REF"

log_info "Done. No push was performed."
log_info "Review the history and push manually if needed."
