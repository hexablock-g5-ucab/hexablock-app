# ADR-0002 — Clean layers as Dart packages

- Status: Proposed
- Date: 2026-11-13

## Decision
`hexa_engine` ← `hexa_application` ← `hexa_infrastructure` ← `app`, plus an architecture test.
## Consequences
Outward imports fail to compile; more pubspec files to maintain.
