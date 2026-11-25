import '../board/hex_board.dart';
import '../geometry/hex_geometry.dart';

abstract interface class Mergeable<T extends Mergeable<T>> {
  bool canMergeWith(T other);
  T mergeWith(T other);
}

class SlideResult<T extends Mergeable<T>> {
  final HexBoard<T> board;
  final int mergedValue;
  final int mergeCount;
  final bool changed;

  const SlideResult({
    required this.board,
    required this.mergedValue,
    required this.mergeCount,
    required this.changed,
  });
}

class SlideMergeResolver<T extends Mergeable<T>> {
  final int Function(T value)? valueOf;

  const SlideMergeResolver({this.valueOf});

  SlideResult<T> slide(HexBoard<T> board, HexDirection direction) {
    var result = board;
    var mergedValue = 0;
    var mergeCount = 0;
    final mergedAt = <HexCoord>{};

    final coords = board.shape.cells.toList()
      ..sort((a, b) {
        final aProjection = a.q * direction.delta.q + a.r * direction.delta.r;
        final bProjection = b.q * direction.delta.q + b.r * direction.delta.r;
        return bProjection.compareTo(aProjection);
      });

    for (final start in coords) {
      var current = start;
      while (result[current] != null) {
        final next = current.neighbor(direction);
        if (!board.shape.contains(next)) {
          break;
        }

        final moving = result[current];
        final occupying = result[next];
        if (occupying == null) {
          result = result.remove(current).put(next, moving!);
          current = next;
          continue;
        }

        if (!mergedAt.contains(next) && moving!.canMergeWith(occupying)) {
          final merged = moving.mergeWith(occupying);
          result = result.remove(current).remove(next).put(next, merged);
          mergedAt.add(next);
          mergeCount++;
          final produced = valueOf?.call(merged) ?? merged.hashCode;
          if (produced > mergedValue) {
            mergedValue = produced;
          }
          break;
        }
        break;
      }
    }

    final changed = !_boardEquals(board, result);
    return SlideResult<T>(
      board: result,
      mergedValue: changed ? mergedValue : 0,
      mergeCount: mergeCount,
      changed: changed,
    );
  }

  bool _boardEquals(HexBoard<T> a, HexBoard<T> b) =>
      a.cells.length == b.cells.length &&
      a.cells.entries.every((entry) => b[entry.key] == entry.value);
}
