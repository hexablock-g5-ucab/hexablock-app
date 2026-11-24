# Class model v6.3

The model is frozen at v6.3. It is the implementation baseline for Lines, Sort and Merge and builds on the team's v5 views.
The Mermaid sources can be edited. The draw.io file in this directory is the historical v0.

- **Complete client model:** all layers in one picture. [Image](class-diagram-app.png) · [Zoomable SVG](class-diagram-app.svg) · [Editable source](class-diagram-app.mmd)
- **Overview:** [Image](00-overview.png) · [Editable source](00-overview.mmd)
- **Generic engine and geometry:** [Image](01-core.png) · [Editable source](01-core.mmd)
- **Hexa Lines:** [Image](02a-lines.png) · [Editable source](02a-lines.mmd)
- **Hexa Sort:** [Image](02b-sort.png) · [Editable source](02b-sort.mmd)
- **Hexa Merge:** [Image](02c-merge.png) · [Editable source](02c-merge.mmd)
- **Sessions, use cases and ports:** [Image](03-application.png) · [Editable source](03-application.mmd)
- **Adapters, modules and presentation:** [Image](04-adapters.png) · [Editable source](04-adapters.mmd)

The backend model lives in [hexablock-api](https://github.com/hexablock-g5-ucab/hexablock-api/blob/develop/docs/diagrams/README.md).

## Reading the model

**Notation and colours**
- Solid triangles mean inheritance. Dashed triangles mean an interface is implemented.
- Filled diamonds mean composition. Hollow diamonds mean aggregation.
- Colours mark the Clean Architecture layer:
  - red: Entities (dashed border = variants);
  - yellow: Use cases;
  - green: Interface adapters;
  - blue: Frameworks.
- An orange border marks an extension point.

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

## Regenerating

From this directory, for example:

```sh
mmdc -i 01-core.mmd -o 01-core.png -w 2400 -s 2 -b white
```

The complete model is larger than Mermaid's default text limit, so render it with the bundled config:

```sh
mmdc -i class-diagram-app.mmd -o class-diagram-app.svg -b white -c mmd-config.json
```
