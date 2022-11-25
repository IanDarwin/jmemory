
import 'package:flutter/material.dart';
import 'package:git/Tile.dart';

/** Some globals */
class Globals {
  static const int NR = 6,
      UNUSED = -1;

  static int num_rows = NR,
      num_columns = NR;

  GlobalKey<TileState> _myKey = GlobalKey();
}