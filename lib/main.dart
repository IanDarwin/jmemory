import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gamecontroller.dart';
import 'tile.dart';
import 'gameboard.dart';
import 'globals.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MemApp());
}

class MemApp extends StatelessWidget {
  const MemApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JMemory',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MemHomePage(key: UniqueKey(), title: 'JMemory Recall Game'),
    );
  }
}

class MemHomePage extends StatefulWidget {
  const MemHomePage({super.key, required this.title});

  final String title;

  @override
  State<MemHomePage> createState() => MemHomePageState();
}

class MemHomePageState extends State<MemHomePage> {

  GameBoard gameBoard = GameBoard();
  GameController? gameController;
  int gameCount = 0, winCount = 0;

  @override
  void initState() {
    super.initState();
    gameController = GameController(gameBoard, this);
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("MemHomepageState::build");
    }
    gameBoard.newGame(); // Resets secrets and grids
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: Globals.num_columns,
          children: List.generate(Globals.num_columns * Globals.num_rows, (index) {
            int x = index~/Globals.NR, y = index%Globals.NR;
            int secret = gameBoard.secretsGrid![x][y];
            var t = Tile(x, y, Text('$secret'), gameController!, key: UniqueKey());
            gameBoard.tilesGrid![x].add(t);
            if (kDebugMode) {
              print("Row $x is ${gameBoard.secretsGrid![x]} ${gameBoard.tilesGrid![x][y].secret}");
            }
            return t;
          }),
        ),
        // Text("You have played $gameCount games and won $winCount."),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newGameDialog("Start a new game?"),
        tooltip: 'New game?',
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }

  /** Called from the FAB and also from GameController "won" logic */
  void newGameDialog(String message) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // means the user must tap a button to exit the Alert Dialog
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("New game?"),
            content: Text(message),
            //),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  setState(() {
                    gameCount++;
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}
