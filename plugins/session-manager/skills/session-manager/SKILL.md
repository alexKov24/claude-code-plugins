---
name: session-manager
description: Session management and project initialization for any codebase. Use when the user wants to save the current session context for later, load a previous session to restore work context, browse or search session history, initialize a project primer by auto-detecting the tech stack, or review UI screenshots for design feedback.
---

# Session Manager

Manage work sessions and project context across conversations. Sessions are stored in `.claude/sessions/` inside the project.

## Commands

### Initialize Project Primer

Analyze the current project and generate `.claude/PRIMER.md`:

1. Check if `.claude/PRIMER.md` exists. If it does and `--force` was NOT passed, stop and inform the user.
2. Gather project info in parallel:
   ```bash
   ls package.json pnpm-lock.yaml yarn.lock Cargo.toml go.mod requirements.txt 2>/dev/null
   git remote -v 2>/dev/null && git branch --show-current 2>/dev/null
   ls -la
   ls README.md CONTRIBUTING.md docs/ .claude/ 2>/dev/null
   ```
3. Detect tech stack from files found (Next.js, Vite, WXT, Tailwind, Rust, Go, Python, etc.).
4. Read a few representative source files to understand naming conventions and code style.
5. Generate `.claude/PRIMER.md` with: Quick Start commands, Tech Stack table, Project Structure, Key Directories, Architecture Notes, Common Tasks, Conventions, Environment Variables, and Important Files.
6. Output a summary of what was detected and the path to the primer.

Re-run with `--force` to regenerate after major changes.

### Save Session

Document the current conversation as a reusable record in `.claude/sessions/`:

1. Review the conversation and identify: what was accomplished, why, how (key decisions), and gotchas.
2. Generate a session ID: `YYYY-MM-DD_short-description` (use the user's argument if given, else derive from work done, lowercase + hyphens, max 30 chars).
3. Create `.claude/sessions/[session-id]/SESSION.md` with: Date, Branch, Status (completed/in-progress/blocked), Summary, Goal, What Was Done (checklist), Key Decisions (with rationale), Files Modified, How to Continue, and Related Sessions.
4. Create `.claude/sessions/[session-id]/context.md` with key code patterns, reference files, and external resources.
5. Append a row to `.claude/sessions/index.md` (create with headers if missing).
6. Output confirmation and the command to reload this session.

### Load Session

Restore context from a previous session:

1. If an argument was given, find a matching session in `.claude/sessions/` (partial match is fine).
2. If no argument, read `index.md` and show the 5 most recent sessions, then ask which to load.
3. Read all files in the session directory: `SESSION.md`, `context.md`, `decisions.md`.
4. Run `git log --oneline [session-date]..HEAD` and `git status` to show what changed since.
5. Present: Original Goal, What Was Done, Key Decisions, Files Modified, Changes Since Session, Current State, and suggested next steps.

### List Sessions

Browse all saved sessions:

1. Read `.claude/sessions/index.md`. If missing, scan `.claude/sessions/*/SESSION.md` directly.
2. If an argument was given, filter by session ID or summary containing the term.
3. Present a Markdown table: Date | Session | Summary | Status.
4. Highlight any in-progress sessions.
5. If a filter matches exactly one session, show full detail for that session.

### Search Sessions

Search across all session files for a term:

1. Require a search argument — if missing, ask for one.
2. Search case-insensitively across `.claude/sessions/*/SESSION.md`, `context.md`, and `decisions.md`.
3. Present results grouped by session with surrounding context lines for each match.
4. Suggest related terms for common topics (e.g. "auth" → also check "login", "jwt").
5. If no results, suggest alternative terms and link to session list.

### UI Review

Review a UI screenshot the user pastes:

Analyze for:
- **Spacing & Alignment** — consistent padding, alignment issues
- **Typography** — hierarchy, font size appropriateness
- **Color & Contrast** — palette consistency, accessibility
- **Clarity & UX** — affordances, information density, error state readiness

Output format:
```
## Overall Impression
[1-2 sentences]

## Issues Found
1. [ISSUE]: Description
   Fix: Specific Tailwind class / component pattern suggestion

## Quick Wins
- Easy improvements list

## Optional Enhancements
- Nice-to-haves
```

Be direct and specific. Skip praise — focus on actionable improvements.

## Session Storage Layout

```
.claude/
  PRIMER.md                       # Auto-generated project primer
  sessions/
    index.md                      # One-line summary of every session
    2026-01-05_add-auth/
      SESSION.md                  # Main record
      context.md                  # Key code patterns & references
    2026-01-04_fix-bug/
      SESSION.md
      context.md
```
