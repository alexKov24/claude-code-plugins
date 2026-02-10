---
description: Rewrite messy git commit history into clean, logical commits grouped by feature area
argument-hint: [base-branch (default: main)]
---

# Rewrite Commit History

Reorganize a messy feature branch into clean, logical commits grouped by feature area.

## Instructions

### Step 0: Pre-flight Checks

Verify the working tree is clean:

```bash
git status --porcelain
```

If there are uncommitted changes, STOP and ask the user to commit or stash first.

Verify we're not on the base branch:

```bash
git rev-parse --abbrev-ref HEAD
```

If on `main` (or the specified base branch), STOP and ask the user to switch to a feature branch.

Set the base branch from `$ARGUMENTS` (default to `main` if empty).

Check if the branch has been pushed to a remote:

```bash
git log --oneline origin/$(git rev-parse --abbrev-ref HEAD)..HEAD 2>/dev/null
```

If the branch exists on the remote, warn that a force-push will be needed after the rewrite.

### Phase 1: Analyze

Run the analysis script:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/rewrite-history/scripts/analyze-branch.sh [base-branch]
```

Then read the actual diffs to understand what changed semantically:

```bash
git diff [base-branch]...HEAD
```

Review original commit messages for context:

```bash
git log [base-branch]..HEAD
```

### Phase 2: Plan

Using the analysis, propose a new commit structure. Group changes by **feature area**.

Read `${CLAUDE_PLUGIN_ROOT}/skills/rewrite-history/references/grouping-strategies.md` for detailed grouping patterns.

#### Grouping Principles

1. **Backend endpoint + dependencies** — route, controller, service, migration, types → one commit
2. **Frontend feature** — component, hook, styles, translations → one commit
3. **Shared/infrastructure** — config, shared utilities, package changes → one commit
4. **Tests** — with their feature commit, or separate if spanning multiple features
5. **Cleanup/refactoring** — separate from feature work

#### Present the Plan

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
```

Rules:
- Every file from the cumulative diff MUST appear in exactly one commit
- Order: infrastructure first, then core features, then UI, then tests
- Each commit message explains **why**, not just **what**
- Use conventional commit types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`

### Phase 3: Approve

Present the plan and **wait for explicit user approval**. The user may:
- **Approve** — proceed to execution
- **Request changes** — adjust groupings, rename, reorder
- **Add context** — provide additional commit message details

Do NOT proceed without approval. This is a destructive operation.

### Phase 4: Execute

#### Step 1: Safety backup

```bash
git branch backup-before-rewrite
```

Inform the user: restore with `git reset --hard backup-before-rewrite` if anything goes wrong.

#### Step 2: Soft reset to base

```bash
git reset --soft [base-branch]
```

#### Step 3: Unstage everything

```bash
git reset HEAD .
```

#### Step 4: Create commits

For each planned commit, stage its files and commit:

```bash
git add path/to/file1.ts path/to/file2.ts
git commit -m "<type>: <message>"
```

Keep files whole — do not attempt partial staging.

#### Step 5: Verify

```bash
git status
git diff [base-branch]...HEAD --stat
git diff [base-branch]...backup-before-rewrite --stat
```

Both stat outputs must be identical. If they differ, investigate before continuing.

#### Step 6: Report

Present:
- Original commit count → new commit count
- Each new commit with hash and message
- Backup branch name (`backup-before-rewrite`)
- Cleanup command: `git branch -d backup-before-rewrite`

## Error Recovery

If anything goes wrong:

```bash
git reset --hard backup-before-rewrite
```

Always mention this escape hatch before starting execution.
