import 'dart:core';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'globals.dart';
import 'tile.dart';

/// The game board consists of a NxN grid sprinkled with pairs of 2-digit numbers (00-99)
class GameBoard {
	List<List<int>>? secretsGrid;
	List<List<Tile>>? tilesGrid;
	Tile? previous, nMinus1;
	int? moves = 0;

	List<bool> _used = [];
	final _randi = Random();

	void newGame() {
		if (kDebugMode) {
		  print("GameBoard.newGame");
		}
		previous = nMinus1 = null;
		_used = List<bool>.filled(100, false, growable: false);
		secretsGrid = [];
		for (int i = 0; i < Globals.NR; i++) {
			secretsGrid!.add(List<int>.filled(Globals.NR, Globals.UNUSED));
		}
		tilesGrid = [];
		for (int i = 0; i < Globals.NR; i++) {
			tilesGrid!.add([]);
		}
		for (int i = 0; i < Globals.NR*Globals.NR/2; i++) {
			int r = _randomValue();
			_findSpotForFirst(r);
			_findSpotForSecond(r);
		}
	}

	void move() { moves = moves! + 1; }

	int _randomRowCol() {
		return _randi.nextInt(Globals.NR);
	}

	int _randomValue() {
		do {
			var n = _randi.nextInt(100);
			if (!_used[n]) {
				_used[n] = true;
				return n;
			}
		} while (true);
	}


	/** Find and populate the first available grid square */
	void _findSpotForFirst(int r) {
		for (int i = 0; i < Globals.NR; i++) {
			for (int j = 0; j < Globals.NR; j++) {
				if (secretsGrid![i][j] == Globals.UNUSED) {
					secretsGrid![i][j] = r;
					return;
				}
			}
		}
	}

	/** Find a random empty spot to place the 2nd item of a pair */
	void _findSpotForSecond(int r) {
		int startx = _randomRowCol(), starty = _randomRowCol();
		for (int i = startx; i < Globals.NR; i++) {
			for (int j = starty; j < Globals.NR; j++) {
				if (secretsGrid![i][j] == Globals.UNUSED) {
					secretsGrid![i][j] = r;
					return;
				}
			}
		}
		/* Still here? Didn't find a fit yet */
		for (int i = Globals.NR - 1; i >= 0; i--) {
			for (int j = Globals.NR - 1; j >= 0; j--) {
				if (secretsGrid![i][j] == Globals.UNUSED) {
					secretsGrid![i][j] = r;
					return;
				}
			}
		}
		dumpGrid("FAIL");
		throw Exception("Did not fit $r");
	}

	/** Dump Secrets Grid - just for debug */
	void dumpGrid(String tag) {
		print(tag);
		for (int i=0; i < Globals.NR; i++) {
			print(secretsGrid![i]);
		}
		print("");
	}
}

	void main() {
		var board = GameBoard();
		board.dumpGrid("Before");
		board.newGame();
		board.dumpGrid("After filling");
	}
