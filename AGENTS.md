# Working on the HexaBlock mobile client

## Start here

Read the [assessed scope](docs/specs/requirements.md), the relevant use case under `docs/specs/use-cases/` and the [v5 class model](docs/diagrams/README.md). The team confirmed the professor removed Hexa Fit. Deliver Lines, Sort and Merge. Treat the model as the design baseline and the implementation and tests as evidence of current behaviour.

## Architecture

- Keep geometry, board, turn sequencing and variant rules in pure Dart in `hexa_engine`. Keep Flutter, SQLite and HTTP in outer layers.
- Preserve `TCell`, `TMove` and `TState` through the engine and `TPiece` through the factory. Register variants at composition time. Supply a cell renderer and input mapping per module.
- Copy board and RNG state on accepted turns. A rejected move preserves board, score, history and RNG. One Merge undo restores the accepted snapshot. Use fixed seeds and prove replay reproduces the tile and its coordinate.
- For Sort, implement the confirmed top-run and tie rules in the model. Share the level envelope with the API and validate downloaded levels before play.

## Working agreement

1. Start behaviour changes from an approved use case. Name the acceptance checks and unresolved decisions. Use the existing [phase workflow](harness/README.md) for implementation approval.
2. Keep a PR to one outcome. Ask before adding dependencies or changing a shared contract. Humans own the architectural decisions, review, commits and pushes unless explicitly delegated.
3. Use Arrange–Act–Assert and `should_<result>_when_<condition>`. The reviewer checks one main flow, a boundary case and the relevant architecture constraint. Record actual results and anything untested.
4. Update the README and editable diagrams if the design changes. For significant AI use, add a task entry and index it in [AI_USAGE.md](AI_USAGE.md). Link the PR, distinguish generated work from human changes, and use only the model identifier actually reported by the tool.

## Verification

From the workspace root run `dart format --output=none --set-exit-if-changed .` and `flutter analyze`. Run `dart test` inside each package with tests and `flutter test` from `app/`. For UI, audio and networking, record a device or emulator observation. For a documentation-only change, check local links, render edited Mermaid files and compare every image with its source.
