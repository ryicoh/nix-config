---
name: worktree-cleanup
description: Identify stale Git worktrees that are older than two weeks, are not main/master, and have no open pull request; estimate disk savings and remove only after explicit approval.
---

# Worktree cleanup

Reduce local disk usage by finding unused Git worktrees. Prefer conservative, explainable decisions over aggressive cleanup.

## Eligibility

A worktree is a **candidate** only when all conditions hold:

- Its branch is not `main`, `master`, or the repository's default branch.
- It is not the main worktree, current working directory, or a detached HEAD.
- The branch's most recent commit is **more than 14 days old**.
- There is **no open pull request** for the branch.
- Its working tree has no staged, unstaged, or untracked changes.

Fail closed: if branch age, open-PR status, or cleanliness cannot be determined, do not select the worktree for deletion. Do not confuse age of a commit with the time a worktree was created.

## Procedure

1. Inspect `git worktree list --porcelain`, the repository's default branch, and each worktree's branch and status.
2. Check the latest commit timestamp and open PRs using `gh pr list --state open --head <branch> --json number`. If `gh` is unavailable or PR lookup fails, exclude that worktree.
3. Measure approximate disk usage with `du -sh <worktree-path>` and show candidates with their path, branch, age, PR status, cleanliness, and potential space savings.
4. **Present the exact deletion plan and request explicit user confirmation.** Do not remove anything before confirmation.
5. For approved candidates only, re-check all eligibility conditions immediately before acting. Use `git worktree remove <path>` without `--force`.
6. Report removed paths, any failures, and approximate disk usage reclaimed.

Do not delete Git branches or run `git worktree prune` unless separately requested. Never remove uncommitted work, including untracked files.
