---
name: project_baseline
type: context
---
# Project Baseline

- Product: HexaBlock Suite — four hexagonal puzzle variants (Lines, Fit, Sort, Merge) on ONE generic engine.
- Deadline: Monday 2026-12-14. Reviews with the professor every Friday.
- Immutable rules: see `AGENTS.md`.

## Commands

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
(cd packages/hexa_engine && dart test)
(cd app && flutter test)
```

## Test baseline

| Date | Tests passing | Coverage |
| --- | --- | --- |
| 2026-11-11 | 0 | — |
