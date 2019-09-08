Star[] stars;
int density = 5;
float speed;

void setup()
{
	size(800, 800);
	stars = new Star[int(width * height / 1000 * density)];
	for (int i = 0; i < stars.length; i++)
	{
		stars[i] = new Star();
	}
}

void draw()
{
	speed = map(mouseX, 0, width, 0, 20);
	background(0);
	translate(width * 0.5, height * 0.5);
	for (int i = 0; i < stars.length; i++)
	{
		stars[i].update();
		stars[i].show();
	}
}
