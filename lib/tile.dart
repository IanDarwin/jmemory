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
  TileState? tileState;

  Tile(this.x, this.y, this.secret, this.gameController, {super.key});

  @override
  State<Tile> createState() => TileState(x, y, secret);

  setCleared() {
    tileState!.setCleared();
  }
}

class TileState extends State<Tile> {
  final int x, y;
  final Widget secret;
  TileMode tileMode = TileMode.HIDDEN;

  TileState(this.x, this.y, this.secret);

  _unHide() {
    setState(() => tileMode = TileMode.SHOWN);
    widget.gameController.clicked(widget);
  }

  reHide() {
    print("rehiding");
    setState(() => tileMode = TileMode.HIDDEN);
  }

  setCleared() {
    print("Clearing");
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
            child: secret);
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
