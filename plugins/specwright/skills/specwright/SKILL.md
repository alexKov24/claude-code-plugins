---
name: specwright
description: Spec-driven development pipeline. Translates a raw idea into a structured YAML spec, scrutinizes it for holes, then produces a vetted implementation plan before any code is touched. Auto-triggers when the user wants to build, create, implement, add, design, or plan a feature, component, or system change.
---

# Specwright

Turns a raw idea into a structured spec → scrutiny → plan pipeline.
The spec is the artifact. Code is disposable output. You review intent, not implementation.

## Principles

- Never start planning until the spec is written and scrutinized.
- Read project context (CLAUDE.md, README.md, docs/) before writing anything — specs that contradict existing patterns are worthless.
- Intake is a conversation, not a form — 3–4 targeted questions max. Stop when intent is clear.
- Every plan step must trace back to a spec behavior, constraint, or success criterion.
- Save all specs to `docs/plans/` so they live with the project history.

---

## Phase 0 — Load project context

Before intake, read:
- `CLAUDE.md` or `README.md` — stack, patterns, conventions, decision rules
- `docs/architecture.md` — data flow and design decisions (if present)
- `docs/directory-structure.md` — where things live (if present)

This prevents specs that reinvent existing patterns or place files in the wrong location.
Skip files that don't exist. One pass is enough — don't over-explore.

---

## Phase 1 — Idea intake

Ask **targeted questions only**. Stop when you have enough to fill the spec template.

**For a feature** (multi-file, user-visible flow):
1. What does it do from the user's perspective? (1–2 sentences)
2. What triggers it? (user action, route load, background event)
3. What are the failure modes you care about?
4. Any hard constraints? (must reuse X, must not touch Y, performance requirement)

**For a component** (single UI unit):
1. Where does it live and what page/section is it part of?
2. What data does it receive or emit?
3. What states must it handle? (empty, loading, error, filled)

**Rules:**
- Don't ask about things you can infer from reading the codebase.
- Don't ask more than 4 questions total.
- If the user's original message already answers most questions, skip the ones already answered.

---

## Phase 2 — Spec generation

Write a YAML spec and save it to `docs/plans/<kebab-case-name>-spec.yaml`.

### Feature spec template

```yaml
type: feature
name: kebab-case-name
title: Human Readable Title

description: |
  What this feature does from the user's perspective.
  Why it exists.

behavior:
  - Concrete, testable behavior statement
  - Another behavior statement (user can do X, system does Y when Z)

constraints:
  - Stack/pattern constraints inferred from CLAUDE.md
  - Constraints provided by the user

edge_cases:
  - What happens when data is null/empty/missing
  - Error states and how they surface to the user
  - Concurrent or race conditions if relevant

success_criteria:
  - User can do X and sees Y
  - State is persisted correctly across reload
  - Error state is handled gracefully (not a blank screen)

scope:
  components:
    - src/components/...        # new or modified, with reason
  routes:
    - path: /api/...
      method: POST
      auth: required
  stores:
    - src/stores/...            # Zustand stores touched
  db:
    - none                      # or: describe Prisma schema changes

out_of_scope:
  - Things explicitly excluded from this spec
```

### Component spec template

```yaml
type: component
name: ComponentName
file: src/components/path/ComponentName.tsx

description: |
  What this component renders and why.

props:
  required:
    - name: type
  optional:
    - name?: type

states:
  empty: what renders when there's no data
  loading: skeleton or spinner behavior
  error: how errors surface
  populated: normal render

behavior:
  - What happens on user interaction

constraints:
  - Inferred from CLAUDE.md (e.g. use HeroUI, must be 'use client')

success_criteria:
  - Renders correctly in all four states
  - Handles missing optional props without crashing
```

---

## Phase 3 — Spec scrutiny

Review the spec as a second engineer who has to implement it cold. Check:

**Completeness**
- Are all behavior statements concrete enough to implement without guessing?
- Does every edge case have a resolution (not just "handle empty state" — what renders)?
- Does the scope list every file that will actually change?
- Are success criteria verifiable, or are they just restatements of behaviors?

**Coherence with codebase**
- Does this spec conflict with any decision in CLAUDE.md?
- Does it duplicate something that already exists?
- Are proposed file locations consistent with the directory structure?
- Does it introduce a new pattern where an existing one applies?

**Ambiguity**
- Any behavior statement interpretable two different ways?
- Any constraint vague enough to be silently ignored during implementation?
- Any scope item that's underspecified (e.g. "update the store" — which fields, what shape)?

Output format:

```
## Spec Scrutiny

### 🔴 Blockers
Issues that make the spec unimplementable or contradictory as written.

### 🟡 Risks
Vague or incomplete areas likely to cause bad codegen, wrong behavior, or rework.

### 🟢 Notes
Minor improvements that aren't blocking.

### Verdict: Ready | Revise
```

If **Revise** — update the spec file, show the diff, then re-run scrutiny on the changed sections.
Only proceed to Phase 4 when verdict is **Ready**.

---

## Phase 4 — Implementation plan

With the spec as source of truth, produce a numbered implementation plan.

Rules:
- Every step references a specific file and function/section.
- Every step traces to a spec behavior, constraint, or success criterion (add a short `# why` comment if not obvious).
- Order steps so each one builds on the previous — no step should depend on a later one.
- Include schema changes (Prisma) before the code that depends on them.
- Include new dependencies before the files that import them.

Format:

```
## Plan

1. [file/function] — what to do and why (traces to spec behavior X)
2. ...

### Files to modify
- path/to/file — reason

### New files
- path/to/new/file — purpose

### Dependencies
- package to add/update, if any

### Key decisions
- Non-obvious choices made during planning
```

After writing the plan, apply scrutineer-plan style scrutiny to it:

```
## Plan Scrutiny

### 🔴 Blockers
### 🟡 Risks
### 🟢 Notes

### Verdict: Ready | Revise | Rethink
```

See [references/scrutiny-guide.md](references/scrutiny-guide.md) for the full scrutiny checklist.

---

## Phase 5 — Verdict and execution

Present the final verdict to the user:

- **Ready** → ask: "Execute now with ant colony, or do you want to review first?"
- **Revise** → surface the blockers, update spec or plan, re-scrutinize changed sections only
- **Rethink** → surface the deeper issue, explain why the approach is wrong, offer to restart from Phase 1

If executing via ant colony, pass both the spec file path and the plan as context in the colony goal.

---

## Spec file lifecycle

- Active specs live in `docs/plans/<name>-spec.yaml`
- When implementation is complete and verified, move spec to `docs/plans/done/<name>-spec.yaml`
- Specs are source of truth for future changes — if a feature needs modification, update the spec first
