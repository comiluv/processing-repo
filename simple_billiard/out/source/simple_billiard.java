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

public class simple_billiard extends PApplet {

Ball target;
Ball player;
PVector mouseV;
PVector playerXline;
PVector opposite;
PVector jinhang;
float angle;

public void setup()
{
	
	textSize(16);
	target = new Ball(width / 2, height / 2, 16);
	player = new Ball(50, height / 2, 16);
	noStroke();
}
public void draw()
{
	background(0);
	stroke(255);
	fill(255);
	line(width / 2, height / 2, width, height / 2);
	mouseV = new PVector(mouseX, mouseY);
	playerXline = new PVector(width, player.pos.y).sub(player.pos);
	getOpposite();
	//line(mouseX, mouseY, player.pos.x, player.pos.y);
	if (!player.forceApplied)
	{
		line(opposite.x, opposite.y,
		     player.pos.x, player.pos.y);
		angle = atan2(player.pos.y - opposite.y, opposite.x - player.pos.x);
	}
	else
	{
		if (player.vel.mag() > 0)
		{
			jinhang = player.vel.copy();
			jinhang.setMag(10000);
			jinhang.add(player.pos);
			stroke(255, 255, 0);
			//point(player.pos.x + jinhang.x, player.pos.y + jinhang.y);
			line(player.pos.x, player.pos.y, jinhang.x, jinhang.y);
			angle = -atan2(player.pos.y - target.pos.y, player.pos.x - target.pos.x);
		}
	}
	text(degrees(angle), 20, 20);
	if (player.vel.mag() > 0)
	{
		println("player vel " + player.vel);
	}
	//line(0, player.pos.y, width, player.pos.y);
	player.collide(target);
	//target.collide(player);
	target.update();
	player.update();
	target.show();
	player.show();
}

public void getOpposite()
{
	opposite = PVector.sub(player.pos, mouseV);
	opposite.setMag(10000);
	opposite.add(player.pos);
}

public void mouseClicked()
{
	if (mouseButton == LEFT)
	{
		PVector force = PVector.sub(player.pos, mouseV);
		//force.normalize();
		force.mult(300);
		println("click");
		println(force);
		player.applyForce(force);
	}
	if (mouseButton == RIGHT)
	{
    loop();
		target.vel.mult(0);
		player.vel.mult(0);
		target.pos.set(new PVector(width / 2, height / 2));
		player.pos.set(new PVector(50, height / 2));
		player.forceApplied = false;
	}
}
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

	public void update()
	{
		vel.add(acc);
		pos.add(vel);
		acc.mult(0);

		float r = size / 2;

		if (pos.x - r < 0 || pos.x + r > width)
		{
			vel.x *= -1;
		}
		if (pos.y - r < 0 || pos.y + r > height)
		{
			vel.y *= -1;
		}
	}

	public void applyForce(PVector force)
	{
		force.div(mass);
		acc.add(force);
		forceApplied = true;
	}
	public void collide(Ball otherBall)
	{
		float d = PVector.dist(pos, otherBall.pos);
		if (d <= (size + otherBall.size) / 2)
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
	public void show()
	{
		pushMatrix();
		translate(pos.x, pos.y);
		noStroke();
		fill(255);
		ellipse(0, 0, size, size);
		popMatrix();
	}
}
  public void settings() { 	size(1000, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "simple_billiard" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
