/*
   You need about 4 gb of memory space set in Processing
   or it will cause memory error
 */


import processing.pdf.*;

String pi;
String fileName = "/data/bookofPi.pdf";

PGraphics canvas;

void
setup() {
	size(800, 800);
	canvas = createGraphics(8000, 8000);
	float cols = 1000;
	float rows = 1000;
	pi = loadStrings("pi-1million.txt")[0];

	float w = canvas.width / cols;
	float h = canvas.height / rows;
	textSize(w);
	textAlign(CENTER, CENTER);
	int index = 0;
	canvas.beginDraw();
	canvas.noStroke();
	canvas.colorMode(HSB, 1.0);
	// beginRecord(PDF, fileName);
	for (float y = 0; y < canvas.height; y += h) {
		for (float x = 0; x < canvas.width; x += w) {
			int digit = int("" + pi.charAt(index));
			float huue = digit / 10.0;
			canvas.fill(huue, 1, 1);
			canvas.rect(x, y, w, h);
			// canvas.fill(255 - huue);
			// text(digit, x + 0.5 * w, y + 0.5 * h);
			index++;
			if (index >= pi.length()) {
				index = pi.length() - 1;
			}
		}
	}
	canvas.endDraw();
	println("Done drawing to canvas " + index);
	canvas.save("/data/digits.png");
	image(canvas, 0, 0, width, height);
	// endRecord();
}

void
draw() {

}
