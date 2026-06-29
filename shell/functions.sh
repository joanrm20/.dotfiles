# Git worktree helpers

# Sibling worktree path for a branch, anchored to the MAIN checkout so the
# name is stable whether you run this from the main repo or another worktree.
# Prints e.g. /path/to/myrepo-feature-auth-refactor
_wt_dir() {
  local branch=$1
  local name=${branch//\//-}
  local common_dir main_root
  common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 1
  main_root=$(dirname "$common_dir")
  printf '%s/%s-%s' "$(dirname "$main_root")" "$(basename "$main_root")" "$name"
}

# Open a path in a GUI editor. Override with $EDITOR_GUI in ~/.zshrc.local.
_wt_open() {
  local dir=$1
  if [[ -n "${EDITOR_GUI:-}" ]]; then
    "${EDITOR_GUI}" "$dir"
  elif command -v code >/dev/null 2>&1; then
    code "$dir"
  else
    echo "  (no GUI editor found — cd \"$dir\")"
  fi
}

# Create a worktree for a branch (new or existing) and open it
# Usage: wt <branch-name>
wt() {
  if [[ -z "$1" ]]; then
    echo "Usage: wt <branch-name>"
    return 1
  fi

  local branch=$1 dir
  dir=$(_wt_dir "$branch") || { echo "wt: not inside a git repository"; return 1; }

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$dir" "$branch" || return 1
  else
    git worktree add "$dir" -b "$branch" || return 1
  fi

  _wt_open "$dir"
}

# Remove a worktree and its branch
# Usage: wt-rm <branch-name>
wt-rm() {
  if [[ -z "$1" ]]; then
    echo "Usage: wt-rm <branch-name>"
    return 1
  fi

  local branch=$1 dir
  dir=$(_wt_dir "$branch") || { echo "wt-rm: not inside a git repository"; return 1; }

  git worktree remove "$dir" && git branch -d "$branch"
}

# List all worktrees for the current repo
wt-ls() {
  git worktree list
}
