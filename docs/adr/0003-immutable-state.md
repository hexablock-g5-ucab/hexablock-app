# ADR-0003 — Immutable game state and snapshots

- Status: Proposed
- Date: 2026-11-13

## Decision
Every turn returns a new state; undo restores snapshots (boards have at most 61 cells).
## Alternatives considered
Mutable board + inverse commands.
