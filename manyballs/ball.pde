class Ball
{
	PVector pos;
	float size;
	float mass;
	PVector vel;
	PVector acc;
	float hu;

	Ball(float x, float y, float s, PVector in_vel, float h)
	{
		pos = new PVector(x, y);
		size = s;
		mass = sq(size) / QUARTER_PI;
		hu = h;
		vel = in_vel;
		acc = new PVector(0, 0, 0);
	}

	void update()
	{
		vel.add(acc);
		hitWall();
		pos.add(vel);

		acc.mult(0);
	}

	void hitWall()
	{
		float r = size * 0.5;
		if (pos.x + r >= width && vel.x > 0 || pos.x - r <= 0 && vel.x < 0)
		{
			vel.x *= -1;
			//HACK
			// pos.x = pos.x + r >= width ? width - r : r;
		}
		if (pos.y + r >= height && vel.y > 0 || pos.y - r <= 0 && vel.y < 0)
		{
			vel.y *= -1;
			//HACK
			// pos.y = pos.y + r >= height ? height - r : r;
		}
	}

	void collide(Ball otherBall)
	{
		float d = PVector.dist(pos, otherBall.pos);
		//https://matthew-brett.github.io/teaching/rotation_2d.html#equation-x-1-y-1
		//https://codepen.io/Full_of_Symmetries/pen/qqazdW?editors=0010#0
		if (d <= (size + otherBall.size) * 0.5 && PVector.dot(PVector.sub(vel, otherBall.vel), PVector.sub(otherBall.pos, pos)) > 0)
		{
			float tempx, tempy;
			tempx = vel.x;
			tempy = vel.y;
			//println("collide!");
			hu = random(255);
			otherBall.hu = hu;
			float theta = -atan2(otherBall.pos.y - pos.y, otherBall.pos.x - pos.x);
			PVector u1, u2;
			PVector v1 = vel.copy();
			PVector v2 = otherBall.vel.copy();
			v1.rotate(theta);
			v2.rotate(theta);
			u1 = new PVector((v1.x * (mass - otherBall.mass) +
			                  (2 * otherBall.mass * v2.x))
			                 / (mass + otherBall.mass), v1.y);
			u2 = new PVector((v2.x * (otherBall.mass - mass) +
			                  (2 * mass * v1.x))
			                 / (mass + otherBall.mass), v2.y);
			u1.rotate(-theta);
			u2.rotate(-theta);
			vel.set(u1);
			otherBall.vel.set(u2);

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
			//float dVec = map(d, 0, (size+otherBall.size)/2, 1, 0);
			//float dVec = 1 - (d/((size+otherBall.size)/2));
			//pushBall.mult(dVec);
			// pushBall.mult((size + otherBall.size) / (2 * d));
			// otherBall.pos.add(pushBall);
		}
	}

	void applyForce(PVector force)
	{
		acc.add(force);
	}

	void show()
	{
		fill(hu, 255, 255);
		ellipse(pos.x, pos.y, size, size);
	}
}
