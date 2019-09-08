import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class manyballs extends PApplet {

ArrayList <Ball> balls;
int num_balls;
float perc_balls = 20.0f;
float max_balls;
float init_size = 16;
PVector init_vel;

public void setup()
{
	
	max_balls = (width / (2 * init_size)) * (height / (2 * init_size));
	num_balls = floor(map(perc_balls, 0.0f, 100.0f, 0.0f, max_balls));
	ellipseMode(CENTER);
	colorMode(HSB);
	background(0);
	noStroke();
	balls = new ArrayList <Ball> ();
	getFullBall();
}

public void getFullBall()
{
	Ball candidate;
	boolean good_candidate;
	float ball_size;
	for (int i = 0; i < num_balls; i++)
	{
		good_candidate = true;
		init_vel = PVector.random2D().mult(random(4, 8));
		ball_size = random(init_size, init_size * 2);
		candidate = new Ball(random(ball_size, width - ball_size), random(ball_size, height - ball_size), ball_size, init_vel, 100);
		for (Ball currBall : balls)
		{
			if (currBall.pos.dist(candidate.pos) < (currBall.size + candidate.size) / 2)
			{
				good_candidate = false;
			}
		}
		if (!good_candidate)
		{
			i--;
			continue;
		}
		balls.add(candidate);
	}
}

public void draw()
{
	background(0);
	for (int i = 0; i < balls.size(); i++)
	{
		for (int j = i + 1; j < balls.size(); j++)
		{
			balls.get(i).collide(balls.get(j));
		}
		balls.get(i).update();
		balls.get(i).show();
	}
	// println(balls.size());
}

public void mouseClicked()
{
	if (mouseButton == LEFT)
	{
		addBall();
	}
	if (mouseButton == RIGHT && balls.size() > 0)
	{
		balls.remove(0);
	}
}

public void mouseWheel(MouseEvent event)
{
	if (event.getCount() < 0)
	{
		addBall();
	}
	if (event.getCount() > 0 && balls.size() > 0)
	{
		balls.remove(0);
	}
}


public void addBall()
{
	PVector init_vel = PVector.random2D().mult(random(1, 2));
	float ball_size = init_size; //random(init_size, init_size * 2);
	Ball newBall = new Ball(mouseX, mouseY, ball_size, init_vel, 100);
	balls.add(newBall);
}
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

	public void update()
	{
		vel.add(acc);
		hitWall();
		pos.add(vel);

		acc.mult(0);
	}

	public void hitWall()
	{
		float r = size / 2;
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

	public void collide(Ball otherBall)
	{
		float d = PVector.dist(pos, otherBall.pos);
		//https://matthew-brett.github.io/teaching/rotation_2d.html#equation-x-1-y-1
		//https://codepen.io/Full_of_Symmetries/pen/qqazdW?editors=0010#0
		if (d <= (size + otherBall.size) / 2 && PVector.dot(PVector.sub(vel, otherBall.vel), PVector.sub(otherBall.pos, pos)) > 0)
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

	public void applyForce(PVector force)
	{
		acc.add(force);
	}

	public void show()
	{
		fill(hu, 255, 255);
		ellipse(pos.x, pos.y, size, size);
	}
}
  public void settings() { 	size(600, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "manyballs" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
