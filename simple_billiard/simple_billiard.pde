Ball target;
Ball player;
PVector mouseV;
PVector playerXline;
PVector opposite;
PVector jinhang;
float angle;

void setup()
{
	size(1000, 400);
	textSize(16);
	target = new Ball(width * 0.5, height * 0.5, 16);
	player = new Ball(50, height * 0.5, 16);
	noStroke();
}
void draw()
{
	background(0);
	stroke(255);
	fill(255);
	line(width * 0.5, height * 0.5, width, height * 0.5);
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

void getOpposite()
{
	opposite = PVector.sub(player.pos, mouseV);
	opposite.setMag(10000);
	opposite.add(player.pos);
}

void mouseClicked()
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
		target.pos.set(new PVector(width * 0.5, height * 0.5));
		player.pos.set(new PVector(50, height * 0.5));
		player.forceApplied = false;
	}
}
