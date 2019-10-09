// import java.util.Arrays;
// https://www.openprocessing.org/sketch/112601
// https://lodev.org/cgtutor/fire.html

import java.awt.Color;
PGraphics buffer1;
PGraphics buffer2;
PImage cooling;
float yStart = 0.0;
boolean showCool = false;
int[] flamePalette;
int[] perlinLookupTable;
int[] tempLookupTable;
int[][] fire;
int pixelsSize;
int w;
int h;

class MousePath {
	int x, y, col;

	public MousePath(int x_, int y_, int col_) {
		x = x_;
		y = y_;
		col = col_;
	}

	void
	update() {
		col = floor(random(256));
	}
}

ArrayList <MousePath> mousepaths = new ArrayList <MousePath> ();

void
setup() {
	size(600, 400);
	fire = new int[width][height + 1];
	buffer1 = createGraphics(width, height + 1);
	buffer2 = createGraphics(width, height);
	flamePalette = new int[256];
	for (int i = 0; i < 256; ++i) {
		float lerped = map((float)i, 0f, 255f, 0f, 85f / 360f);
		color rgbColor = Color.HSBtoRGB(lerped, 1., min(1., 2 * i / 255.));
		flamePalette[i] = (rgbColor);
	}

}

void
fireSeed(int[][] f) {
	// for (int y = height - 1; y < height + 1; ++y) {
	for (int x = 0; x < width; ++x) {
		f[x][height - 1] = floor(random(256));
	}
	// }
	for (int i = 0; i < mousepaths.size(); ++i) {
		mousepaths.get(i).update();
		f[mousepaths.get(i).x][mousepaths.get(i).y] = mousepaths.get(i).col;
	}
}

void
draw() {
	fireSeed(fire);
	if (mousePressed) {
		mousepaths.add(new MousePath(mouseX, mouseY, floor(random(256))));
		fire[mouseX][mouseY] = floor(random(256));
	}

	loadPixels();
	for (int y = 0; y < height - 1; ++y) {
		for (int x = 0; x < width; ++x) {
			fire[x][y] = ((fire[(x - 1 + width) % width][(y + 1) % height] + fire[x % width][(y + 1) % height]
			               + fire[(x + 1) % width][(y + 1) % height] + fire[x % width][(y + 2) % height]) * 32) / 129;
			pixels[x + y * width] = flamePalette[fire[x][y]];
		}
	}
	updatePixels();

	if (frameCount % 10 == 0) {
		println(frameRate);
	}
}

void
keyPressed() {
	if (key == ' ') {
		showCool = !showCool;
	}
}
void
setup_example2() {
	size(600, 400, P2D);
	pixelsSize = width * height;
	buffer1 = createGraphics(width, height + 2, P2D);
	buffer2 = createGraphics(width, height, P2D);
	cooling = createImage(width, height, RGB);
	// generate flame color palette in RGB. need 256 bytes available memory
	flamePalette = new int[256];
	for (int i = 0; i < 64; i++) {
		flamePalette[i]  = color(i << 2, 0, 0, i << 3);// Black to red
		flamePalette[i + 64]  = color(255, i << 2, 0);// Red to yellow
		flamePalette[i + 128]  = color(255, 255, i << 2);// Yellow to white,
		flamePalette[i + 192]  = color(255, 255, 255);// White
	}
	// fire(150);
	perlinLookupTable = makeTile(width, 4096);

	// make temporary lookup table that gets reused
	tempLookupTable = new int[width * height + width + 1];
	noSmooth();
}

void
draw_example2() {
	arrayCopy(perlinLookupTable, (frameCount & 0xFFF) * width, tempLookupTable, width * height, width);
	// noStroke();
	// fill(2, 250);
	// rect(0, 0, width, height);

	if (mousePressed) {
		int x = mouseX;
		int y = mouseY;
		for (int i = x - 50; i < x + 50; ++i) {
			for (int j = y - 50; j < y + 50; ++j) {
				int dSq = (x - i) * (x - i) + (y - j) * (y - j);
				if (dSq < 50 * 50 && i >= 0 && j >= 0 && i < width && j < height) {
					tempLookupTable[i + j*width] = 255;
				}
			}
		}
	}

	buffer2.beginDraw();
	buffer2.loadPixels();
	buffer1.loadPixels();
	int currentColorIndex = 0;
	for (int x = 0; x < width; ++x) {
		for (int y = 0; y < height; ++y) {
			int indexCool = x + y * width;
			buffer2.pixels[indexCool] = color(0); // same as background(0)
			tempLookupTable[indexCool] =
				currentColorIndex =
					((tempLookupTable[indexCool] + tempLookupTable[indexCool + width - 1]
					  + tempLookupTable[indexCool + width] + tempLookupTable[indexCool + width + 1]) >> 2) - 1;

			if (currentColorIndex >= 0) {
				buffer2.pixels[indexCool] = flamePalette[currentColorIndex];
			}
		}
	}
	buffer2.updatePixels();
	buffer2.endDraw();

	if (!showCool) {
		image(buffer2, 0, 0, width, height);
	} else {
		image(buffer1, 0, 0, width, height);
	}
	println(frameRate);
}


