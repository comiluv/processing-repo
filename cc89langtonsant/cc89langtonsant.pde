/**
 * Langton's Ant
 * https://www.youtube.com/watch?v=G1EgjgMo48U&list=PLRqwX-V7Uu6ZiZxtDDRCi6uhfTH4FilpH&index=125
 */

int[][] grid;
int x;
int y;

PImage ant;

static enum antDir {
	ANTUP,
	ANTRIGHT,
	ANTDOWN,
	ANTLEFT;

	private static antDir[] vals = values();
	public antDir
	turnRight() {
		return vals[(this.ordinal() + 1) % vals.length];
	}
	public antDir
	turnLeft() {
		return vals[(this.ordinal() + vals.length - 1) % vals.length];
	}
};

antDir dir;

void
setup() {
	size(400, 400);
	grid = new int[height][width];
	ant = createImage(width, height, RGB);
	ant.loadPixels();
	for (int i = 0; i < ant.pixels.length; ++i) {
		ant.pixels[i] = color(255);
	}
	ant.updatePixels();
	x = floor(width * .5);
	y = floor(height * .5);
	dir = antDir.ANTUP;
}

/* The qualified case label cc89langtonsant.antDir.ANTUP must be replaced with the unqualified enum constant ANTUP */
void
moveForward() {
	switch (dir) {
	case ANTUP:
		y--;
		break;
	case ANTRIGHT:
		x++;
		break;
	case ANTDOWN:
		y++;
		break;
	case ANTLEFT:
		x--;
		break;
	}
	x = (x + width) % width;
	y = (y + height) % height;
}

void
draw() {
	background(255);

	ant.loadPixels();
	for (int i = 0; i < 1000; ++i) {
		int state = grid[y][x];

		if (state == 0) {
			dir = dir.turnRight();
			grid[y][x] = 1 - grid[y][x];
		} else if (state == 1) {
			dir = dir.turnLeft();
			grid[y][x] = 1 - grid[y][x];
		}
		color col = color(grid[y][x] * 255);
		int pix = y * width + x;
		ant.pixels[pix] = col;
		moveForward();
	}
	ant.updatePixels();

	image(ant, 0, 0);
}
