String pi;
int[] digits;
int index = 0;
float hw;

void
setup() {
	size(400, 400);
	hw = width * 0.5;
	pi = loadStrings("pi-1million.txt")[0];
	String[] sdigits = pi.split("");
	digits = int(sdigits);
	println(digits.length);
	background(0);
	noFill();
	translate(0.5 * width, 0.5 * height);
	ellipse(0, 0, hw, hw);
}

void
draw() {
	translate(0.5 * width, 0.5 * height);
	int digit = digits[index];
	int nextDigit = digits[index + 1];

	float a1 = map(digit, 0, 10, 0, TWO_PI);
	float a2 = map(nextDigit, 0, 10, 0, TWO_PI);

	float x1 = hw * cos(a1);
	float y1 = hw * sin(a1);
	float x2 = hw * cos(a2);
	float y2 = hw * sin(a2);

	stroke(255);
	line(x1, y1, x2, y2);

	index = index >= 1000000 ? 0 : index + 1;
}