int[]
makeTile (int w, int h) {
	// color[] tile = new color[w*h];
	int[] tile = new int[w * h];
	float ns = 0.015; // increase this to get higher density
	float tt = 0;

	for (int x = 0; x < w; x++) {
		for (int y = 0; y < h; y++) {
			// normalize width and height
			float u = (float) x / w;
			float v = (float) y / h;

			double noise00 = noise((x * ns), (y * ns), 0);
			double noise01 = noise(x * ns, (y + h) * ns, tt);
			double noise10 = noise((x + w) * ns, y * ns, tt);
			double noise11 = noise((x + w) * ns, (y + h) * ns, tt);

			double noisea = u * v * noise00 + u * (1 - v) * noise01 + (1 - u) * v * noise10 + (1 - u) * (1 - v) * noise11;

			int value = (int) (255 * noisea) & 0xFF;
			// value = ((int) (255* noise((float)(x*ns), (float)(counterr++*ns),0)));// (int)random(255);

			tile[x + y * w] = value;// color(r&0xFF,g&0xFF,b&0xFF);
		}
	}
	return tile;
}

// below funcs are not used in this sketch but left in place

float
smoothImage(PImage img, int x, int y) {
	float sumR = 0;
	float sumG = 0;
	float sumB = 0;
	float sumBright = 0;
	int count = 0;
	if (x > 0) {
		sumR += (img.pixels[x - 1 + y * width]) >> 16 & 0xFF;
		/* sumG += (img.pixels[x - 1 + y * width]) >> 8 & 0xFF;
		   sumB += (img.pixels[x - 1 + y * width]) & 0xFF;
		   sumBright += (img.pixels[x - 1 + y * width]) & 0xFF; */
		count++;
	}
	if (x < width - 1) {
		sumR += (img.pixels[x + 1 + y * width]) >> 16 & 0xFF;
		/* sumG += (img.pixels[x + 1 + y * width]) >> 8 & 0xFF;
		   sumB += (img.pixels[x + 1 + y * width]) & 0xFF;
		   sumBright += (img.pixels[x + 1 + y * width]) & 0xFF; */
		count++;
	}
	if (y > 0) {
		sumR += (img.pixels[x + (y - 1) * width]) >> 16 & 0xFF;
		/* sumG += (img.pixels[x + (y - 1) * width]) >> 8 & 0xFF;
		   sumB += (img.pixels[x + (y - 1) * width]) & 0xFF;
		   sumBright += (img.pixels[x + (y - 1) * width]) & 0xFF; */
		count++;
	}
	if (y < height - 1) {
		sumR += (img.pixels[x + (y + 1) * width]) >> 16 & 0xFF;
		/* sumG += (img.pixels[x + (y + 1) * width]) >> 8 & 0xFF;
		   sumB += (img.pixels[x + (y + 1) * width]) & 0xFF;
		   sumBright += (img.pixels[x + (y + 1) * width]) & 0xFF; */
		count++;
	}
	sumR /= count;
	/* sumG /= count;
	   sumB /= count;
	   color sum = color(sumR, sumG, sumB);
	   sumBright /= count; */
	return (sumR);
}

void
cool() {
	cooling.loadPixels();

	float increment = 0.01;
	float xoff = 0.0; // Start xoff at 0
	// float detail = map(mouseX, 0, width, 0.1, 0.6);
	// noiseDetail(8, detail);

	// For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
	for (int x = 0; x < width; x++) {
		xoff += increment; // Increment xoff
		float yoff = yStart; // For every xoff, start yoff at 0
		for (int y = 0; y < height; y++) {
			yoff += increment; // Increment yoff

			// Calculate noise and scale by 255
			float n = noise(xoff, yoff);
			float bright = pow(n, 3) * 255;

			// Try using this line instead
			// float bright = random(0, 255);

			// Set each pixel onscreen to a grayscale value
			// println(hex(color(bright)));
			cooling.pixels[x + y*width] = color(bright);
		}
	}

	cooling.updatePixels();
	yStart += increment;
}

void
fire(int rows) {
	buffer1.beginDraw();
	buffer1.loadPixels();
	for (int i = 1; i <= rows; ++i) {
		for (int x = 0; x < width; ++x) {
			int y = height - i;
			int index = x + (y) * width;
			buffer1.pixels[index] = color(255);
		}
	}
	buffer1.updatePixels();
	buffer1.endDraw();
}
