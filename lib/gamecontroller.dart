import 'package:flutter/foundation.dart';
import 'package:jmemory/globals.dart';

import 'main.dart';
import 'tile.dart';
import 'gameboard.dart';

class GameController {
  GameBoard gameBoard;
  MemHomePageState homePageState;

  GameController(this.gameBoard, this.homePageState);

  /// Notifies us from the Tile that is clicked.
  clicked(Tile widget) {
    gameBoard.move();
    int x = widget.x, y = widget.y;
    if (kDebugMode) {
      print("Click in Tile[${x},${y}]");
      print("Previous ${gameBoard.previous?.hashCode}; state ${gameBoard.previous?.tileState}");
    }
    if (gameBoard.previous != null) {
      int px = gameBoard.previous!.x,
          py = gameBoard.previous!.y;
      if (gameBoard.secretsGrid![x][y] == gameBoard.secretsGrid![px][py]) {
        if (kDebugMode) {
          print("MATCH at [$x,$y] and [$px,$py]");
        }
        widget.setCleared();
        gameBoard.previous!.setCleared();
        gameBoard.nMinus1?.tileState?.reHide();
        gameBoard.previous = gameBoard.nMinus1 = null;
        checkForTheWin();
        return;
      }
    }
    gameBoard.nMinus1?.tileState?.reHide();
    gameBoard.nMinus1 = gameBoard.previous;
    gameBoard.previous = widget;
  }

  checkForTheWin() {
    for (int i = 0; i < Globals.NR; i++) {
      for (int j = 0; j < Globals.NR; j++) {
        if (gameBoard.tilesGrid![i][j].tileState?.tileMode != TileMode.CLEARED) {
          return;
        }
      }
    }
    if (kDebugMode) {
      print("PLAYER HAS WON THIS ROUND!!");
    }
    homePageState.newGameDialog("You won in ${gameBoard.moves} moves! Play again?");
  }
}
