# Class model v5

Implementation baseline for Lines, Sort and Merge. It builds on the team's v4 views and v0 geometry model. Mermaid sources are editable. The draw.io file in this directory is historical v0.

- **Overview** · [Image](00-overview.png) · [Editable source](00-overview.mmd)
- **Generic engine and geometry** · [Image](01-core.png) · [Editable source](01-core.mmd)
- **Hexa Lines** · [Image](02a-lines.png) · [Editable source](02a-lines.mmd)
- **Hexa Sort** · [Image](02b-sort.png) · [Editable source](02b-sort.mmd)
- **Hexa Merge** · [Image](02c-merge.png) · [Editable source](02c-merge.mmd)
- **Sessions, use cases and ports** · [Image](03-application.png) · [Editable source](03-application.mmd)
- **Adapters, modules and presentation** · [Image](04-adapters.png) · [Editable source](04-adapters.mmd)

## Reading the model

Solid triangles denote inheritance, dashed triangles implement interfaces, filled diamonds denote composition and hollow diamonds denote aggregation. The key in each class view identifies the Clean layer. Orange borders mark extension points. Each variant labels its concrete template binding.

- Factories preserve TPiece from source to rules. Axial coordinates use equal q and r values for both equality and hashing.
- Validate before consuming randomness or replacing undo history. A Merge snapshot includes the board, score and generator state. Replay after undo reproduces both the value and coordinate of the new tile. UndoMoveUseCase checks the session's engine for IUndoable and reconciles the session phase after restoring the snapshot.
- Lines clears the union of all completed lines. In Sort, transfer a matching top run toward the larger run. On a tie the existing stack transfers to the newly placed stack. For secondary ties away from the placed cell, v5 chooses stable axial order. A top run of at least ten removes the entire stack and advances the goal. Test a cascade that continues after a clear.
- LoadLevelsUseCase takes ILevelSource. Read the remote Sort catalogue when reachable and use bundled levels offline. Validate board and spec before constructing GameSetup. Surface malformed downloaded levels as format errors.
- Logging is the initial cross-cutting aspect. Record operation, outcome and duration. Inputs containing credentials or personal data stay out of logs.

## Companion diagrams

- **Clean Architecture** · [Image](clean-architecture.png) · [Editable source](clean-architecture.mmd)
- **Extension points** · [Image](extensibility.png) · [Editable source](extensibility.mmd)

Regenerate from this directory, for example:

```sh
mmdc -i 01-core.mmd -o 01-core.png -w 2400 -s 2 -b white
```
