# Session Manager Plugin

A Claude Code plugin for session management and project initialization. Generate project primers, save work context, and search across past sessions.

## Commands

| Command | Description |
|---------|-------------|
| `/session-manager:init [--force]` | Generate a project primer by analyzing codebase |
| `/session-manager:session-save [name]` | Save current session with context |
| `/session-manager:session-load [id]` | Load a previous session |
| `/session-manager:session-list [filter]` | Browse all sessions |
| `/session-manager:session-search [term]` | Search session history |
| `/session-manager:ui-review` | Review UI screenshots |

## Project Initialization

Run `/session-manager:init` in any project to auto-generate a primer:

```
.claude/
  PRIMER.md          # Auto-generated project overview
```

The primer includes:
- Tech stack detection (language, framework, package manager)
- Project structure analysis
- Common commands (dev, build, test)
- Conventions observed in the codebase

Re-run with `--force` after major changes to regenerate.

## How It Works

Sessions are stored in `.claude/sessions/` in your project:

```
.claude/
  sessions/
    index.md                    # Quick reference of all sessions
    2026-01-05_add-auth/
      SESSION.md                # Main session record
      context.md                # Key code patterns
    2026-01-04_fix-bug/
      SESSION.md
      context.md
```

## Installation

### Option 1: Local Plugin (Development)
```bash
claude --plugin-dir ~/.claude/plugins/local/session-manager
```

### Option 2: Global via Settings
Add to `~/.claude/settings.json`:
```json
{
  "plugins": ["~/.claude/plugins/local/session-manager"]
}
```

### Option 3: Create Your Own Marketplace
Push this plugin to a GitHub repo and use:
```
/plugin marketplace add your-username/your-repo
```

## Why Use This?

- **Context preservation**: Don't lose important decisions between sessions
- **Faster onboarding**: Load previous context instead of re-explaining
- **Searchable history**: Find past solutions to similar problems
- **Team knowledge**: Share sessions with your team via git
