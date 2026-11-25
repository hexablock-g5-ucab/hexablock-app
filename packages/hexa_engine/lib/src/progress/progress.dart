import '../core/game_rules.dart';
import '../scoring/score.dart';

class GameResult {
  final String gameId;
  final Score score;
  final GameOutcome outcome;
  final String? levelId;
  final int moves;
  final Duration elapsed;

  const GameResult({
    required this.gameId,
    required this.score,
    required this.outcome,
    this.levelId,
    required this.moves,
    required this.elapsed,
  });
}

class ProgressDelta {
  final bool changed;
  final Map<String, Object> changes;

  const ProgressDelta(this.changed, [this.changes = const {}]);
}

abstract interface class IProgressModel {
  ProgressDelta record(GameResult result);
  bool isUnlocked(String levelId);
  Map<String, Object> toJson();
  void restore(Map<String, Object> data);
}

class HighScoreProgress implements IProgressModel {
  Score _best = const Score();

  Score get best => _best;

  @override
  ProgressDelta record(GameResult result) {
    if (result.score.compareTo(_best) <= 0) {
      return const ProgressDelta(false);
    }
    _best = result.score;
    return ProgressDelta(true, {'bestScore': _best.value});
  }

  @override
  bool isUnlocked(String levelId) => true;

  @override
  Map<String, Object> toJson() => <String, Object>{'bestScore': _best.value};

  @override
  void restore(Map<String, Object> data) {
    final value = data['bestScore'];
    _best = value is int ? Score(value) : const Score();
  }
}

class LevelProgress implements IProgressModel {
  final Set<String> completed;
  final String firstLevelId;

  LevelProgress({Set<String>? completed, this.firstLevelId = 'level-1'})
    : completed = Set<String>.of(completed ?? const <String>{});

  @override
  ProgressDelta record(GameResult result) {
    final levelId = result.levelId;
    if (levelId == null ||
        result.outcome != GameOutcome.victory ||
        completed.contains(levelId)) {
      return const ProgressDelta(false);
    }
    completed.add(levelId);
    return ProgressDelta(true, {'completed': toJson()['completed']!});
  }

  @override
  bool isUnlocked(String levelId) {
    if (levelId == firstLevelId) return true;
    final match = RegExp(r'(\d+)$').firstMatch(levelId);
    if (match == null) return completed.contains(levelId);
    final number = int.tryParse(match.group(1)!);
    if (number == null || number <= 1) return false;
    final previous = levelId.replaceRange(
      match.start,
      match.end,
      (number - 1).toString(),
    );
    return completed.contains(previous);
  }

  @override
  Map<String, Object> toJson() => <String, Object>{
    'completed': completed.toList(growable: false),
  };

  @override
  void restore(Map<String, Object> data) {
    completed.clear();
    final stored = data['completed'];
    if (stored is Iterable) {
      completed.addAll(stored.whereType<String>());
    }
  }
}
