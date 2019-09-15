ArrayList <Circle> circles;
ArrayList <PVector> spots;
int attemptsMax = 1000;
int attempts = 0;
float mouseR = 50;
float mouseStrength = 5;
boolean doneGrowing = false;
PImage img;

void setup()
{
	size(900, 400);
	spots = new ArrayList <PVector> ();
	img = loadImage("2017.png");
	img.loadPixels();
	for (int x = 0; x < img.width; x++)
	{
		for (int y = 0; y < img.height; y++)
		{
			int index = x + y * img.width;
			color c = img.pixels[index];
			float b = brightness(c);
			if (b > 1)
			{
				spots.add(new PVector(x, y));
			}
		}
	}
	stroke(255);
	noFill();
	circles = new ArrayList <Circle> ();
	circles.add(new Circle(200, 200));
}
void draw()
{
	background(0);
	if (!doneGrowing)
	{
		for (int i = 0; i < 10; i++)
		{
			attempts++;
			Circle a = newCircle();
			if (a != null)
			{
				circles.add(a);
			}
		}
		if (attempts > attemptsMax)
		{
			println("DONE");
			doneGrowing = true;
		}
	}
	for (Circle c : circles)
	{
		if (!doneGrowing && c.growing)
		{
			if (c.edges())
				c.growing = false;
			else
			{
				boolean overlapping;
				for (Circle other : circles)
				{
					if (c != other)
					{
						float d = dist(c.origPos.x, c.origPos.y, other.origPos.x, other.origPos.y);
						if (d < c.r + other.r + 1)
						{
							c.growing = false;
							break;
						}
					}

				}
			}
			c.grow();
		}
        c.update();
		c.show();
	}
}

Circle newCircle()
{
	int r = int(random(0, spots.size()));
	PVector spot = spots.get(r);
	float x = spot.x;
	float y = spot.y;
	boolean valid = true;
	for (Circle c : circles)
	{
		float d = dist(x, y, c.origPos.x, c.origPos.y);
		if (d < c.r + 1)
		{
			valid = false;
			break;
		}
	}

	if (valid)
	{
		return(new Circle(x, y));
	}
	else
	{
		return null;
	}
}