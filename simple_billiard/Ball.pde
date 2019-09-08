class Ball
{
	PVector pos;
	PVector vel;
	PVector acc;
	Boolean forceApplied, stopped;
	float size;
	float mass;

	Ball(float x, float y, float r)
	{
		pos = new PVector(x, y);
		vel = new PVector(0, 0);
		acc = new PVector();
		size = r * 2;
		mass = sq(size) / QUARTER_PI;
		forceApplied = false;
		stopped = false;
	}

	void update()
	{
		vel.add(acc);
		pos.add(vel);
		acc.mult(0);

		float r = size * 0.5;

		if (pos.x - r < 0 || pos.x + r > width)
		{
			vel.x *= -1;
		}
		if (pos.y - r < 0 || pos.y + r > height)
		{
			vel.y *= -1;
		}
	}

	void applyForce(PVector force)
	{
		force.div(mass);
		acc.add(force);
		forceApplied = true;
	}
	void collide(Ball otherBall)
	{
		float d = PVector.dist(pos, otherBall.pos);
		if (d <= (size + otherBall.size) * 0.5)
		{
			//println("collide!");
			float theta = -atan2(otherBall.pos.y - pos.y, otherBall.pos.x - pos.x);
			println(degrees(theta));
			PVector v1 = vel.copy();
			v1.rotate(theta);
			println("v1.x " + v1.x + " v1.y " + v1.y);
			PVector v2 = otherBall.vel.copy();
			println("v2.x " + v2.x + " v2.y " + v2.y);
			v2.rotate(theta);
			PVector u1, u2;
			u1 = new PVector((v1.x * (mass - otherBall.mass) + (2 * otherBall.mass * v2.x))
			                 / (mass + otherBall.mass), v1.y);
			u2 = new PVector((v2.x * (otherBall.mass - mass) + (2 * mass * v1.x))
			                 / (mass + otherBall.mass), v2.y);
			u1.rotate(-theta);
			u2.rotate(-theta);
			vel.set(u1);
			otherBall.vel.set(u2);
			println("player vel " + vel + " @ mag " + vel.mag());
			println("other vel " + otherBall.vel + " @ mag " + otherBall.vel.mag());
			noLoop();
			//vel.x = (vel.x * (mass - otherBall.mass) +
			//  (2 * otherBall.mass * otherBall.vel.x))
			//  / (mass + otherBall.mass);
			//vel.y = (vel.y * (mass - otherBall.mass) +
			//  (2 * otherBall.mass * otherBall.vel.y))
			//  / (mass + otherBall.mass);
			//otherBall.vel.x = (otherBall.vel.x * (otherBall.mass - mass) +
			//  (2 * mass * tempx))
			//  / (mass + otherBall.mass);
			//otherBall.vel.y = (otherBall.vel.y * (otherBall.mass - mass) +
			//  (2 * mass * tempy))
			//  / (mass + otherBall.mass);
			//vel.x = otherBall.vel.x;
			//vel.y = otherBall.vel.y;
			//otherBall.vel.x = tempx;
			//otherBall.vel.y = tempy;

			//pos.add(vel);
			//otherBall.pos.add(otherBall.vel);

			//HACK: seperate two balls by magic
			//int dirx, diry;
			//dirx = pos.x <= otherBall.pos.x ? 1 : -1;
			//diry = pos.y <= otherBall.pos.y ? 1 : -1;
			//otherBall.pos.x += sqrt(d) * dirx;
			//otherBall.pos.y += sqrt(d) * diry;
			//float dx = otherBall.pos.x - pos.x;
			//float dy = otherBall.pos.y - pos.y;
			//d = d > 0 ? d : 0.0000001;
			//float dsdd = (size + otherBall.size) / (2 * d);
			//otherBall.pos.x = pos.x + (dx * dsdd);
			//otherBall.pos.y = pos.y + (dy * dsdd);
			// PVector pushBall = PVector.sub(otherBall.pos, pos).normalize();
			// //float dVec = map(d, 0, (size+otherBall.size)/2, 1, 0);
			// //float dVec = 1 - (d/((size+otherBall.size)/2));
			// //pushBall.mult(dVec);
			// pushBall.mult((size+otherBall.size)/(2*d));
			// otherBall.pos.add(pushBall);
		}
	}
	void show()
	{
		pushMatrix();
		translate(pos.x, pos.y);
		noStroke();
		fill(255);
		ellipse(0, 0, size, size);
		popMatrix();
	}
}
