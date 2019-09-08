Circle target;
Circle player;
Circle projection;
PVector un, n, ut, v1, v2;
PVector newvecv1n, newvecv1t, newvecv2n, newvecv2t;
PVector newvecv1, newvecv2;
PVector newGreen;
float v1n, v1t, v2n, v2t;
float newv1n, newv1t, newv2n, newv2t;
float target_size = 70;
float player_size = 70;
float angle, def1, def2, mag1, mag2;
float vdef1, vdef2, vmag1, vmag2;
float distance;

void setup()
{
	size(1200, 900);
	target = new Circle(900, height / 2, target_size);
	player = new Circle(100, height / 2, player_size);
	projection = new Circle(player.pos.x, player.pos.y, player_size);
	background(255);
	textSize(16);
}
void draw()
{
	background(255);
	noFill();
	calcProjection();
	distance = projection.pos.x - player.pos.x;
	target.update();
	player.update();
	projection.update();
	target.show();
	player.show();
	projection.show();
	if (mouseX < width / 2)
	{
		player.pos.x = mouseX;
	}
	player.pos.y = mouseY;
	stroke(255, 0, 0);
	//draw arrow from player to projection
	line(player.pos.x, player.pos.y, projection.pos.x, projection.pos.y);
	line(projection.pos.x, projection.pos.y, projection.pos.x - 20, projection.pos.y - 20);
	line(projection.pos.x, projection.pos.y, projection.pos.x - 20, projection.pos.y + 20);

	//https://matthew-brett.github.io/teaching/rotation_2d.html
	//http://www.vobarian.com/collisions/2dcollisions2.pdf
	//calculate normal vector
	n = new PVector(target.pos.x - projection.pos.x, target.pos.y - projection.pos.y);
	//println("n " + n);
	//calculate unit normal vector
	un = n.copy().normalize();
	//println("un " + un);
	//calculate unit tangent vector
	ut = new PVector(-un.y, un.x);
	//println("ut " + ut);
	//create initial velocity vector
	v1 = new PVector(distance, 0);
	v2 = new PVector(0, 0);
	//project velocity vectors onto unit normal and unit tangent vectors
	//https://en.wikipedia.org/wiki/Dot_product
	v1n = PVector.dot(un, v1);
	v1t = PVector.dot(ut, v1);
	v2n = PVector.dot(un, v2);
	v2t = PVector.dot(ut, v2);
	//println("v1n " + v1n);
	//println("v1t " + v1t);
	//println("v2n " + v2n);
	//println("v2t " + v2t);
	//new tangent velocities remain the same so no calculation needed
	newv1t = v1t;
	newv2t = v2t;
	//println("newv1t " + newv1t);
	//println("newv2t " + newv2t);
	//calculate new normal velocities
	newv1n = (v1n * (projection.mass - target.mass) + 2 * (target.mass) *v2n)
	         / (projection.mass + target.mass);
	newv2n = (v2n * (target.mass - projection.mass) + 2 * (projection.mass) *v1n)
	         / (projection.mass + target.mass);
	//println("newv1n " + newv1n);
	//println("newv2n " + newv2n);
	//convert scalar normal and tangential velocities into vectors
	newvecv1n = un.copy().mult(newv1n);
	newvecv1t = ut.copy().mult(newv1t);
	newvecv2n = un.copy().mult(newv2n);
	newvecv2t = ut.copy().mult(newv2t);
	//println("newvecv1n " + newvecv1n);
	//println("newvecv1t " + newvecv1t);
	//println("newvecv2n " + newvecv2n);
	//println("newvecv2t " + newvecv2t);
	//calculate final velocity
	newvecv1 = PVector.add(newvecv1n, newvecv1t);
	newvecv2 = PVector.add(newvecv2n, newvecv2t);
	//println(newvecv1);

	angle = -atan2(-projection.pos.y + target.pos.y, -projection.pos.x + target.pos.x);
	////mag1 = distance * 1/2 * sqrt(2+2*cos(angle));
	////mag2 = distance * sin(abs(angle/2));
	//mag2 = distance * sqrt((1+1+2*cos(angle))/(1+1));
	//mag1 = distance * (2*1/(1+1)) * sin(angle/2);
	def1 = (target.mass * sin(angle)) / (player.mass + target.mass * cos(angle));
	def2 = (PI - angle) / 2;
	mag1 = distance * (sqrt(sq(player.mass) + sq(target.mass) + 2 * player.mass * target.mass * cos(angle))
	                   / (player.mass + target.mass));
	mag2 = distance * ((2 * player.mass) / (player.mass + target.mass)) * sin(angle * 0.5);
	vdef1 = -atan2(newvecv1.y, newvecv1.x);
	vdef2 = -atan2(newvecv2.y, newvecv2.x);
	text("angle " + degrees(angle), 30, 30);
	text("v1 " + degrees(def1), 30, 60);
	text("v2 " + degrees(def2), 30, 80);
	text("vv1 " + degrees(vdef1), 30, 100);
	text("vv2 " + degrees(vdef2), 30, 120);
	//text("init_vel " + distance, 30, 100);
	text("mag1 " + mag1, 30, 140);
	text("mag2 " + mag2, 30, 160);
	text("vmag1 " + newvecv1.mag(), 30, 180);
	text("vmag2 " + newvecv2.mag(), 30, 200);
	////draw arrow from projection to projection vector
	stroke(0, 0, 255);
	pushMatrix();
	translate(projection.pos.x, projection.pos.y);
	line(0, 0, newvecv1.x, newvecv1.y);
	popMatrix();

	//pushMatrix();
	//translate(projection.pos.x, projection.pos.y);
	//rotate(def1);
	//line(0, 0, mag1, 0);
	//translate(mag1, 0);
	//line(0, 0, -30, 30);
	//line(0, 0, -30, -30);
	//popMatrix();

	////draw arrow from target to target vector
	stroke(0, 255, 0);
	pushMatrix();
	translate(target.pos.x, target.pos.y);
	line(0, 0, newvecv2.x, newvecv2.y);
	popMatrix();


	//pushMatrix();
	//translate(target.pos.x, target.pos.y);
	//rotate(def2);
	//line(0, 0, mag2, 0);

	////line(target.pos.x, target.pos.y, target.pos.x + target.pos.x - projection.pos.x, target.pos.y + target.pos.y - projection.pos.y);
	//translate(mag2, 0);
	////translate(target.pos.x + target.pos.x - projection.pos.x, target.pos.y + target.pos.y - projection.pos.y);
	////rotate(-angle);
	//line(0, 0, -30, 30);
	//line(0, 0, -30, -30);
	//popMatrix();

	//transform arrows to upper side to show vector idea
	pushMatrix();
	if (mouseY > target.pos.y)
	{
		translate(width * 0.5 - distance * 0.5, 50);
	}
	else
	{
		translate(width * 0.5 - distance * 0.5, height - 50);
	}
	//redline
	stroke(255, 0, 0);
	line(0, 0, distance, 0);
	line(distance, 0, distance - 20, -20);
	line(distance, 0, distance - 20, 20);
	//blueline
	stroke(0, 0, 255);
	line(0, 0, newvecv1.x, newvecv1.y);
	//greenline
	translate(newvecv1.x, newvecv1.y);
	newGreen = newvecv2.copy();
	newGreen.mult(target.mass / player.mass);
	stroke(0, 255, 0);
	line(0, 0, newGreen.x, newGreen.y);
	popMatrix();


	//draw normal and tangent line to collision surface
	stroke(0);
	strokeWeight(2);
	//normal line
	line(projection.pos.x, projection.pos.y, target.pos.x, target.pos.y);
	pushMatrix();
	translate(projection.pos.x + projection.size * 0.5 * cos(angle), projection.pos.y - projection.size * 0.5 * sin(angle));
	rotate(-angle);
	line(0, 0, 0, target_size);
	line(0, 0, 0, -target_size);
	popMatrix();
	text("ball1", player.pos.x - 20, player.pos.y - 10);
	text("ball2", target.pos.x - 20, target.pos.y - 10 * (player.pos.y > target.pos.y ? -1 : 1));
}

void keyPressed()
{
	if (key == ' ')
	{
		println("key pressed");
		noLoop();
	}
}


void calcProjection()
{
	float y0 = player.pos.y;
	float x1 = target.pos.x;
	float y1 = target.pos.y;
	float ans1, ans2;
	float ac = (sq(player_size + target_size) - sq(y1 - y0) - sq(x1));
	float b = -2 * x1;
	//sq(y1 - y0) + sq(x1 - x0) = sq(2*init_size);
	//sq(x0) -2*x1*x0 = sq(2*init_size) - sq(y1 - y0) - sq(x1)
	ans1 = (-b + sqrt(sq(2 * x1) + 4 * ac)) * 0.5;
	ans2 = (-b - sqrt(sq(2 * x1) + 4 * ac)) * 0.5;
	//println(ans1);
	//println(ans2);
	projection.pos.x = ans1 < ans2 ? ans1 : ans2;
	projection.pos.y = player.pos.y;
}
