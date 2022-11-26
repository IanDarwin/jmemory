import 'package:flutter/foundation.dart';
import 'package:jmemory/globals.dart';

import 'tile.dart';
import 'gameboard.dart';

class GameController {
  GameBoard gameBoard;
  GameController(this.gameBoard);
  Tile? previous, nMinus1;

  /// Notifies us from the Tile that is clicked.
  clicked(Tile widget) {
    int x = widget.x, y = widget.y;
    if (kDebugMode) {
      print("Click in Tile[${x},${y}]");
      print("Previous ${previous?.hashCode}; state ${previous?.state}");
    }
    if (previous != null) {
      int px = previous!.x,
          py = previous!.y;
      if (gameBoard.secretsGrid![x][y] == gameBoard.secretsGrid![px][py]) {
        if (kDebugMode) {
          print("MATCH at [$x,$y] and [$px,$py]");
        }
        widget.setCleared();
        previous!.setCleared();
        nMinus1?.state?.reHide();
        previous = nMinus1 = null;
        checkForTheWin();
        return;
      }
    }
    nMinus1?.state?.reHide();
    nMinus1 = previous;
    previous = widget;
  }

  checkForTheWin() {
    for (int i = 0; i < Globals.NR; i++) {
      for (int j = 0; j < Globals.NR; j++) {
        if (gameBoard.tilesGrid![i][j].state?.tileMode != TileMode.CLEARED) {
          return;
        }
      }
    }
    if (kDebugMode) {
      print("PLAYER HAS WON THIS ROUND!!");
    }
  }
}
