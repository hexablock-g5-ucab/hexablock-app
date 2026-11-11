---
name: validation_protocol
type: rules
---
# Validation Protocol

A phase is done only when all of these pass:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
(cd packages/hexa_engine && dart test)
(cd app && flutter test)
```

- Every main flow, alternative flow and business rule of the linked UC has a test.
- Phases touching UI, audio or networking are also checked manually on a device or in Swagger
  (lesson from Group 8, phase 15: an architecture audit does not prove runtime behaviour).
