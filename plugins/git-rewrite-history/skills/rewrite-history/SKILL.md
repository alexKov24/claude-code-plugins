---
name: rewrite-history
description: This skill should be used when the user asks to "rewrite commit history", "clean up commits", "reorganize commits", "squash and restructure commits", "rebuild commit history", "rewrite branch commits", "clean up my branch", "prepare branch for PR", "split commits into logical groups", or mentions wanting cleaner/better commits before merging. Automates the process of analyzing a messy feature branch, proposing a clean commit structure grouped by feature area, and executing the rewrite after user approval.
---

# Rewrite Commit History

Automate the tedious process of reorganizing a messy feature branch into clean, logical commits grouped by feature area. This replaces the manual workflow of `git reset --soft main` followed by hours of manually staging and committing file groups.

## When to Use

- A feature branch has many small commits that touch the same files repeatedly
- Commits are disorganized (e.g., "wip", "fix", "more changes")
- The branch needs to be cleaned up before a PR or merge
- The user wants their commit history to tell a clear story

## Core Workflow

The rewrite process has 4 phases: **Analyze**, **Plan**, **Approve**, **Execute**.

### Phase 1: Analyze

Run the analysis script to understand the branch state:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/rewrite-history/scripts/analyze-branch.sh [base-branch]
```

The base branch defaults to `main`. The script outputs:
- All commits on the branch with their files
- Cumulative diff stats
- File overlap (files touched by multiple commits)
- Directory distribution

Also read the actual diffs to understand what changed semantically:

```bash
git diff main...HEAD
```

Review the original commit messages for context about intent. Use `git log main..HEAD` to understand the development narrative.

### Phase 2: Plan

Using the analysis output, propose a new commit structure. Group changes by **feature area** — files that belong to the same logical unit of work.

#### Grouping Principles

1. **Backend endpoint + its dependencies** — route, controller, service, migration, types → one commit
2. **Frontend feature** — component, hook, styles, translations → one commit
3. **Shared/infrastructure** — config, shared utilities, package changes → one commit
4. **Tests** — test files can go with their feature commit or in a separate commit if they span multiple features
5. **Cleanup/refactoring** — if the branch includes refactoring unrelated to the feature, separate it

For detailed grouping strategies and monorepo-specific patterns, consult `references/grouping-strategies.md`.

#### Plan Format

Present the plan as a numbered list of proposed commits:

```
Proposed commit structure (N commits):

1. <type>: <clear description>
   Files:
   - path/to/file1.ts
   - path/to/file2.ts
   Rationale: <why these files belong together>

2. <type>: <clear description>
   Files:
   - path/to/file3.ts
   Rationale: <why these files belong together>

...
```

Where `<type>` follows conventional commits: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`.

#### Plan Rules

- Every file from the cumulative diff MUST appear in exactly one commit
- No file should appear in multiple commits
- Order commits logically: infrastructure/setup first, then core features, then UI, then tests
- Each commit message should explain **why**, not just **what**
- Keep commits atomic — each should compile and make sense on its own

### Phase 3: Approve

Present the full plan to the user and wait for explicit approval. The user may:
- **Approve as-is** — proceed to execution
- **Request changes** — adjust groupings, rename commits, reorder
- **Add context** — provide additional commit message details

Do NOT proceed to Phase 4 without explicit user approval. This is a destructive operation.

### Phase 4: Execute

After approval, execute the rewrite:

#### Step 1: Safety backup

```bash
git branch backup-before-rewrite
```

This creates a backup branch at the current HEAD. Inform the user they can restore with `git reset --hard backup-before-rewrite` if anything goes wrong.

#### Step 2: Soft reset

```bash
git reset --soft main
```

This unstages all commits but keeps all changes in the working tree and staging area.

#### Step 3: Unstage everything

```bash
git reset HEAD .
```

All changes are now unstaged in the working directory.

#### Step 4: Create commits one by one

For each planned commit, stage only the files for that commit and create it:

```bash
git add path/to/file1.ts path/to/file2.ts
git commit -m "<type>: <message>"
```

For files that need **partial staging** (rare — only when a single file contains changes belonging to different logical groups), use `git add -p` is NOT available in non-interactive mode. Instead, accept that the file goes into whichever commit makes the most sense. Prefer keeping files whole in one commit.

#### Step 5: Verify

After all commits are created:

```bash
# Verify no uncommitted changes remain
git status

# Verify the cumulative diff matches the original
git diff main...HEAD --stat
git diff main...backup-before-rewrite --stat
```

Both stat outputs should be identical. If they differ, something was missed — investigate before proceeding.

#### Step 6: Report

Present a summary:
- Number of original commits → number of new commits
- List each new commit with its hash and message
- Confirm the backup branch name
- Note that the user can delete the backup branch once satisfied: `git branch -d backup-before-rewrite`

## Important Safety Rules

- **ALWAYS create a backup branch** before resetting
- **NEVER force-push** without explicit user permission — the rewrite only affects local history
- **NEVER proceed past Phase 3** without user approval
- If `git status` shows uncommitted changes before starting, STOP and ask the user to commit or stash first
- If the branch has already been pushed and has open PRs, warn the user that a force-push will be needed after the rewrite

## Error Recovery

If something goes wrong during execution:

```bash
# Abort: restore the original branch state
git reset --hard backup-before-rewrite
```

Always inform the user about this escape hatch before starting execution.

## Additional Resources

### Reference Files

- **`references/grouping-strategies.md`** — Detailed patterns for grouping files in monorepos, handling edge cases like shared types, migrations, and cross-cutting concerns

### Scripts

- **`scripts/analyze-branch.sh`** — Analyzes branch commits, file overlap, and directory distribution
