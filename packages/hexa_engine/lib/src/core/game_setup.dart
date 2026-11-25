class GameSetup {
  final int seed;
  final int boardRadius;
  final String? levelId;
  final Map<String, Object> spec;

  GameSetup({
    required this.seed,
    required this.boardRadius,
    this.levelId,
    Map<String, Object> spec = const <String, Object>{},
  }) : spec = Map<String, Object>.unmodifiable(spec);
}

abstract interface class ILevelBuilder<TSetup> {
  TSetup build();
}
