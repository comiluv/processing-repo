ArrayList <Firework> fireworks;
PVector gravity;

void setup()
{
	size(800, 600);
	gravity = new PVector(0, 0.1);
	fireworks = new ArrayList <Firework> ();
	stroke(255);
	strokeWeight(4);
	background(0);
}

void draw()
{
	noStroke();
	fill(0, 50);
	rect(0, 0, width, height);
	if (random(1) < 0.1)
	{
		fireworks.add(new Firework(random(width), height));
	}
	for (int i = fireworks.size() - 1; i >= 0; i--)
	{
		fireworks.get(i).update();
		fireworks.get(i).show();
		if (fireworks.get(i).done())
		{
			fireworks.remove(i);
		}
	}
}
