import 'dart:core';
import 'dart:math';

/// The game board consists of a grid sprinkled with pairs of 2-digit numbers (01-99)
class BoardSetup {
	static const int NR = 6, UNUSED = -1;
	var grid = List.generate(NR, (i) => List.generate(NR, (i) => UNUSED));
	var used = List<bool>.filled(100, false, growable: false);
	var randi = Random();

	int randomRowCol() {
		return randi.nextInt(NR);
	}

	int randomValue() {
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
		for (int i = 0; i < NR*NR/2; i++) {
			int r = randomValue();
			findSpotForFirst(r);
			findSpotForSecond(r);
		}
	}

	/** Find and populate the first available grid square */
	void findSpotForFirst(int r) {
		for (int i = 0; i < NR; i++) {
			for (int j = 0; j < NR; j++) {
				if (grid[i][j] == UNUSED) {
					grid[i][j] = r;
					return;
				}
			}
		}
	}

	/** Find a random empty spot to place the 2nd item of a pair */
	void findSpotForSecond(int r) {
		int startx = randomRowCol(), starty = randomRowCol();
		for (int i = startx; i < NR; i++) {
			for (int j = starty; j < NR; j++) {
				if (grid[i][j] == UNUSED) {
					grid[i][j] = r;
					return;
				}
			}
		}
		/* Still here? Didn't find a fit yet */
		for (int i = NR - 1; i >= 0; i--) {
			for (int j = NR - 1; j >= 0; j--) {
				if (grid[i][j] == UNUSED) {
					grid[i][j] = r;
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
				print(grid[i]);
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
