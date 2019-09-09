class Firework
{
	Particle firework;
	ArrayList <Particle> particles;
	boolean exploded;
	float hu;

	Firework(float in_x, float in_y)
	{
		hu = random(360);
		firework = new Particle(in_x, in_y, true, hu);
		particles = new ArrayList <Particle> ();
		exploded = false;
	}

	void update()
	{
		if (!exploded)
		{
			firework.applyForce(gravity);
			firework.update();
			if (firework.vel.y >= 0)
			{
				explode();
				exploded = true;
			}
		}
		for (int i = particles.size() - 1; i >= 0; i--)
		{
			particles.get(i).applyForce(gravity);
			particles.get(i).update();
			if (particles.get(i).done())
			{
				particles.remove(i);
			}
		}
	}

	boolean done()
	{
		return (exploded && particles.size() == 0);
	}

	void explode()
	{
		for (int i = 0; i < 100; i++)
		{
			particles.add(new Particle(firework.pos.x, firework.pos.y, false, hu));
		}
	}

	void show()
	{
		if (!exploded)
		{
			firework.show();
		}
		for (Particle p : particles)
		{
			p.show();
		}
	}
}
