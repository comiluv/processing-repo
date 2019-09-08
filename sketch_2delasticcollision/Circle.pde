class Circle {
  PVector pos;
  PVector vel;
  float size;
  float mass;
  
  Circle(float x, float y, float r)
  {
    pos = new PVector(x, y);
    vel = new PVector();
    size = r*2;
    mass = PI*sq(r);
  }

  void update()
  {
  }
  void show()
  {
    noFill();
    stroke(0);
    strokeWeight(4);
    ellipse(pos.x, pos.y, size, size);
    fill(0);
    ellipse(pos.x, pos.y, 1, 1);
    noFill();
  }
}
