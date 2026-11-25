import '../core/random.dart';
import 'hex_board.dart';

abstract interface class GameState<TCell extends Object> {
  HexBoard<TCell> get board;
  IRandom get random;
}
