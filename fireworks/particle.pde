class Particle
{
  PVector pos;
  PVector vel;
  PVector acc;
  boolean orig;
  int lifespan;
  float hu;
  
  Particle(float x, float y, boolean firework, float col)
  {
    orig = firework;
    lifespan = 255;
    pos = new PVector(x, y, 0);
    hu = col;
    if (firework)
    {
      vel = new PVector(0, random(-8, -4), 0);
    } else {
      vel = PVector.random2D();
      vel = vel.mult(random(5));
    }
    acc = new PVector(0, 0, 0);
  }
  
  boolean done()
  {
    return (lifespan <= 0);
  }
  
    void applyForce(PVector force)
    {
      acc.add(force);
    }
    
    void update()
    {
      if(!orig)
      {
        lifespan -= 4;
      }
      vel.add(acc);
      pos.add(vel);
      acc.mult(0);
    }
    
    void show()
    {
      colorMode(HSB);
      if(!orig)
      {
        strokeWeight(2);
        stroke(hu, 255, 255, lifespan);
      } else
      {
        strokeWeight(4);
        stroke(hu, 255, 255);
      }
      point(pos.x, pos.y);
    }
}
