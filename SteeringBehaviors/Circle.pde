class Circle
{
	float x, y, r;
	float maxspeed = 5;
	float maxforce = 0.3;
	PVector origPos;
	PVector vel;
	PVector acc;
	boolean growing = true;
	color c;


	public Circle (float x_, float y_)
	{
		x = random(width);
		y = random(height);
		origPos = new PVector(x_, y_);
		vel = PVector.random2D();
		acc = new PVector();
		r = 1;
		c = #000000 + floor(random(0x1000000));
	}
	void behaviors()
	{
		PVector arrive = arrive(origPos);
		PVector mouseV = new PVector(mouseX, mouseY);
		PVector flee = flee(mouseV);
		arrive.mult(1);
		flee.mult(mouseStrength);
		applyForce(arrive);
		applyForce(flee);
	}

	PVector arrive(PVector target)
	{
		PVector desired = PVector.sub(target, new PVector(x, y));
		float d = desired.mag();
		float speed = maxspeed;
		if (d < mouseR)
		{
			speed = map(d, 0, mouseR, 0, maxspeed);
		}
		desired.setMag(speed);
		PVector steer = PVector.sub(desired, vel);
		steer.limit(maxforce);
		return steer;
	}

	PVector flee(PVector target)
	{
		PVector desired = PVector.sub(target, new PVector(x, y));
		if (desired.mag() < mouseR)
		{
			desired.setMag(maxspeed);
			desired.mult(-1);
			PVector steer = PVector.sub(desired, vel);
			steer.limit(maxforce);
			return steer;
		}
		else
		{
			return new PVector();
		}
	}

	void applyForce(PVector force)
	{
		acc.add(force);
	}

	void update()
	{
		behaviors();
		vel.add(acc);
		acc.mult(0);
		x += vel.x;
		y += vel.y;
	}

	void show()
	{
		fill(c);
		noStroke();
		ellipse(x, y, r * 2, r * 2);
	}

	void grow()
	{
		if (growing)
		{
			r++;
		}
	}

	boolean edges()
	{
		return (origPos.x + r > width || origPos.x - r < 0 || origPos.y + r > height || origPos.y - r < 0);
	}

}
