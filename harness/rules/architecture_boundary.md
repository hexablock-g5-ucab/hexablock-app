---
name: architecture_boundary
type: rules
---
# Architecture Boundaries

- **hexa_engine (Layer 1):** pure Dart. Geometry, `HexBoard<TCell>`, engine core, the four variants.
  May import only `dart:*` and `package:meta`.
- **hexa_application (Layer 2):** generic use cases, ports (`IProgressRepository`, `IApiGateway`,
  `IAudioPort`, `ILogger`), aspects as `UseCase<I, O>` decorators, session State pattern. Imports Layer 1 only.
- **hexa_infrastructure (Layers 3-4):** drift, dio, audio adapters implementing the ports; DTO mappers.
- **app (Layers 3-4):** view models, screens, `BoardPainter`, composition root. Screens never call
  drift/dio directly; they go through use cases or `GameServiceFacade`.

```
hexa_engine ← hexa_application ← hexa_infrastructure ← app
```
