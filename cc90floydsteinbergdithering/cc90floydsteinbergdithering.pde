/**
 * Dithering an image using Floyd-Stenberg Dithering
 * https://www.youtube.com/watch?v=0L2n8Tg2FwI&list=PLRqwX-V7Uu6ZiZxtDDRCi6uhfTH4FilpH&index=126
 * https://en.wikipedia.org/wiki/Floyd–Steinberg_dithering
 */

PImage kitten;

void
setup() {
	size(1024, 512);
	kitten = loadImage("kitten.jpg");
	// kitten.filter(GRAY);
	image(kitten, 0, 0);
}

int
pixIndex(int x, int y, int imageWidth) {
	return x + y * imageWidth;
}


void
draw() {
	kitten.loadPixels();
	for (int y = 0; y < kitten.height; ++y) {
		for (int x = 0; x < kitten.width; ++x) {
			color pix = kitten.pixels[pixIndex(x, y, kitten.width)];

			float oldR = red(pix);
			float oldG = green(pix);
			float oldB = blue(pix);

			// Get quantized pixel having factor + 1 number of possibilities
			int factor = 4;

			int newR = round(factor * oldR / 255) * (255 / factor);
			int newG = round(factor * oldG / 255) * (255 / factor);
			int newB = round(factor * oldB / 255) * (255 / factor);
			kitten.pixels[pixIndex(x, y, kitten.width)] = color(newR, newG, newB);

			// Calculate error
			int errR = (int)oldR - newR;
			int errG = (int)oldG - newG;
			int errB = (int)oldB - newB;

			// Do the rest
			updateDitherWithError(kitten, x + 1, y, color(errR, errG, errB), 7.0 / 16);
			updateDitherWithError(kitten, x - 1, y + 1, color(errR, errG, errB), 3.0 / 16);
			updateDitherWithError(kitten, x, y + 1, color(errR, errG, errB), 5.0 / 16);
			updateDitherWithError(kitten, x + 1, y + 1, color(errR, errG, errB), 1.0 / 16);
		}
	}
	kitten.updatePixels();
	image(kitten, 512, 0);
}

/**
 * Modify color of a given image at pixel location indeX and indexY
 * with given color and multiplier
 */
void
updateDitherWithError(PImage img, int indexX, int indexY, color error, float multipier) {
	if (indexX >= img.width || indexX < 0 || indexY >= img.height || indexY < 0) {
		return;
	}
	int index = pixIndex(indexX, indexY, img.width);
	color c = img.pixels[index];
	float r = red(c);
	float g = green(c);
	float b = blue(c);
	r = r + red(error) * multipier;
	g = g + green(error) * multipier;
	b = b + blue(error) * multipier;
	img.pixels[index] = color(r, g, b);
}
