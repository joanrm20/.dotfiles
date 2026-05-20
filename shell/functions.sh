# Git worktree helpers

# Create a worktree for a branch and open it in VS Code
# Usage: wt <branch-name>
# Example: wt feature/auth-refactor
wt() {
  if [[ -z "$1" ]]; then
    echo "Usage: wt <branch-name>"
    return 1
  fi

  local branch=$1
  local name=$(echo "$branch" | tr '/' '-')
  local dir="../$(basename "$PWD")-$name"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$dir" "$branch"
  else
    git worktree add "$dir" -b "$branch"
  fi

  code "$dir"
}

# Remove a worktree and its branch
# Usage: wt-rm <branch-name>
wt-rm() {
  if [[ -z "$1" ]]; then
    echo "Usage: wt-rm <branch-name>"
    return 1
  fi

  local branch=$1
  local name=$(echo "$branch" | tr '/' '-')
  local dir="../$(basename "$PWD")-$name"

  git worktree remove "$dir"
  git branch -d "$branch"
}

# List all worktrees for the current repo
wt-ls() {
  git worktree list
}
