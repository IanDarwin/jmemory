import java.util.random.RandomGenerator;

/**
 * The game board consists of a grid sprinkled with pairs of 2-digit numbers (01-99)
 */
public class BoardSetup {
	private final int NR = 6, UNUSED = -1;
	private int[][] grid = new int[NR][NR];
	private boolean[] used;
	RandomGenerator randi = RandomGenerator.getDefault();

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
		used = new boolean[100];

		for (int i = 0; i < NR; i++) for (int j = 0; j < NR; j++) grid[i][j] = UNUSED;

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
		System.out.println("Did not fit " + r);
		dumpGrid("FAIL");
		throw new IllegalStateException("Did not fit " + r);
	}

	/** Just for debug */
	void dumpGrid(String tag) {
		System.out.println(tag);
		for (int i=0; i < NR; i++) {
			for (int j = 0; j < NR; j++) {
				System.out.print(grid[i][j]);
				System.out.print(' ');
			}
			System.out.println();
		}
	}

	public static void main(String[] args) {
		var board = new BoardSetup();
		board.dumpGrid("Before");
		board.newGame();
		board.dumpGrid("After filling");
	}
}
