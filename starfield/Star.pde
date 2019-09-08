class Star
{
  float x, y, z;
  
  float pz;
  
  Star()
  {
    x = random(-width, width);
    y = random(-height, height);
    z = random(width);
    pz = z;
  }
  
  void update()
  {
    z = z - speed;
    if (z < 1)
    {
      z = width;
      x = random(-width, width);
      y = random(-height, height);
      pz = z;
    }
  }
  
  void show()
  {
    fill(255);
    noStroke();
    float sx, sy, size, px, py;
    sx = map(x/z, 0, 1, 0, width);
    sy = map(y/z, 0, 1, 0, height);
    size = map(z, 0, width, 8, 0);
    
    //ellipse(sx, sy, size, size);
    
    px = map(x/pz, 0, 1, 0, width);
    py = map(y/pz, 0, 1, 0, height);
    pz = z;
    stroke(255);
    line(px, py, sx, sy);
    
    px = sx;
    py = sy;
  }
}
