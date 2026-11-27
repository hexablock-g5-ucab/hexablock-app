# Entity Model (glossary)

See the [complete class model](../diagrams/README.md) for types, members and relationships.

| Term | Meaning |
| --- | --- |
| Cell content (`TCell`) | What a cell holds: TileColor (Lines), ColorStack (Sort), MergeTile (Merge) |
| Move (`TMove`) | PlacePiece, PlaceStack, Slide |
| Tray | The pieces or stacks offered to the player |
| Line | All cells with the same q, r or s value (27 lines on a radius-4 board) |
| Top run | Consecutive chips of the same colour at the top of a stack |
