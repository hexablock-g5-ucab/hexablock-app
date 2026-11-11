# AGENTS.md — HexaBlock Suite client

Rules for every AI agent and every human in this repository. Keep this file short; add a rule each
time an agent does something it must never repeat.

## Product
Four hexagonal puzzle variants on ONE generic engine. The jury will ask us to add a fifth variant live.

## Architecture (non-negotiable)
- Packages: `hexa_engine` (pure Dart) ← `hexa_application` ← `hexa_infrastructure` ← `app`.
- `hexa_engine` never imports Flutter, drift, dio or any other package of ours.
- No `if`/`switch` on the game variant inside the engine or the generic use cases.
  Variability goes through Strategy (`IGameRules`, `IScoringPolicy`, `IPieceSource`) and Abstract Factory.
- State is immutable: boards are copied, never mutated. Randomness only through `IRandom`.
- Every generic bound must be justified in `docs/EXTENSIBILITY.md`.

## Process
- Behaviour changes start in `docs/specs/use-cases/UC-xxx.md`. Do not implement Draft use cases.
- Follow `harness/README.md` for every phase. Wait for approval before writing code.
- Tests: AAA, `should_<result>_when_<condition>`, grouped by UC id, fixed seeds, fakes for ports.
- Never add a dependency without approval. Never commit, push or touch remotes.
- When done: list files changed and the FR/UC ids covered; draft the AI log entry.

## Commands
```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
(cd packages/hexa_engine && dart test)
(cd app && flutter test)
```
