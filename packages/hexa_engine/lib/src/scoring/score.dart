import '../core/game_rules.dart';

class Score implements Comparable<Score> {
  final int value;

  const Score([this.value = 0]);

  Score add(int points) => Score(value + points);

  @override
  int compareTo(Score other) => value.compareTo(other.value);

  @override
  bool operator ==(Object other) => other is Score && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Score($value)';
}

abstract interface class IScoringPolicy<TState> {
  int pointsFor(TState before, TState after, List<GameEvent> events);
}

class BonusMultiplierDecorator<TState> implements IScoringPolicy<TState> {
  final IScoringPolicy<TState> inner;
  final double factor;

  const BonusMultiplierDecorator({required this.inner, required this.factor});

  @override
  int pointsFor(TState before, TState after, List<GameEvent> events) =>
      (inner.pointsFor(before, after, events) * factor).round();
}
