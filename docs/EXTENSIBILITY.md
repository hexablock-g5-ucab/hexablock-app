# Adding a variant to the shared engine

The [v5 source views](diagrams/README.md) define the target contracts. Use Hexa Fill, a cell-painting puzzle, to rehearse the extension exercise. This is a design walkthrough for an additional game.

1. Specify allowed paints, a rejected move, scoring, victory and how to persist progress. Make one small example board for each outcome.
2. In `packages/hexa_engine/lib/src/variants/fill/` introduce FillCell, PaintCell and FillState. FillState implements `GameState<FillCell>`. Implement `AbstractGameRules<FillCell, PaintCell, FillState>` and a scoring policy.
3. Bind the complete family in `GameVariantFactory<FillCell, PaintCell, FillState, PaintToken>`. Return `IPieceSource<PaintToken>` and pass that typed source to the rules. The other three games keep their own source types.
4. Add a FillModule, a state serializer and the variant's input/render mapping at the app edge. Register the module once in the composition root. The selector discovers it through GameCatalog.
5. Register a game ID in backend configuration if the variant syncs progress. For level-based play, add a spec validator, extend the level schema configuration in both repos and keep the same envelope and HTTP routes.
6. Exercise one accepted move, one rejected move and a deterministic replay. Run the existing engine tests with a fake cell and verify that the shared engine, board, geometry, use cases and shared screen files have no variant-specific edits.

| Bound | Reason |
| --- | --- |
| `TCell extends Object` | Absence in the board map means empty |
| `TState extends GameState<TCell>` | Every session reads a board of the correct cell type |
| `T extends Mergeable<T>` | Only the slide resolver requires same-type fusion |
| `TPiece` on the factory | The produced piece and the input source of its rules must agree |

A board-size change belongs in setup, a piece-shape change in the catalogue and a score change in the scoring policy. [Extension diagram](diagrams/extensibility.png)
