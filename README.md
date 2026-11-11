# HexaBlock Suite

![CI](https://github.com/nombre-real-de-tu-org/hexablock-app/actions/workflows/ci.yml/badge.svg)
![Tests](https://img.shields.io/badge/tests-unit%20%7C%20integration%20%7C%20widget-blue)
![License](https://img.shields.io/badge/license-MIT-green)

Four hexagonal puzzle games — Hexa Lines, Hexa Fit, Hexa Sort and Hexa Merge — built on **one generic engine**.
Flutter / Dart 3 client. Backend: [nombre-real-de-tu-org/hexablock-api](https://github.com/nombre-real-de-tu-org/hexablock-api).

## Demo
_GIFs of the four variants (week 4)._

## Architecture
Clean Architecture with each layer as a Dart package; the compiler enforces the dependency rule.
![Clean Architecture](docs/diagrams/clean-architecture.png)

| Package | Layer | Depends on |
| --- | --- | --- |
| `packages/hexa_engine` | Entities (engine + variants) | nothing |
| `packages/hexa_application` | Use cases, ports, aspects | `hexa_engine` |
| `packages/hexa_infrastructure` | Adapters (drift, dio, audio) | application |
| `app` | Presenters + Flutter UI + composition root | all |

## Generic Engine
`HexBoard<TCell>`, `IGameRules<TCell, TMove, TState>`, `GameEngine<TCell, TMove, TState>`, `IPieceSource<TPiece>`,
`IScoringPolicy<TState>`, `IProgressModel`. Bound justifications and the fifth-variant guide:
[docs/EXTENSIBILITY.md](docs/EXTENSIBILITY.md). Class diagram: [docs/diagrams](docs/diagrams).

## Design Patterns
_Table: pattern · category · class · file · why (week 4)._

## SOLID Principles
_One real example per principle (week 4)._

## AOP
Aspects are decorators of `UseCase<I, O>` composed in the composition root (no AOP library).

## Getting Started
```bash
# Flutter stable with Dart >= 3.6 (pub workspaces)
git clone https://github.com/nombre-real-de-tu-org/hexablock-app.git && cd hexablock-app
npm install              # commitlint + git hooks (dev tooling only)
dart pub get             # resolves the whole workspace
cd app && flutter run
```

## Running Tests
```bash
dart format --output=none --set-exit-if-changed .
    flutter analyze
    (cd packages/hexa_engine && dart test)
    (cd app && flutter test)
```

## AI Usage Documentation
See [AI_USAGE.md](AI_USAGE.md) and [harness/](harness/README.md).

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md).

## License
MIT — see [LICENSE](LICENSE).
