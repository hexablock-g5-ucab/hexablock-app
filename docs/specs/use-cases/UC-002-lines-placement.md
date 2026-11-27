# UC-002 — Place a piece in Hexa Lines

| Field | Value |
| --- | --- |
| Primary actor | Player |
| Goal | Use a tray piece to fill cells and clear complete lines in an endless game |
| Status | Draft for team review |
| Linked requirements | FR-004, FR-008, FR-009, NFR-007 |
| Entities | Piece, tray, hexagonal board, score, clearing streak |

## Preconditions

A Lines game is active on the radius-four board. At least one of the three tray slots still holds a piece.

## Main success scenario

1. The player selects an occupied tray slot, optionally rotates the piece in 60-degree steps and chooses an anchor.
2. The game places the piece if every covered cell is inside the board and free, then consumes that tray slot.
3. The game identifies all full lines across the three axes on the same post-placement board and clears their union.
4. The player sees the updated board, score and remaining tray. After the third slot is consumed the game offers three new pieces.
5. Play continues if any available piece fits at any anchor in any allowed orientation.

## Alternative flows

- **A1 (step 2):** An empty slot, an overlap or an off-board cell rejects the placement. Board, tray, score, streak and random sequence stay as they were.
- **A2 (step 3):** An accepted move clears no line. The placed cells remain, placement points apply and the clearing streak resets.
- **A3 (step 5):** After any refill, if no available piece fits in any orientation, the game shows defeat with the final score.

## Business rules and acceptance examples

- **BR-002-1 — Three axes.** For each of q, r and s, placing the last missing cell clears the line. A line still missing a cell remains on the board.
- **BR-002-2 — Intersections.** A placement that closes two intersecting lines earns a two-line clear; the shared cell is removed once.
- **BR-002-3 — Consecutive turns.** A turn clearing multiple lines advances the streak once. Consecutive clearing turns use the streak multiplier from turn four (×2), five (×4) and six onward (×5).
- **BR-002-4 — End of turn.** An empty slot alone never ends the game. Check legal placements against the remaining or replenished tray.

## Postconditions

An accepted turn produces one updated board, score and tray; a rejected turn leaves the player able to retry.

## Verification scope

Use a parameterized rule check for the three axes and one intersection regression. Exercise rejection, refill and defeat through the placement flow; verify the visible interaction when the screen is wired. The shared engine architecture and backend suites retain their own coverage.

## Open questions

None recorded. Team review is required before treating this draft as approved.
