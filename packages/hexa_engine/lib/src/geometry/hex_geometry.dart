class HexCoord {
  final int q;
  final int r;

  const HexCoord(this.q, this.r);

  int get s => -q - r;

  HexCoord operator +(HexCoord other) => HexCoord(q + other.q, r + other.r);

  HexCoord operator -(HexCoord other) => HexCoord(q - other.q, r - other.r);

  HexCoord operator -() => HexCoord(-q, -r);

  HexCoord operator *(int factor) => HexCoord(q * factor, r * factor);

  HexCoord neighbor(HexDirection direction) => this + direction.delta;

  HexCoord rotate60(int steps) => HexGeometry.rotate(this, steps);

  int distanceTo(HexCoord other) => HexGeometry.distance(this, other);

  @override
  bool operator ==(Object other) =>
      other is HexCoord && q == other.q && r == other.r;

  @override
  int get hashCode => Object.hash(q, r);

  @override
  String toString() => 'HexCoord($q, $r)';
}

enum HexDirection {
  east(HexCoord(1, 0)),
  northEast(HexCoord(1, -1)),
  northWest(HexCoord(0, -1)),
  west(HexCoord(-1, 0)),
  southWest(HexCoord(-1, 1)),
  southEast(HexCoord(0, 1));

  const HexDirection(this.delta);

  final HexCoord delta;
}

enum HexAxis { q, r, s }

abstract interface class BoardShape {
  bool contains(HexCoord coord);

  Iterable<HexCoord> get cells;
}

class HexagonShape implements BoardShape {
  final int radius;

  HexagonShape(this.radius) {
    if (radius < 0) {
      throw ArgumentError.value(radius, 'radius', 'must not be negative');
    }
  }

  @override
  Iterable<HexCoord> get cells sync* {
    for (var i = 0; i <= radius; i++) {
      yield* HexGeometry.ring(const HexCoord(0, 0), i);
    }
  }

  @override
  bool contains(HexCoord coord) =>
      HexGeometry.distance(const HexCoord(0, 0), coord) <= radius;
}

class HexGeometry {
  HexGeometry._();

  static int distance(HexCoord a, HexCoord b) {
    final dq = a.q - b.q;
    final dr = a.r - b.r;
    final ds = a.s - b.s;
    return ((dq.abs() + dr.abs() + ds.abs()) ~/ 2);
  }

  static HexCoord rotate(HexCoord coord, int steps) {
    var result = coord;
    final normalized = steps % 6;
    final rotations = normalized < 0 ? normalized + 6 : normalized;
    for (var i = 0; i < rotations; i++) {
      result = HexCoord(-result.r, result.s);
    }
    return result;
  }

  static Iterable<HexCoord> line(
    BoardShape shape,
    HexAxis axis,
    int value,
  ) sync* {
    for (final coord in shape.cells) {
      final matches = switch (axis) {
        HexAxis.q => coord.q == value,
        HexAxis.r => coord.r == value,
        HexAxis.s => coord.s == value,
      };
      if (matches) {
        yield coord;
      }
    }
  }

  static Iterable<HexCoord> ring(HexCoord center, int radius) sync* {
    if (radius == 0) {
      yield center;
      return;
    }

    var coord = center + HexDirection.northWest.delta * radius;
    for (final direction in HexDirection.values) {
      for (var i = 0; i < radius; i++) {
        yield coord;
        coord = coord + direction.delta;
      }
    }
  }
}
