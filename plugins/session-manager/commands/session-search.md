---
description: Search across all session history for specific topics, decisions, or code patterns
argument-hint: [search-term]
---

# Search Session History

Search across all saved sessions to find relevant context, past decisions, or code patterns.

## Instructions

### Step 1: Validate Search Term

If `$ARGUMENTS` is empty:
```
Please provide a search term:
  /session-manager:session-search authentication
  /session-manager:session-search "cookie refresh"
  /session-manager:session-search zod schema
```

### Step 2: Search All Session Files

Use grep/search to find matches in:
- `.claude/sessions/*/SESSION.md`
- `.claude/sessions/*/context.md`
- `.claude/sessions/*/decisions.md`

Search for `$ARGUMENTS` (case-insensitive).

### Step 3: Present Results

```markdown
## Search Results for "$ARGUMENTS"

Found X matches in Y sessions:

### Session: [session-id-1]
**File**: SESSION.md
**Context**:
> ...matching text with **highlighted** search term...

**File**: context.md
**Context**:
> ...another match with **highlighted** term...

---

### Session: [session-id-2]
**File**: decisions.md
**Context**:
> ...matching text...

---

## Quick Load
To load any of these sessions:
  /session-manager:session-load [session-id]
```

### Step 4: If No Results

```markdown
## No Results for "$ARGUMENTS"

No sessions mention "$ARGUMENTS".

### Suggestions
- Try different terms: [suggest related terms if obvious]
- Check spelling
- Use broader terms

### Browse All Sessions
  /session-manager:session-list
```

### Step 5: Smart Suggestions

If searching for common topics, suggest related sessions even if not exact match:
- "auth" -> also show sessions mentioning "login", "jwt", "session"
- "api" -> also show sessions mentioning "endpoint", "route", "handler"
- "bug" -> also show sessions mentioning "fix", "issue", "error"

## Search Tips (include in output)

```
Search tips:
- Use quotes for phrases: /session-manager:session-search "cookie refresh"
- Search is case-insensitive
- Searches SESSION.md, context.md, and decisions.md
```
