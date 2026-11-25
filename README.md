# HexaBlock Suite · mobile game

![Client CI](https://github.com/hexablock-g5-ucab/hexablock-app/actions/workflows/ci.yml/badge.svg)
![Test suites](https://img.shields.io/badge/tests-engine%20%7C%20widget-blue)
![License](https://img.shields.io/badge/license-MIT-green)

HexaBlock is a Flutter puzzle suite designed around one hexagonal board and turn engine. **Lines** clears rows on three axes, **Sort** transfers coloured chips between stacks, and **Merge** slides number tiles in six directions.

**Development status.** The Flutter starter, Dart workspace, architecture check and CI workflows are in place. The class model describes the implementation target. Screenshots and playable demos will accompany the corresponding game features. [Assessment scope](docs/specs/requirements.md) · [Backend](https://github.com/hexablock-g5-ucab/hexablock-api)

## Getting started

Use Flutter stable with Dart 3.14 or a compatible later Dart 3 release, Node.js with npm for Git hooks, and an emulator or connected device. From the client checkout:

```sh
npm ci
flutter pub get
cd app
flutter run
```

## Architecture

The engine owns geometry and game rules. Application use cases coordinate sessions and declare ports. Adapters translate storage, network data and gestures. The Flutter app wires these components together.

![Clean Architecture layers and inward dependencies](docs/diagrams/clean-architecture.png)

[Editable source](docs/diagrams/clean-architecture.mmd)

## Generic engine

| Variant | Cell | Move | State | Piece source produces |
| --- | --- | --- | --- | --- |
| Lines | TileColor | PlacePiece | LinesState | `Piece<TileColor>` |
| Sort | ColorStack | PlaceStack | SortState | ColorStack |
| Merge | MergeTile | Slide | MergeState | MergeTile |

An absent board entry represents an empty cell, so `TCell extends Object`. The bound `TState extends GameState<TCell>` gives the engine access to its typed board. A fourth factory parameter, `TPiece`, ties the source to its rules. Only the slide resolver requires `T extends Mergeable<T>`. [Extension walkthrough](docs/EXTENSIBILITY.md)

## Class model

The four-layer design covers 178 classes and 384 relationships. Yellow identifies domain classes, purple application, green interfaces and blue infrastructure.

[Interactive HTML](docs/diagrams/class-diagram-app.html) · [Vector PDF](docs/diagrams/class-diagram-app.pdf) · [Model guide](docs/diagrams/README.md)

Download the HTML from GitHub and open it locally to search classes, inspect members and follow relationships. The first PDF page contains the whole model; the following pages index relationships by source class.

## Design patterns, SOLID and AOP

Abstract Factory assembles compatible families. Strategy selects rules and scoring. Template Method defines a common turn sequence. Observer distributes game events. Command encapsulates a move. Merge keeps one accepted history entry with the snapshots used by Memento. A Decorator around the use case records operation, outcome and duration. The [class model](docs/diagrams/README.md) identifies the participants.

| Principle | Design example | Acceptance check |
| --- | --- | --- |
| SRP | HexGeometry owns traversal; LinesComboScoring owns points | Scoring changes independently of traversal |
| OCP | GameModule supplies a variant's collaborators | Register a test module against the existing engine |
| LSP | All rules observe the same turn contract | An invalid move preserves the snapshot and score |
| ISP | IUndoable is a capability of the Merge engine | Lines and Sort run without undo |
| DIP | LoadLevelsUseCase takes ILevelSource | Run the use case with an in-memory source |

The [engine architecture test](packages/hexa_engine/test/architecture_test.dart) currently checks dependency boundaries. Each implementation PR should link its source and executable evidence here.

### Application logging (NFR-006)

Every application operation can implement [UseCase](packages/hexa_application/lib/src/use_cases/use_case.dart).
At the composition root, wrap that operation once, for example:

```dart
final tracedMove = LoggingUseCase('apply_move', applyMove, logger);
await tracedMove.execute(request);
```

The [decorator](packages/hexa_application/lib/src/aspects/logging_use_case.dart) records entry, outcome
and elapsed milliseconds through an injected [ILogger](packages/hexa_application/lib/src/ports/logger.dart)
port. It forwards the original result or exception. Request values, results and exception messages
stay out of the log. The first gameplay use case can reuse this wrapper when wired into the app.
[Application tests](packages/hexa_application/test/logging_use_case_test.dart) exercise the public package API.

## Running tests

From the workspace root:

```sh
dart format --output=none --set-exit-if-changed .
flutter analyze
cd packages/hexa_engine
dart test
cd ../hexa_application
dart test
cd ../../app
flutter test
```

[CI](.github/workflows/ci.yml) also discovers package test directories. The [release workflow](.github/workflows/release.yml) builds an APK for version tags.

## AI usage, contributing and license

Record significant assistance in [AI_USAGE.md](AI_USAGE.md). Follow [CONTRIBUTING.md](CONTRIBUTING.md) for English Conventional Commits, branches, CI and review. [MIT license](LICENSE).
