import 'dart:async';

import 'package:meta/meta.dart';

import '../board/game_state.dart';
import '../scoring/score.dart';
import 'game_rules.dart';

class GameEngine<TCell extends Object, TMove, TState extends GameState<TCell>> {
  final IGameRules<TCell, TMove, TState> rules;
  final IScoringPolicy<TState> scoring;

  TState _state;
  Score _score;
  int _turn = 0;
  final StreamController<GameEvent> _events =
      StreamController<GameEvent>.broadcast();

  GameEngine({
    required this.rules,
    required this.scoring,
    required TState initialState,
    Score initialScore = const Score(),
  }) : _state = initialState,
       _score = initialScore;

  TState get state => _state;
  Score get score => _score;
  GameOutcome get outcome => rules.evaluate(_state);
  Stream<GameEvent> get events => _events.stream;

  TurnResult<TState> play(TMove move) {
    _turn++;
    if (!rules.isValid(_state, move)) {
      final rejected = MoveRejected('The move is not valid', _turn);
      _events.add(rejected);
      return TurnResult<TState>(_state, <GameEvent>[rejected]);
    }

    final before = _state;
    final result = rules.playTurn(_state, move);
    for (final event in result.events) {
      event.turn = _turn;
      _events.add(event);
    }

    final points = scoring.pointsFor(before, result.state, result.events);
    if (points != 0) {
      _score = _score.add(points);
      final scoreChanged = ScoreChanged(_score, _turn);
      _events.add(scoreChanged);
    }

    _state = result.state;
    final outcome = rules.evaluate(_state);
    if (outcome != GameOutcome.ongoing) {
      _events.add(GameEnded(outcome, _turn));
    }
    return result;
  }

  @protected
  void restore(TState state, Score score) {
    _state = state;
    _score = score;
  }

  Future<void> close() => _events.close();
}

class MoveCommand<TMove, TState> {
  final TMove move;
  final TState before;
  final Score scoreBefore;

  const MoveCommand({
    required this.move,
    required this.before,
    required this.scoreBefore,
  });

  TurnResult<TState> execute(
    TurnResult<TState> Function(TMove move) applyTurn,
  ) => applyTurn(move);
}

class MoveHistory<TMove, TState> {
  final int capacity;
  final List<MoveCommand<TMove, TState>> done = <MoveCommand<TMove, TState>>[];
  final List<MoveCommand<TMove, TState>> undone =
      <MoveCommand<TMove, TState>>[];

  MoveHistory({this.capacity = 1}) {
    if (capacity < 0) {
      throw ArgumentError.value(capacity, 'capacity', 'must not be negative');
    }
  }

  bool get canUndo => done.isNotEmpty;
  bool get canRedo => undone.isNotEmpty;

  void push(MoveCommand<TMove, TState> command) {
    done.add(command);
    undone.clear();
    if (capacity > 0 && done.length > capacity) {
      done.removeAt(0);
    }
  }

  MoveCommand<TMove, TState>? popUndo() {
    if (done.isEmpty) return null;
    final command = done.removeLast();
    undone.add(command);
    return command;
  }

  MoveCommand<TMove, TState>? popRedo() {
    if (undone.isEmpty) return null;
    final command = undone.removeLast();
    done.add(command);
    return command;
  }
}

abstract interface class IUndoable {
  bool get canUndo;
  void undo();
}

abstract interface class IRedoable {
  bool get canRedo;
  void redo();
}

class UndoableGameEngine<
  TCell extends Object,
  TMove,
  TState extends GameState<TCell>
>
    extends GameEngine<TCell, TMove, TState>
    implements IUndoable, IRedoable {
  final MoveHistory<TMove, TState> history;

  UndoableGameEngine({
    required super.rules,
    required super.scoring,
    required super.initialState,
    super.initialScore,
    MoveHistory<TMove, TState>? history,
  }) : history = history ?? MoveHistory<TMove, TState>(capacity: 1);

  @override
  bool get canUndo => history.canUndo;

  @override
  bool get canRedo => history.canRedo;

  @override
  TurnResult<TState> play(TMove move) {
    if (!rules.isValid(state, move)) {
      return super.play(move);
    }
    final before = state;
    final scoreBefore = score;
    final result = super.play(move);
    history.push(
      MoveCommand<TMove, TState>(
        move: move,
        before: before,
        scoreBefore: scoreBefore,
      ),
    );
    return result;
  }

  @override
  void undo() {
    final command = history.popUndo();
    if (command != null) {
      restore(command.before, command.scoreBefore);
    }
  }

  @override
  void redo() {
    final command = history.popRedo();
    if (command != null) {
      super.play(command.move);
    }
  }
}
