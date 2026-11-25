abstract interface class IRandom {
  int get seed;
  int get cursor;

  int nextInt(int max);
  double nextDouble();
  IRandom copy();
}

class SeededRandom implements IRandom {
  @override
  final int seed;

  @override
  int cursor;
  int _state;

  SeededRandom(this.seed, {this.cursor = 0})
    : _state = seed == 0 ? 0x9e3779b9 : seed.toSigned(64) {
    if (cursor < 0) {
      throw ArgumentError.value(cursor, 'cursor', 'must not be negative');
    }
  }

  @override
  int nextInt(int max) {
    if (max <= 0) {
      throw ArgumentError.value(max, 'max', 'must be positive');
    }
    _state = (_state * 1103515245 + 12345) & 0x7fffffff;
    cursor++;
    return _state % max;
  }

  @override
  double nextDouble() => nextInt(1 << 20) / (1 << 20);

  @override
  IRandom copy() => SeededRandom(seed, cursor: cursor).._state = _state;
}
