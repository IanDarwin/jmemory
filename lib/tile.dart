import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'gamecontroller.dart';

enum TileMode {
  SHOWN,
  HIDDEN,
  CLEARED,
}

/// Represents one Tile in the game
class Tile extends StatefulWidget {
  final int x, y;
  final Widget secret;
  final GameController gameController;
  late TileState tileState;

  Tile(this.x, this.y, this.secret, this.gameController, {super.key});

  // Slightly unorthodox: save state in a field in the SFW.
  // (Overly?)complicated b/c we need access to the ordered grid of Widgets
  // in the GameController class and need to access their state from there.
  // Presumably there's a better way to organize this.
  @override
  State<Tile> createState() => tileState = TileState();

  setCleared() {
    tileState.setCleared();
  }
}

class TileState extends State<Tile> {
  TileMode tileMode = TileMode.HIDDEN;

  _unHide() {
    setState(() => tileMode = TileMode.SHOWN);
    widget.gameController.clicked(widget);
  }

  reHide() {
    if (kDebugMode) {
      print("rehiding");
    }
    setState(() => tileMode = TileMode.HIDDEN);
  }

  setCleared() {
    if (kDebugMode) {
      print("Clearing");
    }
    setState(() => tileMode = TileMode.CLEARED);
  }

  _doNothing() {
    //
  }

  @override
  Widget build(BuildContext context) {
    switch(tileMode) {
      case TileMode.HIDDEN:
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            onPressed: _unHide,
            child: Text(''));
      case TileMode.SHOWN:
        return ElevatedButton(
            onPressed: _doNothing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: widget.secret);
      case TileMode.CLEARED:
        return ElevatedButton(
            onPressed: _doNothing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black12,
            ),
            child: const Icon(Icons.check));
    }
  }
}
