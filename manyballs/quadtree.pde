class Point {
	float x;
	float y;
	Ball userBall;

	public Point(float x_, float y_, Ball ball_) {
		this.x = x_;
		this.y = y_;
		this.userBall = ball_;
	}
}

class Circle {
	float x;
	float y;
	float r;
	float rSquared;

	public Circle(float x_, float y_, float r_) {
		this.x = x_;
		this.y = y_;
		this.r = r_;
		this.rSquared = this.r * this.r;
	}

	public boolean
	contains(Point p) {
		float d = (p.x - this.x) * (p.x - this.x) + (p.y - this.y) * (p.y - this.y);
		return d <= this.rSquared;
	}

	public boolean
	intersects(Rectangle range) {
		float xDist = Math.abs(range.x - this.x);
		float yDist = Math.abs(range.y - this.y);

		// circle outside the rectangle by x and y axis
		if (xDist > this.r + range.halfW || yDist > this.r + range.halfH) {
			return false;
		}

		// circle center inside the rectangle
		if (xDist <= range.halfW || yDist <= range.halfH) {
			return true;
		}

		float edges = (xDist - range.halfW) * (xDist - range.halfW) + (yDist - range.halfH) * (yDist - range.halfH);
		return edges <= this.rSquared;
	}

	public void
	render() {
		noFill();
		stroke(255);
		strokeWeight(1);
		ellipse(this.x, this.y, this.r * 2, this.r * 2);
	}
}

class Rectangle {
	float x;
	float y;
	float w;
	float h;
	float halfW;
	float halfH;

	public Rectangle(float x_, float y_, float w_, float h_) {
		x = x_;
		y = y_;
		w = w_;
		h = h_;
		halfW = w_ / 2;
		halfH = h_ / 2;
	}

	public boolean
	contains(Point p) {
		return (p.x >= this.x - this.halfW
		        && p.x <= this.x + this.halfW
		        && p.y >= this.y - this.halfH
		        && p.y <= this.y + this.halfH);
	}

	public boolean
	intersects(Rectangle range) {
		return !(range.x + range.halfW < this.x - this.halfW
		         || range.x - range.halfW > this.x + this.halfW
		         || range.y + range.halfH < this.y - this.halfH
		         || range.y - range.halfH > this.y + this.halfH);
	}
}

class QuadTree {
	Rectangle boundary;
	QuadTree northwest = null;
	QuadTree northeast = null;
	QuadTree southwest = null;
	QuadTree southeast = null;
	int capacity;
	ArrayList <Point> points = new ArrayList <Point> ();
	boolean divided = false;

	public QuadTree(Rectangle aRectangle) {
		this.boundary = aRectangle;
		this.capacity = 4;
	}

	public QuadTree(Rectangle aRectangle, int capacity_) {
		this.boundary = aRectangle;
		this.capacity = capacity_;
	}

	private void
	subDivide() {
		Rectangle nw = new Rectangle(this.boundary.x - this.boundary.halfW / 2, this.boundary.y - this.boundary.halfH / 2,
		                             this.boundary.halfW, this.boundary.halfH);
		Rectangle ne = new Rectangle(this.boundary.x + this.boundary.halfW / 2, this.boundary.y - this.boundary.halfH / 2,
		                             this.boundary.halfW, this.boundary.halfH);
		Rectangle sw = new Rectangle(this.boundary.x - this.boundary.halfW / 2, this.boundary.y + this.boundary.halfH / 2,
		                             this.boundary.halfW, this.boundary.halfH);
		Rectangle se = new Rectangle(this.boundary.x + this.boundary.halfW / 2, this.boundary.y + this.boundary.halfH / 2,
		                             this.boundary.halfW, this.boundary.halfH);
		this.northwest = new QuadTree(nw, this.capacity);
		this.northeast = new QuadTree(ne, this.capacity);
		this.southwest = new QuadTree(sw, this.capacity);
		this.southeast = new QuadTree(se, this.capacity);
		this.divided = true;
	}

	public boolean
	insert(Point b) {
		if (!this.boundary.contains(b)) {
			return false;
		}
		if (this.points.size() < this.capacity) {
			this.points.add(b);
			return true;
		}
		if (!this.divided) {
			subDivide();
		}
		return (this.northwest.insert(b)
		        || this.northeast.insert(b)
		        || this.southwest.insert(b)
		        || this.southeast.insert(b));
	}

	public void
	query(Circle range, ArrayList <Point> found) {
		if (range.intersects(this.boundary)) {
			for (Point p : this.points) {
				if (range.contains(p)) {
					found.add(p);
				}
			}
			if (this.divided) {
				this.northwest.query(range, found);
				this.northeast.query(range, found);
				this.southwest.query(range, found);
				this.southeast.query(range, found);
			}
		}
	}

	public void
	clear() {
		this.points.clear();
		if (this.divided) {
			this.northwest.clear();
			this.northeast.clear();
			this.southwest.clear();
			this.southeast.clear();
			this.divided = false;
			this.northwest = null;
			this.northeast = null;
			this.southwest = null;
			this.southeast = null;
		}
	}

	public void
	render() {
		noFill();
		stroke(255);
		strokeWeight(1);
		rectMode(CENTER);
		rect(this.boundary.x, this.boundary.y, this.boundary.w, this.boundary.h);
		if (this.divided) {
			this.northwest.render();
			this.northeast.render();
			this.southwest.render();
			this.southeast.render();
		}
	}
}
