ArrayList <Firework> fireworks;
PVector gravity;

void setup()
{
  size(800, 600);
  colorMode(HSB);
  gravity = new PVector(0, 0.1);
  fireworks = new ArrayList<Firework>();
  stroke(255);
  strokeWeight(4);
  background(0);
}

void draw()
{
  colorMode(RGB);
  background(0, 0, 0, 2);
  if (random(1) < 0.1)
  {
    fireworks.add(new Firework(random(width), height));
  }
  for(int i = fireworks.size() - 1; i >= 0; i--)
  {
    fireworks.get(i).update();
    fireworks.get(i).show();
    if (fireworks.get(i).done())
    {
      fireworks.remove(i);
    }
  }
}
