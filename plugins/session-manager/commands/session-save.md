---
description: Save current session to history with summary of what was done, why, and how
argument-hint: [short-description]
---

# Save Session to History

Document this conversation as a reusable session record for future context.

## Instructions

### Step 1: Analyze the Conversation

Review the entire conversation and identify:

1. **What was accomplished** - List concrete outcomes (files created/modified, features implemented, bugs fixed)
2. **Why it was done** - The user's original goal or problem being solved
3. **How it was done** - Key technical decisions, patterns used, approaches taken
4. **Key learnings** - Gotchas, important context, or decisions that would help future sessions

### Step 2: Generate Session ID

Create a session ID using this format:
```
YYYY-MM-DD_short-description
```

Use the argument `$ARGUMENTS` as the short description if provided, otherwise generate one from the work done (use lowercase, hyphens, max 30 chars).

Example: `2026-01-05_add-user-auth` or `2026-01-05_fix-cookie-refresh`

### Step 3: Create Session Files

Create the following structure in `.claude/sessions/[session-id]/`:

#### SESSION.md (main file)
```markdown
# Session: [Title]

**Date**: YYYY-MM-DD
**Branch**: [git branch name]
**Status**: completed | in-progress | blocked

## Summary
[2-3 sentence overview of what was accomplished]

## Goal
[What the user wanted to achieve - the "why"]

## What Was Done
- [ ] Task 1 that was completed
- [ ] Task 2 that was completed
- [x] Task 3 still in progress (if any)

## Key Decisions
1. **Decision**: [What was decided]
   **Rationale**: [Why this approach was chosen]

## Files Modified
- `path/to/file.ts` - [brief description of changes]
- `path/to/another.ts` - [brief description]

## How to Continue
[If work is incomplete, what's the next step?]

## Related Sessions
[Link to related previous sessions if any]
```

#### context.md (key code/patterns)
```markdown
# Key Context for This Session

## Important Code Patterns

[Include key code snippets that were central to this work]

## Reference Files
- `path/to/important/file.ts` - Why it matters

## External Resources
- [Any URLs, docs, or references used]
```

### Step 4: Update Session Index

Append to `.claude/sessions/index.md`:
```markdown
| [session-id] | [one-line summary] | [status] |
```

Create the index file if it doesn't exist with headers:
```markdown
# Session History

| Session | Summary | Status |
|---------|---------|--------|
```

### Step 5: Output Confirmation

After saving, output:
```
Session saved: [session-id]
Location: .claude/sessions/[session-id]/

To continue this work later:
  /session-manager:session-load [session-id]

To browse all sessions:
  /session-manager:session-list
```

## Important Notes

- Be thorough but concise - future Claude instances will read this
- Include enough context that someone unfamiliar can understand
- Focus on decisions and rationale, not just what files changed
- If the session is incomplete, mark it clearly so it can be continued
