# Grouping Strategies for Commit Rewriting

Detailed patterns for deciding how to group files into logical commits.

## Monorepo Patterns

In monorepos with `packages/`, `apps/`, or similar structures, use the top-level directory as a primary grouping signal.

### Backend Changes

Group together:
- Route definitions (`routes/`, `router/`)
- Controllers/handlers for those routes
- Service layer functions called by those handlers
- Database migrations related to the feature
- TypeScript types/interfaces for request/response
- Middleware specific to the feature

Example commit:
```
feat: add notification preferences API

- routes/notifications.ts (new route)
- controllers/notificationPreferences.ts (handler)
- services/notificationService.ts (business logic)
- migrations/20240101_add_notification_prefs.ts
- types/notifications.ts (request/response types)
```

### Frontend Changes

Group together:
- React components (`.tsx`)
- Hooks used exclusively by those components
- Styles/CSS modules for those components
- Translation keys added for those components
- Navigation/routing changes to reach those components

Example commit:
```
feat: notification preferences UI

- components/NotificationSettings/index.tsx
- components/NotificationSettings/styles.ts
- hooks/useNotificationPreferences.ts
- translations/en/notifications.json
- navigation/settingsStack.ts (added route)
```

### Shared/Infrastructure

Group together:
- Shared types used by multiple features
- Utility functions
- Package dependency changes (`package.json`, lockfile)
- Configuration changes (`.env.example`, config files)
- CI/CD changes
- Docker/compose changes

Example commit:
```
chore: add shared notification types and dependencies

- packages/shared/types/notifications.ts
- package.json (added dependency)
- yarn.lock
```

## Edge Cases

### Shared Types File

If a types file is imported by both backend and frontend:
- Place it in the **first commit that introduces the types** (usually backend/infrastructure)
- Note in the commit message that these types are shared

### Migration Files

- If a migration is tightly coupled to one feature → include with that feature
- If a migration supports multiple features → put in an infrastructure commit early in the sequence

### Config/Environment Changes

- `.env.example` changes → infrastructure commit
- Docker compose changes → infrastructure commit
- Package.json changes → with the feature that needs them, unless multiple features need them

### Translation Files

- Translations go with the frontend component that uses them
- If one translation file has keys for multiple components, it goes with the primary component

### Test Files

Two strategies:
1. **Tests with feature** (preferred): Test files go in the same commit as the code they test
2. **Tests separate**: If tests span multiple features or are extensive, create a dedicated test commit at the end

### Refactoring Mixed with Features

If the branch contains both refactoring and new features:
1. Put pure refactoring in early commits (e.g., `refactor: extract notification service from user controller`)
2. Put new features in later commits that build on the refactoring
3. This tells a clearer story: "first I restructured, then I built on top"

## Commit Ordering

Preferred order within a rewritten branch:

1. **Infrastructure/config** — dependencies, docker, CI
2. **Database** — migrations, schema changes (if standalone)
3. **Shared types/utilities** — types used across packages
4. **Backend core** — API endpoints, services, business logic
5. **Frontend core** — components, hooks, screens
6. **Integration** — wiring frontend to backend, navigation
7. **Tests** — if kept separate
8. **Cleanup** — linting, formatting, minor fixes

This ordering ensures each commit can conceptually "stand alone" — later commits build on earlier ones.

## Handling Deleted Files

- If files were created then deleted within the branch, they won't appear in the cumulative diff — ignore them
- If files were deleted as part of a refactor, include the deletion in the refactor commit
- If files were renamed/moved, include both the deletion and creation in the same commit

## Monorepo-Specific Signals

### Directory-Based Grouping Hints

```
client-app/     → frontend commits
main-backend/   → backend commits
packages/shared/ → shared infrastructure commits
migrations/     → database commits
test-tools/     → test/tooling commits
docker-compose* → infrastructure commits
```

### Cross-Package Changes

When a single logical change spans multiple packages (e.g., adding a field that touches shared types, backend API, and frontend form):
- Prefer **one commit per logical change** spanning packages over one commit per package
- Example: `feat: add email field to user profile` touching `shared/types`, `backend/routes`, `frontend/components` is better as one commit than three

## Conflict with Atomicity

Sometimes the "group by feature area" principle conflicts with "each commit should compile":
- If a frontend component imports a shared type that only exists in a later commit, the earlier commit won't compile
- Resolution: Put shared dependencies in earlier commits, even if they logically "belong" to the frontend feature
- In practice, order commits so dependencies come first
