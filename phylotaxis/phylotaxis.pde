int n = 0;
int c = 4;
float angle = 137.5;
float angle_in_rads = 1.6180339887;
float turns = 0.6180339887;
float size = 4;
float cx, cy;

void setup()
{
	size(400, 400);
	colorMode(HSB);
	background(0);
	noStroke();
	cx = width * 0.5;
	cy = height * 0.5;
	angle_in_rads = turns * TWO_PI;
	while (angle_in_rads > TWO_PI)
	{
		angle_in_rads -= TWO_PI;
	}
	angle = angle_in_rads * 180.0 / PI;
	while (angle > 360)
	{
		angle -= 360.0;
	}
	println("turns is : " + turns);
	println("angle_in_rads is : " + angle_in_rads);
	println("angle is : " + angle);
}

void draw()
{
	while (true)
	{
		float a = n * angle_in_rads;
		float r = c * sqrt(n);
		float x = r * cos(a) + cx;
		float y = r * sin(a) + cy;
		float d = dist(x, y, cx, cy);
		fill(a % 256, 255, 255);
		d = map(d, 0, dist(0, 0, cx, cy), 0, 255);
		ellipse(x, y, size, size);
		if (abs(x) > abs(width) && abs(y) > abs(height))
		{
			println("done");
			break;
		}
		n++;
	}
	noLoop();
}

