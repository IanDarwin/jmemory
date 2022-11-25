import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:git/gamecontroller.dart';

enum TileMode {
  SHOWN,
  HIDDEN,
  CLEARED,
}

class Tile extends StatefulWidget {
  final int x, y;
  final Widget secret;
  TileState? state;
  Tile(this.x, this.y, this.secret, {super.key}) {
    state = TileState(x, y, secret);
  }
  // ignore: no_logic_in_create_state
  TileState createState() {
    return state!;
  }

  setCleared() {
    state!.setCleared();
  }
}

class TileState extends State<Tile> {
  final int x, y;
  final Widget secret;
  TileMode tileMode = TileMode.HIDDEN;

  TileState(this.x, this.y, this.secret);

  _unHide() {
    setState(() => tileMode = TileMode.SHOWN);
    GameController.clicked(widget);
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
            child: Text(''));
    }
  }
}