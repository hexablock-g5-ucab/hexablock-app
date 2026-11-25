import '../geometry/hex_geometry.dart';

class HexBoard<TCell extends Object> {
  final BoardShape shape;
  final Map<HexCoord, TCell> _cells;

  HexBoard(this.shape, [Map<HexCoord, TCell>? cells])
    : _cells = Map<HexCoord, TCell>.unmodifiable(cells ?? {});

  TCell? operator [](HexCoord coord) => _cells[coord];

  bool isFree(HexCoord coord) =>
      shape.contains(coord) && !_cells.containsKey(coord);

  Iterable<HexCoord> get occupiedCoords => _cells.keys;

  Map<HexCoord, TCell> get cells => Map<HexCoord, TCell>.unmodifiable(_cells);

  HexBoard<TCell> put(HexCoord coord, TCell cell) {
    if (!shape.contains(coord)) {
      throw ArgumentError.value(coord, 'coord', 'is outside the board');
    }
    final copy = Map<HexCoord, TCell>.of(_cells);
    copy[coord] = cell;
    return HexBoard<TCell>(shape, copy);
  }

  HexBoard<TCell> remove(HexCoord coord) {
    if (!_cells.containsKey(coord)) {
      return HexBoard<TCell>(shape, _cells);
    }
    final copy = Map<HexCoord, TCell>.of(_cells);
    copy.remove(coord);
    return HexBoard<TCell>(shape, copy);
  }

  Iterable<HexCoord> line(HexAxis axis, int value) =>
      HexGeometry.line(shape, axis, value);

  Iterable<HexCoord> ring(HexCoord center, int radius) sync* {
    for (final coord in HexGeometry.ring(center, radius)) {
      if (shape.contains(coord)) {
        yield coord;
      }
    }
  }

  Iterable<HexCoord> neighborsOf(HexCoord coord) sync* {
    for (final direction in HexDirection.values) {
      final neighbor = coord.neighbor(direction);
      if (shape.contains(neighbor)) {
        yield neighbor;
      }
    }
  }

  @override
  bool operator ==(Object other) =>
      other is HexBoard<TCell> &&
      shape == other.shape &&
      _mapEquals(_cells, other._cells);

  @override
  int get hashCode => Object.hash(shape, _mapHash(_cells));
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key) || b[entry.key] != entry.value) return false;
  }
  return true;
}

int _mapHash<K, V>(Map<K, V> map) => Object.hashAllUnordered(
  map.entries.map((entry) => Object.hash(entry.key, entry.value)),
);
