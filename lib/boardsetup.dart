import 'dart:core';
import 'dart:math';

import 'Tile.dart';

/// The game board consists of a grid sprinkled with pairs of 2-digit numbers (01-99)
class BoardSetup {
	static const int NR = 6, UNUSED = -1;
	static List<List<int>>? secretsGrid;
	static List<List<Tile>>? tilesGrid;
	List<List<Tile>>? tiles;

	var used = List<bool>.filled(100, false, growable: false);
	var randi = Random();

	int _randomRowCol() {
		return randi.nextInt(NR);
	}

	int _randomValue() {
		do {
			var n = randi.nextInt(100);
			if (!used[n]) {
				used[n] = true;
				return n;
			}
		} while (true);
	}

	void newGame() {
		used = List<bool>.filled(100, false, growable: false);
		secretsGrid = List<List<int>>.generate(NR, (i) => List.generate(NR, (i) => UNUSED));
		for (int i = 0; i < NR*NR/2; i++) {
			int r = _randomValue();
			_findSpotForFirst(r);
			_findSpotForSecond(r);
		}
		tilesGrid = [];
		for (int i = 0; i < NR; i++) {
			tilesGrid!.add([]);
		}
	}

	/** Find and populate the first available grid square */
	void _findSpotForFirst(int r) {
		for (int i = 0; i < NR; i++) {
			for (int j = 0; j < NR; j++) {
				if (secretsGrid![i][j] == UNUSED) {
					secretsGrid![i][j] = r;
					return;
				}
			}
		}
	}

	/** Find a random empty spot to place the 2nd item of a pair */
	void _findSpotForSecond(int r) {
		int startx = _randomRowCol(), starty = _randomRowCol();
		for (int i = startx; i < NR; i++) {
			for (int j = starty; j < NR; j++) {
				if (secretsGrid![i][j] == UNUSED) {
					secretsGrid![i][j] = r;
					return;
				}
			}
		}
		/* Still here? Didn't find a fit yet */
		for (int i = NR - 1; i >= 0; i--) {
			for (int j = NR - 1; j >= 0; j--) {
				if (secretsGrid![i][j] == UNUSED) {
					secretsGrid![i][j] = r;
					return;
				}
			}
		}
		print("Did not fit $r");
		dumpGrid("FAIL");
		throw Exception("Did not fit");
	}

	/** Just for debug */
	void dumpGrid(String tag) {
		print(tag);
		for (int i=0; i < NR; i++) {
				print(secretsGrid![i]);
			}
			print("");
	}
}

	void main() {
		var board = BoardSetup();
		board.dumpGrid("Before");
		board.newGame();
		board.dumpGrid("After filling");
	}
