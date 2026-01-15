---
description: Browse session history - see all saved sessions with summaries
argument-hint: [filter]
---

# List Session History

Browse all saved sessions to find relevant context or continue previous work.

## Instructions

### Step 1: Read Session Index

Read `.claude/sessions/index.md` to get the session list.

If it doesn't exist, scan `.claude/sessions/` for directories and read their SESSION.md files.

### Step 2: Apply Filter (if provided)

If `$ARGUMENTS` is provided, filter sessions by:
- Session ID containing the term
- Summary containing the term
- Status matching (completed, in-progress, blocked)

### Step 3: Present Session List

Output in this format:

```markdown
## Session History

### Recent Sessions

| Date | Session | Summary | Status |
|------|---------|---------|--------|
| 2026-01-05 | `fix-cookie-refresh` | Fixed cookie refresh... | completed |
| 2026-01-04 | `add-user-auth` | Implemented JWT auth... | in-progress |
| 2026-01-03 | `refactor-api` | Migrated to Zod schemas | completed |

### In-Progress Sessions
[List any sessions marked in-progress - these might need continuation]

### Quick Actions
- `/session-manager:session-load [session-id]` - Load a session's context
- `/session-manager:session-save [description]` - Save current session
- `/session-manager:session-search [term]` - Search session content

### Statistics
- Total sessions: X
- In-progress: Y
- This week: Z
```

### Step 4: If No Sessions Found

```markdown
## No Sessions Found

No sessions have been saved yet.

To save your first session:
  /session-manager:session-save my-first-session

This will document what was done in this conversation for future reference.
```

### Step 5: Detailed View (if filter matches one session)

If the filter matches exactly one session, show more detail:

```markdown
## Session: [session-id]

**Date**: YYYY-MM-DD
**Status**: [status]
**Branch**: [branch]

### Summary
[Full summary from SESSION.md]

### What Was Done
[Task list from SESSION.md]

### Key Decisions
[Decisions from SESSION.md]

---

Load this session?
  /session-manager:session-load [session-id]
```

## Tips for Users

Include in output if helpful:
- Sessions are stored in `.claude/sessions/`
- Each session has a SESSION.md with full details
- Use descriptive names when saving sessions
- Mark sessions as in-progress if work isn't finished
