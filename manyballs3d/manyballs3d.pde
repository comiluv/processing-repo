import peasy.*;

ArrayList <Ball> balls;
int num_balls;
float perc_balls = 20.0;
float max_balls;
float init_size = 16;
PVector init_vel;
PeasyCam cam;

void setup()
{
	size(600, 600, P3D);
	cam = new PeasyCam(this, 600);
	max_balls = (width / (2 * init_size)) * (height / (2 * init_size));
	num_balls = floor(map(perc_balls, 0.0, 100.0, 0.0, max_balls));
	ellipseMode(CENTER);
	//colorMode(HSB);
	background(0);
	noStroke();
	balls = new ArrayList <Ball> ();
	getFullBall();
}

void getFullBall()
{
	Ball candidate;
	boolean good_candidate;
	float ball_size;
	for (int i = 0; i < num_balls; i++)
	{
		good_candidate = true;
		init_vel = PVector.random2D().mult(random(4, 8));
		ball_size = init_size; //random(init_size, init_size * 2);
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

void draw()
{
	background(0);
	lights();
	translate(-width / 2, -height / 2);
	drawBorder();
	for (int i = 0; i < balls.size(); i++)
	{
		for (int j = i + 1; j < balls.size(); j++)
		{
			balls.get(i).collide(balls.get(j));
		}
		balls.get(i).update();
		balls.get(i).show();
	}
	//println(balls.size());
}

void drawBorder()
{
	float w = width / 10;
	pushMatrix();
	//fill(0, 0, 0);

	stroke(255);
	translate(0, 0, -init_size);
	//rect(0, 0, width, height);
	for (int i = 0; i <= width / w; i++)
	{
		line(i * w, 0, i * w, height);
	}
	for (int j = 0; j <= height / w; j++)
	{
		line(0, j * w, width, j * w);
	}
	popMatrix();
}

void mouseClicked()
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

void mouseWheel(MouseEvent event)
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


void addBall()
{
	PVector init_vel = PVector.random2D().mult(random(1, 2));
	float ball_size = init_size; //random(init_size, init_size * 2);
	Ball newBall = new Ball(mouseX, mouseY, ball_size, init_vel, 100);
	balls.add(newBall);
}
