import '../geometry/hex_geometry.dart';

enum TileColor { red, blue, green, yellow, purple }

class Piece<TCell extends Object> {
  final Map<HexCoord, TCell> offsets;

  Piece(Map<HexCoord, TCell> offsets)
    : offsets = Map<HexCoord, TCell>.unmodifiable(offsets);

  Piece<TCell> rotated(int steps) {
    final copy = <HexCoord, TCell>{};
    for (final entry in offsets.entries) {
      copy[entry.key.rotate60(steps)] = entry.value;
    }
    return Piece<TCell>(Map<HexCoord, TCell>.unmodifiable(copy));
  }

  Map<HexCoord, TCell> placedAt(HexCoord anchor) {
    final result = <HexCoord, TCell>{};
    for (final entry in offsets.entries) {
      result[anchor + entry.key] = entry.value;
    }
    return Map<HexCoord, TCell>.unmodifiable(result);
  }

  int get size => offsets.length;
}
