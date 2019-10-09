/**
   https://web.archive.org/web/20160418004149/http://freespace.virgin.net/hugo.elias/graphics/x_water.htm
 */
import processing.sound.*;
SoundFile rainsound;

int cols = 800;
int rows = 600;

float[][] current;
float[][] previous;

float dampening = 0.99;

float wOffset;
float hOffset;

void
setup() {
	size(800, 600);
	rainsound = new SoundFile(this, "Rain.wav");
	cols = 3 * width;
	rows = 3 * height;
	wOffset = width * 0.2;
	hOffset = height * 0.2;
	current = new float[cols][rows];
	previous = new float[cols][rows];
	rainsound.loop();
}

void
draw() {
	background(0);
	for (int i = 1; i < cols - 1; ++i) {
		for (int j = 1; j < rows - 1; ++j) {
			current[i][j] = (previous[i - 1][j]
			                 + previous[i + 1][j]
			                 + previous[i][j - 1]
			                 + previous[i][j + 1]) / 2
			                - current[i][j];
			current[i][j] *= dampening;
		}
	}
	loadPixels();
	for (int i = 0; i < width; ++i) {
		for (int j = 0; j < height; ++j) {
			int index = i  + j * width;
			pixels[index] = color(current[i + width][j + height]);
		}
	}
	updatePixels();
	for (int i = 0; i < width / 300; ++i) {
		dropPebble(random(width - wOffset, 2 * width + wOffset),
		           random(height - hOffset, 2 * height + hOffset));
	}

	float[][] temp = previous;
	previous = current;
	current = temp;
}

void
mouseDragged() {
	dropPebble(mouseX + width, mouseY + height);
}
void
mouseClicked() {
	dropPebble(mouseX + width, mouseY + height);
}

void
dropPebble(float x, float y) {
	if (x < 0 || x >= cols || y < 0 || y >= rows) {
		return;
	}
	previous[floor(x)][floor(y)] = 255;
}
