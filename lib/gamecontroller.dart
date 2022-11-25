import 'package:flutter/foundation.dart';

import 'Tile.dart';

class GameController {
  static Tile? previous;
  static clicked(Tile widget) {
    int x = widget.x, y = widget.y;
    if (kDebugMode) {
      print("Click in Tile[${x},${y}]");
      print("Previous ${previous?.hashCode}");
      print("Previous state ${previous?.state}");
    }
    previous?.state?.reHide();
    previous = widget;
  }
}