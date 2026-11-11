# Entity Model (glossary)

```mermaid
classDiagram
  class HexCoord { q:int; r:int }
  class HexBoard~TCell~ { shape; cells }
  class Piece~TCell~ { cells }
  class GameState~TCell~ { board }
  class Level { levelId; gameId; order; board; spec }
  class Progress { gameId; bestScore; stars }
  HexBoard --> HexCoord
  GameState --> HexBoard
  Level --> Piece
```

| Term | Meaning |
| --- | --- |
| Cell content (`TCell`) | What a cell holds: TileColor (Lines), PieceId (Fit), ColorStack (Sort), MergeTile (Merge) |
| Move (`TMove`) | PlacePiece, FitMove, PlaceStack, Slide |
| Tray | The pieces or stacks offered to the player |
| Line | All cells with the same q, r or s value (27 lines on a radius-4 board) |
| Top run | Consecutive chips of the same colour at the top of a stack |
