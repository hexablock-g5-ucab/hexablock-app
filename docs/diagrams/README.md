# App class model

The four-layer design covers 178 classes and 384 relationships. Yellow identifies domain classes, purple application, green interfaces and blue infrastructure.

[Interactive HTML](class-diagram-app.html) · [Vector PDF](class-diagram-app.pdf)

Download the HTML from GitHub and open it locally to search classes, inspect members and follow relationships. The first PDF page contains the whole model; the following pages index relationships by source class.

[Companion api model](https://github.com/hexablock-g5-ucab/hexablock-api/blob/develop/docs/diagrams/README.md)

## Design contracts

**Engine**

- Factories preserve `TPiece` from the source to the rules.
- Axial coordinates use the same q and r values for equality and hashing.
- Moves are validated before consuming randomness or replacing the undo history.

**Lines**
- Clears the union of all completed lines.
- Pieces rotate, and defeat checks every rotation.
- Combo: ×1.5 for each extra line.
- Streak: `LinesStreakBonus`, a Decorator. It starts on the 4th consecutive clearing turn (×2, then ×4, then ×5).

**Sort**
- After a stack is placed, neighbours are checked clockwise, starting at the north-east.
- A matching top run transfers only the tiles the target needs to reach ten.
- On a tie, the existing stack transfers to the newly placed one. This is `ExistingToPlacedPolicy`, a team rule implemented as a Strategy.
- Ten tiles of one colour remove the whole stack and advance the level goal (`ILevelGoal`). Sort keeps no stars.

**Merge**
- Each tile merges at most once per move (2, 2, 4 → 4, 4).
- Reaching 2048 emits `TargetReached`, which extends the core event `GoalReached`. The session shows the victory and lets the player continue.
- Undo keeps one move. The snapshot holds the board, the score and the generator state, so replaying after undo yields the same new tile.

**Application**
- `UndoMoveUseCase` and `RedoMoveUseCase` check the session engine for `IUndoable` or `IRedoable`. After either one, `GameSession` calls `reconcileAfterHistoryChange()`.

**Modules and levels**
- `GameModule` (application layer) has no Flutter dependency.
- Each game also provides an `IGameUiModule` (adapter layer). It supplies `buildBoard` (a typed `HexBoardView<TCell>` with its `CellRenderer<TCell>`), its `IMoveInput`, its extra controls and its sounds.
- Levels are parsed by the `ILevelParser` of each game. `SortLevelParser` directs `SortLevelBuilder`.
- Remote levels are read when reachable, with bundled levels as the offline fallback.

**Persistence**
- Progress is stored as JSON per game (`IProgressModel.toJson`).
- Finished games queue their `ScoreEntry` (score, moves, elapsed time) in `IScoreQueue`, which is backed by `pending_scores`. Sync sends them and marks them as sent.
- Unfinished games are not saved (team decision, v6.3).

**Logging** is the cross-cutting aspect. It records operation, outcome and duration, and inputs with credentials or personal data stay out of the logs.

## Companion diagrams

- **Clean Architecture:** [Image](clean-architecture.png) · [Editable source](clean-architecture.mmd)
- **Extension points:** [Image](extensibility.png) · [Editable source](extensibility.mmd)
