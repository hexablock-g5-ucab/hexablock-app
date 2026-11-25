import 'package:meta/meta.dart';

import '../board/game_state.dart';
import '../scoring/score.dart';

enum GameOutcome { ongoing, victory, defeat }

abstract class GameEvent {
  int turn;
  GameEvent([this.turn = 0]);
}

class MoveRejected extends GameEvent {
  final String reason;
  MoveRejected(this.reason, [super.turn]);
}

class ScoreChanged extends GameEvent {
  final Score score;
  ScoreChanged(this.score, [super.turn]);
}

class GameEnded extends GameEvent {
  final GameOutcome outcome;
  GameEnded(this.outcome, [super.turn]);
}

class GoalReached extends GameEvent {
  GoalReached([super.turn]);
}

class TurnResult<TState> {
  final TState state;
  final List<GameEvent> events;

  const TurnResult(this.state, this.events);
}

abstract interface class IGameRules<
  TCell extends Object,
  TMove,
  TState extends GameState<TCell>
> {
  bool isValid(TState state, TMove move);
  TurnResult<TState> playTurn(TState state, TMove move);
  GameOutcome evaluate(TState state);
}

abstract class AbstractGameRules<
  TCell extends Object,
  TMove,
  TState extends GameState<TCell>
>
    implements IGameRules<TCell, TMove, TState> {
  @override
  @nonVirtual
  TurnResult<TState> playTurn(TState state, TMove move) {
    if (!isValid(state, move)) {
      return TurnResult<TState>(state, <GameEvent>[
        MoveRejected('The move is not valid'),
      ]);
    }

    final events = <GameEvent>[];
    var working = apply(state, move, events);
    working = resolve(working, events);
    working = afterResolve(working, events);
    return TurnResult<TState>(working, events);
  }

  @protected
  TState apply(TState state, TMove move, List<GameEvent> events);

  @protected
  TState resolve(TState state, List<GameEvent> events);

  @protected
  TState afterResolve(TState state, List<GameEvent> events) => state;
}
