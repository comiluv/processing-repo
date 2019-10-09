String txt;
float txtY = 0;
float magicAngle;

void
setup() {
	// size(1200, 600, P3D);
	fullScreen(P3D);
	String[] lines = loadStrings("space.txt");
	txt = join(lines, "\n");
	txtY = height / 2;
	magicAngle = atan(sqrt(2.0));
}

void
draw() {
	background(0);
	translate(width / 2, height / 2);
	fill(238, 213, 75);
	noStroke();
	textSize(width * 0.04);
	textAlign(CENTER);
	rotateX(magicAngle);
	float w = -width * 0.6;
	text(txt, -w / 2, txtY, w, height * 10);
	txtY--;
}
