import 'package:flutter/foundation.dart';
import 'package:jmemory/globals.dart';

import 'Tile.dart';
import 'boardsetup.dart';

class GameController {
  static Tile? previous, nMinus1;
  static clicked(Tile widget) {
    int x = widget.x, y = widget.y;
    if (kDebugMode) {
      print("Click in Tile[${x},${y}]");
      print("Previous ${previous?.hashCode}");
      print("Previous state ${previous?.state}");
    }
    if (previous != null) {
      int px = previous!.x,
          py = previous!.y;
      if (BoardSetup.secretsGrid![x][y] == BoardSetup.secretsGrid![px][py]) {
        print("MATCH at [$x,$y] and [$px,$py]");
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

  static checkForTheWin() {
    for (int i = 0; i < Globals.NR; i++) {
      for (int j = 0; j < Globals.NR; j++) {
        if (BoardSetup.tilesGrid![i][j].state?.tileMode != TileMode.CLEARED) {
          return;
        }
      }
    }
    print("PLAYER HAS WON!!");
  }
}