#!/usr/bin/env bash

is_git_repository() {
  git rev-parse --git-dir >/dev/null 2>&1
}

is_working_tree_clean() {
  [[ -z "$(git status --porcelain)" ]]
}

get_current_branch() {
  git symbolic-ref --quiet --short HEAD || true
}

sanitize_branch_for_filename() {
  local branch="$1"
  printf '%s\n' "${branch//[^a-zA-Z0-9._-]/_}"
}

infer_parent_from_reflog() {
  local branch="$1"
  local fallback_to_default_branches="${2:-false}"
  local line candidate

  line="$( (git reflog --format='%gs' | grep -E "checkout: moving from .* to ${branch}$" || true) | tail -n 1 )"
  if [[ -n "$line" ]]; then
    candidate="$(printf '%s\n' "$line" | sed -E "s/^checkout: moving from (.*) to ${branch}$/\\1/")"
    if [[ -n "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  fi

  if [[ "$fallback_to_default_branches" == "true" ]]; then
    for b in main master develop dev; do
      if git show-ref --verify --quiet "refs/heads/$b" || git show-ref --verify --quiet "refs/remotes/origin/$b"; then
        printf '%s\n' "$b"
        return 0
      fi
    done
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