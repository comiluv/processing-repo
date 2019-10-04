/*
   You need about 4 gb of memory space set in Processing
   or it will cause memory error
 */


import processing.pdf.*;

String pi;
String fileName = "/data/bookofPi.pdf";

void
setup() {
	size(1000, 1000, PDF, fileName);
	PGraphicsPDF pdf = (PGraphicsPDF) g;

	pi = loadStrings("pi-10million.txt")[0];
	float cols = 100;
	float rows = 100;

	float w = width / cols;
	float h = height / rows;
	textSize(w);
	textAlign(CENTER, CENTER);
	noStroke();
	colorMode(HSB, 1.0);
	int index = 0;

	float totalPages = pi.length() / (cols * rows);

	for (int i = 0; i < totalPages; ++i) {
		for (float y = 0; y < height; y += h) {
			for (float x = 0; x < width; x += w) {
				int digit = int("" + pi.charAt(index));
				float huue = digit / 10.0;
				fill(huue, 1, 1, 1);
				rect(x, y, w, h);
				// fill(255 - huue);
				// text(digit, x + 0.5 * w, y + 0.5 * h);
				index++;
				if (index >= pi.length()) {
					index = pi.length() - 1;
				}
			}
		}
		println("Page " + i + " complete");
		pdf.nextPage();
	}
	println("Done drawing to canvas " + index);
	exit();
	// endRecord();
}
