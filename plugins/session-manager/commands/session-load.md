---
description: Load context from a previous session to continue work or reference past decisions
argument-hint: [session-id]
---

# Load Session Context

Restore context from a previous session to continue work or understand past decisions.

## Instructions

### Step 1: Identify the Session

If `$ARGUMENTS` is provided:
- Look for a session matching that ID in `.claude/sessions/`
- Support partial matching (e.g., "auth" matches "2026-01-05_add-user-auth")

If no argument provided:
- Read `.claude/sessions/index.md` and show the 5 most recent sessions
- Ask the user which one to load

### Step 2: Load Session Files

Read all files in the session directory:
- `SESSION.md` - Main session record
- `context.md` - Key code patterns and references (if exists)
- `decisions.md` - Decision log (if exists)

### Step 3: Gather Current State

Run these to understand what's changed since the session:
```bash
git log --oneline [session-date]..HEAD --  # Commits since session
git status                                   # Current state
```

### Step 4: Present Context Summary

Output in this format:

```markdown
## Session Loaded: [session-id]

### Original Goal
[From SESSION.md]

### What Was Done
[Summary of accomplishments]

### Key Decisions Made
[Important decisions and their rationale]

### Files That Were Modified
[List of files with brief descriptions]

---

### Changes Since This Session
[Git commits since session date, if any]

### Current State
[Git status summary]

---

### Ready to Continue

Based on this session, I understand:
- [Key context point 1]
- [Key context point 2]
- [Key context point 3]

How would you like to proceed?
- Continue where we left off: [next suggested step from SESSION.md]
- Start fresh but with this context in mind
- Something else?
```

### Step 5: If Session Not Found

If no matching session found:
```
No session found matching "$ARGUMENTS"

Available sessions:
[List from index.md]

Try:
  /session-manager:session-load [exact-session-id]
  /session-manager:session-list  # to browse all sessions
```

## Important Notes

- Read files before presenting - don't summarize from memory
- Check if any files mentioned in the session have been modified since
- If the session was marked "in-progress", highlight what was left to do
- Suggest reading specific files if they're crucial to continuing
