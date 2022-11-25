import 'package:flutter/material.dart';

import 'Tile.dart';
import 'boardsetup.dart';
import 'globals.dart';

void main() {
  BoardSetup().newGame();
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
      home: const MyHomePage(title: 'JMemory Recall Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: Globals.num_columns,
          children: List.generate(Globals.num_columns * Globals.num_rows, (index) {
            int x = index~/Globals.NR, y = index%Globals.NR;
            int secret = BoardSetup.secretsGrid![x][y];
            var t = Tile(x, y,
                    Text('$secret'));
            BoardSetup.tilesGrid![x].add(t);
            return t;

          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleFab,
        tooltip: 'Doodad',
        child: const Icon(Icons.refresh_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _handleFab() {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // means the user must tap a button to exit the Alert Dialog
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("New game?"),
            content: const SingleChildScrollView(
              child: Text("Start a new game?"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  setState(() {
                    BoardSetup().newGame();
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
