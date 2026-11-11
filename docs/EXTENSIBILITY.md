# Extensibility — adding a fifth variant

_To be completed with real class names as the engine is implemented. Skeleton:_

1. Create `packages/hexa_engine/lib/src/variants/<name>/` with the cell type, move type, state and rules
   (`extends AbstractGameRules<TCell, TMove, TState>`).
2. Create `<Name>Factory implements GameVariantFactory<...>`.
3. Create `<Name>Module implements GameModule` in `app/` and register it in the composition root.
4. Add its use case(s) in `docs/specs/use-cases/` and tests in the engine package.

**Files that must NOT change:** `core/`, `board/`, `geometry/`, generic use cases, shared screens.

## Generic bounds and why
| Bound | Reason |
| --- | --- |
| `TCell extends Object` | Empty cell = missing key; no null content |
| `TState extends GameState<TCell>` | Engine and renderer read the board of any state |
| `T extends Mergeable<T>` | Only same-type cells merge; `SlideMergeResolver` is reusable |
