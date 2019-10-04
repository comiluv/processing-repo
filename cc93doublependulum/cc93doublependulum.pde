float r1 = 200;
float r2 = 200;
float m1 = 40;
float m2 = 40;
float a1 = HALF_PI;
float a2 = HALF_PI;
float a1_v = 0;
float a2_v = 0;
float universal_gravity = 1;
float px = -1;
float py = -1;
float cx;
float cy;

PGraphics pg;

void
setup() {
	size(900, 600);
	cx = .5 * width;
	cy = 50;
	pg = createGraphics(width, height);
	pg.beginDraw();
	pg.background(255);
	pg.endDraw();
	stroke(0);
	strokeWeight(2);
}

void
draw() {
	// background(255);
	image(pg, 0, 0);
	stroke(0);

	translate(cx, cy);

	float x1 = r1 * sin(a1);
	float y1 = r1 * cos(a1);

	float x2 = x1 + r2 * sin(a2);
	float y2 = y1 + r2 * cos(a2);

	float num1 = -universal_gravity * (2f * m1 + m2) * sin(a1);
	float num2 = -m2*universal_gravity*sin(a1 - 2f*a2);
	float num3 = -2f * sin(a1 - a2) * m2 * (a2_v * a2_v * r2 + a1_v * a1_v * r1 * cos(a1 - a2));
	float den = r1 * (2f * m1 + m2 - m2 * cos(2f * a1 - 2f * a2));

	float a1_a = (num1 + num2 + num3) / den;

	num1 = 2f * (sin(a1 - a2));
	num2 = a1_v * a1_v * r1 * (m1 + m2);
	num3 = universal_gravity * (m1 + m2) * cos(a1);
	float num4 = a2_v * a2_v * r2 * m2 * cos(a1 - a2);
	den = r2 * (2f * m1 + m2 - m2 * cos(2f * a1 - 2f * a2));

	float a2_a = (num1 * (num2 + num3 + num4)) / den;

	a1_v += a1_a;
	a2_v += a2_a;
	a1 += a1_v;
	a2 += a2_v;

	line(0, 0, x1, y1);
	fill(0);
	ellipse(x1, y1, m1, m1);
	line(x1, y1, x2, y2);
	fill(0);
	ellipse(x2, y2, m2, m2);

	pg.beginDraw();
	pg.translate(cx, cy);
	pg.stroke(255, 155, 200);
	pg.strokeWeight(1);
	// pg.point(x2, y2);
	if (frameCount > 1) {
		pg.line(px, py, x2, y2);
	}
	pg.endDraw();

	px = x2;
	py = y2;
}
