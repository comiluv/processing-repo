ArrayList <Ball> balls;
int num_balls;
float perc_balls = 20.0;
float max_balls;
float init_size = 16;
PVector init_vel;
QuadTree qtree;
int countPoint;

void
setup() {
	size(600, 600);
	Rectangle baseRect = new Rectangle(width * 0.5, height * 0.5, width, height);
	qtree = new QuadTree(baseRect, 2);
	max_balls = (width / (2 * init_size)) * (height / (2 * init_size));
	num_balls = floor(map(perc_balls, 0.0, 100.0, 0.0, max_balls));
	ellipseMode(CENTER);
	colorMode(HSB);
	background(0);
	noStroke();
	balls = new ArrayList <Ball> ();
	getFullBall();
}

void
getFullBall() {
	Ball candidate;
	boolean good_candidate;
	float ball_size;
	for (int i = 0; i < num_balls; i++) {
		good_candidate = true;
		init_vel = PVector.random2D().mult(random(2, 4));
		ball_size = random(init_size, init_size * 2);
		candidate = new Ball(random(ball_size, width - ball_size), random(ball_size, height - ball_size), ball_size, init_vel, 100);
		for (Ball currBall : balls) {
			if (currBall.pos.dist(candidate.pos) < (currBall.size + candidate.size) * 0.5) {
				good_candidate = false;
			}
		}
		if (!good_candidate) {
			i--;
			continue;
		}
		balls.add(candidate);
	}
}

void
draw() {
	background(0);
	for (Ball b : balls) {
		Point p = new Point(b.pos.x, b.pos.y, b);
		qtree.insert(p);
		b.update();
		b.show();
	}

	// Visualizing skeleton
	qtree.render();
	Circle demoCircle = new Circle(mouseX, mouseY, init_size * 8);
	ArrayList <Point> demoPoints = new ArrayList <Point> ();
	qtree.query(demoCircle, demoPoints);
	stroke(255);
	strokeWeight(1);
	demoCircle.render();
	strokeWeight(4);
	for (Point p : demoPoints) {
		point(p.x, p.y);
	}


	for (int i = 0; i < balls.size(); ++i) {
		Circle circle = new Circle(balls.get(i).pos.x, balls.get(i).pos.y, balls.get(i).size * 8);
		ArrayList <Point> points = new ArrayList <Point> ();
		qtree.query(circle, points);
		for (int j = 0; j < points.size(); ++j) {
			Ball other = points.get(j).userBall;
			if (balls.get(i) != other) {
				balls.get(i).collide(other);
			}
		}
	}
	qtree.clear();
	// for (int i = 0; i < balls.size(); i++) {
	// for (int j = i + 1; j < balls.size(); j++) {
	// balls.get(i).collide(balls.get(j));
	// }
	// }
	// println(balls.size());
}

void
mouseClicked() {
	if (mouseButton == LEFT) {
		addBall();
	}
	if (mouseButton == RIGHT && balls.size() > 0) {
		balls.remove(0);
	}
}

void
mouseWheel(MouseEvent event) {
	if (event.getCount() < 0) {
		addBall();
	}
	if (event.getCount() > 0 && balls.size() > 0) {
		balls.remove(0);
	}
}

void
addBall() {
	PVector init_vel = PVector.random2D().mult(random(1, 2));
	float ball_size = init_size; // random(init_size, init_size * 2);
	Ball newBall = new Ball(mouseX, mouseY, ball_size, init_vel, 100);
	balls.add(newBall);
}
