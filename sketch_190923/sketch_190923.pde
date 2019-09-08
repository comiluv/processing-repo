// original : https://www.openprocessing.org/sketch/744387
// original author : takawo (https://www.openprocessing.org/user/6533)
// 
// geomerative : http://www.ricardmarxer.com/geomerative/
// https://forum.processing.org/two/discussion/comment/106735/#Comment_106735

import geomerative.*;
String fontPath = "c:\\windows\\fonts\\STENCIL.TTF";
RFont fnt;
RShape grp;
RPoint[] pnts;
ArrayList<Mover> movers;
String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
IntList pallete;
PGraphics graphics;

void preload() { // processing skips this
  //font = loadFont("AbrilFatface-Regular.ttf");
  //font = loadFont("AbrilFatface-Regular.ttf");
}

void setup() {
  size(800, 800);
  //font = createFont("c:\\windows\\fonts\\ALGER.TTF", 96);
  //font = createFont("C:\\Users\\choij\\AppData\\Local\\Microsoft\\Windows\\Fonts\\AbrilFatface-Regular.ttf", 96);
  //font = createFont(fontPath, int(width * 0.7));
  RG.init(this);

  colorMode(HSB, 360, 100, 100, 100);
  //angleMode(DEGREES);
  graphics = createGraphics(width, height);
  graphics.colorMode(HSB, 360, 100, 100, 100);
  drawNoiseBackground(100000, graphics);

  init();
}

void drawNoiseBackground(int _n, PGraphics _graphics) {
  _graphics.beginDraw();
  for (int i = 0; i < _n; i++) {
    float x = random(width);
    float y = random(height);
    float w = random(1, 2);
    float h = random(1, 2);
    _graphics.noStroke();
    _graphics.fill(0, 0, 100, 10);
    _graphics.ellipse(x, y, w, h);
  }
  _graphics.endDraw();
}

void init() {
  pallete = new IntList();
  pallete.append(#50514f);
  pallete.append(#f25f5c);
  pallete.append(#ffe066);
  pallete.append(#247ba0);
  pallete.append(#70c1b3);
  movers = new ArrayList<Mover>();
  //char txt = (alphabet.charAt(int(random(0, alphabet.length()))));
  String txt = Character.toString(alphabet.charAt(int(random(0, alphabet.length()))));
  println("showing " + txt);
  float fontsize = width * 0.7;
  float x = width / 2 - fontsize / 3;
  float y = height / 2 + fontsize / 3;
  //let options = {
  //  sampleFactor: .5,
  //  simplifyThreshold: 0
  //};

  int bgNum = int(random(pallete.size()));
  int bg = pallete.get(bgNum);
  pallete.remove(bgNum);
  int txtNum = int(random(pallete.size()));
  int tc = pallete.get(txtNum);
  pallete.remove(txtNum);
  background(bg);
  //textFont(font);
  textSize(fontsize);
  fill(tc);
  //text(txt, x, y);
  
  grp = RG.getText(txt, fontPath, int(fontsize), CENTER);
  pnts = grp.getPoints();
  for (RPoint p : pnts) {
    Mover m = new Mover(p.x, p.y, pallete.array());
    movers.add(m);
  }
  push();
  translate(width/2, y);
  grp.draw();
  pop();
  
  //ArrayList<PVector> points = new ArrayList<PVector>();
  //PShape shape = font.getShape(txt);
  //for (int i = 0; i < shape.getVertexCount(); i++)
  //{
  //  points.add(shape.getVertex(i));
  //}
    
  ////font.textToPoints(txt, x, y, fontsize, options);
  
  //for (PVector p : points) {
  //  Mover m = new Mover(p.x, p.y, pallete.array());
  //  movers.add(m);
  //}
  
  image(graphics, 0, 0);
}


void draw() {
  IntList removeArr = new IntList();
  for (int i = 0; i < movers.size(); i++) {
    Mover m = movers.get(i);
    m.update();
    m.display();
    if (m.isDead()) {
      removeArr.append(i);
    }
  }
  for (int j = removeArr.size()-1; j > 0; j--) {
    movers.remove(removeArr.get(j));
  }
  if (frameCount %150 == 0) {
    init();
  }
}
