# UC-001 — Slide the Hexa Merge board

| Field | Value |
| --- | --- |
| Primary actor | Player |
| Goal | Tiles move to the chosen edge and equal tiles merge into one of double value |
| Status | Draft |
| Linked requirements | FR-005, FR-008, FR-011, NFR-008 |
| Entities | HexBoard, MergeTile, HexDirection |

## Preconditions
- A Hexa Merge game is in progress (outcome `ongoing`).

## Main success scenario
1. Player swipes in one of the six directions.
2. System moves every tile as far as possible towards that edge, line by line, starting from the edge.
3. System merges two equal adjacent tiles that collide into one tile of double value; each tile merges at most once per slide.
4. System adds the produced values to the score.
5. System places a new tile (2 or 4) on a random empty cell using the seeded generator.
6. System shows the updated board and score.

## Alternative flows
- **A1 (step 2):** no tile can move or merge → the slide is ignored, no tile is spawned, nothing changes.
- **A2 (step 6):** the target tile appears → outcome `victory`, victory screen.
- **A3 (step 6):** no direction can change the board → outcome `defeat`, defeat screen.

## Postconditions
- Success: board and score updated; exactly one new tile; previous state stored for one undo.
- Failure (A1): board, score and generator state unchanged.

## Business rules
- **BR-001-1:** a tile merges at most once per slide.
- **BR-001-2:** the generator state is part of the snapshot; undo then the same slide spawns the same tile.

## Open questions
- Probability of 2 vs 4? Continue after reaching the target?
