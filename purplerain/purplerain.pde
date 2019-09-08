Drop[] drops = new Drop[1000];

void setup()
{
  size(640, 360);
  for (int i = 0; i<drops.length; i++)
  {
    drops[i] = new Drop();
  }
}

void draw()
{
  background(230, 230, 250);
  for (Drop drop : drops)
  {
    drop.fall();
    drop.show();
  }
}
