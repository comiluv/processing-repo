float angle = 0;
float beta = 0;
ArrayList <PVector> vectors = new ArrayList <PVector> ();

void
setup() {
	size(600, 400, P3D);
	noFill();
	stroke(255);
	strokeWeight(8);
}

void
draw() {
	background(0);
	translate(width * .5, height * .5);
	rotateY(angle);
	float r = 100 * (0.8 + 1.6 * sin(6 * beta));
	float theta = 2 * beta;
	float phi = 0.6 * PI * sin(12 * beta);
	float x = r * cos(phi) * cos(theta);
	float y = r * cos(phi) * sin(theta);
	float z = r * sin(phi);

	stroke(255, 0, 0);
	vectors.add(new PVector(x, y, z));
	pushMatrix();
	translate(x, y, z);
	sphere(4);
	popMatrix();

	stroke(255, 255, 255, 100);
	beginShape();
	for (PVector v : vectors) {
		vertex(v.x, v.y, v.z);
	}
	endShape();
	beta += .01;
	angle += .01;
}
