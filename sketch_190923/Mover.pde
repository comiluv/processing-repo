class Mover {
  PVector pos;
  float nx, ny, nz;
  PVector noiseScale;
  float life, lifeRatio;
  int cc, tc;


  Mover(float _x, float _y, int[] _colors) {
    pos = new PVector(_x, _y);
    float nx = 1.0 / 50;
    float ny = 1.0 / 100;
    float nz = 1.0 / random(10, 50);
    
    noiseScale = new PVector(nx, ny, nz);
    life = 300;
    lifeRatio = life / 100;
    cc = _colors[int(map(noise(_x / noiseScale.x), 0, 1, 0, _colors.length))];
    tc = _colors[int(map(noise(_y / noiseScale.x), 0, 1, 0, _colors.length))] * 0x100;
  }

  void update() {
    float n = noise(pos.x * noiseScale.x, 
      pos.y * noiseScale.y);
    float angle = map(n, 0, 1, -180, 180);
    angle = radians((angle + frameCount / 10) % 360);
    PVector vel = new PVector(cos(angle), sin(angle));
    pos.add(vel);
    life -= lifeRatio;
  }

  boolean isDead() {
    return life < 0;
  }

  void display() {
    int c = lerpColor(color(cc), color(tc), 1 - life / 300);
    life = life < 0 ? 0 : life;
    //println(life);
    strokeWeight(map(life, 0, 300, 0, 3));
    stroke(c);

    push();
    translate(width / 2, height / 2 + width * 0.7 / 3);
    point(pos.x, pos.y);
    pop();
  }
}
