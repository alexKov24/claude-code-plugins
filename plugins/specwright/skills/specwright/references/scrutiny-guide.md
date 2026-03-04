# Plan Scrutiny Reference

Use this checklist during Phase 4 plan scrutiny. Flag real issues only — don't invent problems.

## Logical holes

- Missing branches: what happens when a value is null, undefined, empty, or unexpected type?
- Assumptions that won't hold at runtime or under concurrent load
- Ordering dependencies between steps — does step 4 require step 6 to have run first?
- Race conditions in async flows (optimistic updates, parallel fetches)

## Stack & dependencies

- Deprecated packages or APIs used in the plan
- Version mismatches or peer dependency conflicts
- Missing `await` on async calls, or sync/async boundary mismatches
- Node/runtime version requirements the plan implicitly depends on

## Undefined flows

- Error cases that aren't handled — what breaks, swallows silently, or leaves state dirty?
- Missing rollback or cleanup for partial failures mid-plan
- Unhandled edge cases in data shapes (empty arrays, null API responses, pagination edge cases)
- Events or callbacks that can fire before initialization is complete
- Optimistic UI updates that don't roll back on server error

## Architectural coherence

- Does this fit existing patterns, or introduce a conflicting new one?
- Existing utilities or abstractions the plan duplicates instead of reusing
- Unintended ripple effects — modules, tests, or consumers that break as a side-effect
- Is the change correctly scoped, or does it pull in more surface area than necessary?

## Spec traceability

- Every plan step should trace to a spec behavior, constraint, or success criterion
- If a step has no traceable spec origin, it either shouldn't be there or the spec is missing something
- Steps that implement "nice to have" things not in the spec should be flagged
