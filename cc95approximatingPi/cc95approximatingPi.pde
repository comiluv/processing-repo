double r;

long total = 0;
long circle = 0;
double pie = 0;
double recordPI = 0;
double recordDiff = Double.POSITIVE_INFINITY;

void
setup() {
	size(800, 800);
	r = width * .5;
	background(0);
	stroke(255);
	strokeWeight(2);
	noFill();
	translate(width * .5, height * .5);

	ellipse(0, 0, (float)r * 2, (float)r * 2);
	rectMode(CENTER);
	rect(0, 0, (float)r * 2, (float)r * 2);

}

void
draw() {
	translate(width * .5, height * .5);

	for (int i = 0; i < 10000; ++i) {
		double x = Math.random() * 2 * r - r;
		double y = Math.random() * 2 * r - r;
		total++;

		double d = (x * x + y * y);
		if (d < r * r) {
			stroke(100, 255, 150);
			circle++;
		} else {
			stroke(150, 100, 255);
		}

		point((float)x, (float)y);

		double pie = (double)4 * ((double) circle / (double)total);
		double diff = Math.abs(pie - Math.PI);
		if (diff < recordDiff) {
			recordDiff = diff;
			recordPI = pie;
			println(millis() * 0.001 + " Java: 3.141592653589793    current: " + recordPI);
		}
	}
}
