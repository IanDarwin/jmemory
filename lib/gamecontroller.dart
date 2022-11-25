import 'package:flutter/foundation.dart';

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
        return;
      }
    }
    nMinus1?.state?.reHide();
    nMinus1 = previous;
    previous = widget;
  }
}