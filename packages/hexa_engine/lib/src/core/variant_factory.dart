import '../board/game_state.dart';
import '../geometry/hex_geometry.dart';
import '../pieces/piece_source.dart';
import '../progress/progress.dart';
import '../scoring/score.dart';
import 'game_rules.dart';
import 'game_setup.dart';

abstract interface class GameVariantFactory<
  TCell extends Object,
  TMove,
  TState extends GameState<TCell>,
  TPiece
> {
  String get id;

  BoardShape createBoardShape(GameSetup setup);
  IPieceSource<TPiece> createPieceSource(GameSetup setup);
  IGameRules<TCell, TMove, TState> createRules(
    GameSetup setup,
    IPieceSource<TPiece> pieces,
  );
  IScoringPolicy<TState> createScoring(GameSetup setup);
  IProgressModel createProgressModel();
  TState createInitialState(GameSetup setup);
}
