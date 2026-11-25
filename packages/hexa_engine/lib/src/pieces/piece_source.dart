import '../core/random.dart';

abstract interface class IPieceSource<TPiece> {
  TPiece next(IRandom rng);
}

class SeededRandomPieceSource<TPiece> implements IPieceSource<TPiece> {
  final List<TPiece> catalog;
  final List<int> weights;

  SeededRandomPieceSource(List<TPiece> catalog, {List<int>? weights})
    : catalog = List<TPiece>.unmodifiable(catalog),
      weights = List<int>.unmodifiable(
        weights ?? List<int>.filled(catalog.isEmpty ? 0 : catalog.length, 1),
      ) {
    if (catalog.isEmpty) {
      throw ArgumentError.value(catalog, 'catalog', 'must not be empty');
    }
    if (this.weights.length != catalog.length ||
        this.weights.any((weight) => weight <= 0)) {
      throw ArgumentError(
        'weights must have one positive value per catalog item',
      );
    }
  }

  @override
  TPiece next(IRandom rng) {
    final total = weights.fold<int>(0, (sum, weight) => sum + weight);
    var choice = rng.nextInt(total);
    for (var i = 0; i < catalog.length; i++) {
      choice -= weights[i];
      if (choice < 0) {
        return catalog[i];
      }
    }
    return catalog.last;
  }
}
