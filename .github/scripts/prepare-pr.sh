#!/usr/bin/env bash
set -euo pipefail

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
      echo "Error: unknown option '$1'" >&2
      show_help >&2
      exit 1
      ;;
  esac
done

if [[ -n "$DESCRIPTION" && -n "$DESCRIPTION_FILE" ]]; then
  echo "Error: use either --description or --description-file, not both." >&2
  exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: this folder is not a git repository." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: working tree is not clean. Commit or stash your changes before running this script." >&2
  exit 1
fi

CURRENT_BRANCH="$(git symbolic-ref --quiet --short HEAD || true)"
if [[ -z "$CURRENT_BRANCH" ]]; then
  echo "Error: detached HEAD. Checkout a branch first." >&2
  exit 1
fi

if [[ -z "$DESCRIPTION" && -z "$DESCRIPTION_FILE" ]]; then
  DESCRIPTION_FILE=".github/pr_descriptions/${CURRENT_BRANCH}.md"
  AUTO_DESCRIPTION_FILE="true"
fi

if [[ -n "$DESCRIPTION_FILE" ]]; then
  if [[ ! -f "$DESCRIPTION_FILE" ]]; then
    if [[ "$AUTO_DESCRIPTION_FILE" == "true" ]]; then
      echo "Error: PR description file not found: $DESCRIPTION_FILE" >&2
      echo "Provide an explicit path with --description-file <path>." >&2
    else
      echo "Error: file not found: $DESCRIPTION_FILE" >&2
    fi
    exit 1
  fi
  # When a markdown file is provided, use only the first non-empty line.
  DESCRIPTION="$(sed '/^[[:space:]]*$/d' "$DESCRIPTION_FILE" | head -n 1 | tr -d '\r')"
fi

if [[ -z "${DESCRIPTION//[[:space:]]/}" ]]; then
  echo "Error: PR description is empty." >&2
  exit 1
fi

infer_parent_from_reflog() {
  local branch="$1"
  local line parent

  line="$( (git reflog --format='%gs' | grep -E "checkout: moving from .* to ${branch}$" || true) | tail -n 1 )"
  if [[ -n "$line" ]]; then
    parent="$(printf '%s\n' "$line" | sed -E "s/^checkout: moving from (.*) to ${branch}$/\\1/")"
    if [[ -n "$parent" ]]; then
      printf '%s\n' "$parent"
      return 0
    fi
  fi

  return 1
}

resolve_parent_ref() {
  local parent="$1"
  local remote_ref

  if git show-ref --verify --quiet "refs/heads/$parent"; then
    printf '%s\n' "$parent"
    return 0
  fi

  remote_ref="$(git for-each-ref --format='%(refname:short)' "refs/remotes/*/$parent" | head -n 1)"
  if [[ -n "$remote_ref" ]]; then
    printf '%s\n' "$remote_ref"
    return 0
  fi

  return 1
}

if [[ -z "$PARENT_BRANCH" ]]; then
  if ! PARENT_BRANCH="$(infer_parent_from_reflog "$CURRENT_BRANCH")"; then
    echo "Error: unable to automatically determine parent branch." >&2
    echo "Run again with --parent-branch <branch-name>." >&2
    exit 1
  fi
fi

if ! PARENT_REF="$(resolve_parent_ref "$PARENT_BRANCH")"; then
  echo "Error: parent branch not found locally: $PARENT_BRANCH" >&2
  exit 1
fi

echo "Current branch: $CURRENT_BRANCH"
echo "Parent branch : $PARENT_REF"

MERGE_BASE="$(git merge-base "$PARENT_REF" HEAD)"
COMMITS_AHEAD_COUNT="$(git rev-list --count "${MERGE_BASE}..HEAD")"

if [[ "$COMMITS_AHEAD_COUNT" -eq 0 ]]; then
  echo "No commits to squash since divergence point."
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

  echo "Squashing $COMMITS_AHEAD_COUNT commit(s) into a single commit..."
  git reset --soft "$MERGE_BASE"
  git commit -F "$TMP_MSG_FILE"
  rm -f "$TMP_MSG_FILE"
fi

echo "Rebasing onto parent branch..."
git rebase "$PARENT_REF"

echo "Done. No push was performed."
echo "Review the history and push manually if needed."
