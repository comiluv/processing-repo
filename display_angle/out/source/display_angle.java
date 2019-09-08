import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class display_angle extends PApplet {

PVector mouseV;
PVector xLine;
PVector centerPoint;
float angle, angle2;
float angBtwn, angBtwn2;
public void setup()
{
	
	centerPoint = new PVector(width / 2, height / 2);
	background(0);
	stroke(255);
	fill(255);
	textSize(16);
}
public void draw()
{
	background(0);
	text("(0,0)", centerPoint.x - 14, centerPoint.y + 28);
	mouseV = new PVector(mouseX, mouseY);
	xLine = new PVector(width, height / 2);
	//calculate vectors starting from center dot towards x axis and mouse pos
	//and get angle between
	angBtwn = PVector.angleBetween(PVector.sub(xLine, centerPoint), PVector.sub(mouseV, centerPoint));
	angBtwn2 = PVector.angleBetween(mouseV, centerPoint);
	//mouse pos relative to center dot is mouseX - centerX, -mouseY + centerY
	//theta = atan2(y/x)
	angle = atan2(centerPoint.y - mouseY, mouseX - centerPoint.x);
	angle2 = atan2(mouseY - centerPoint.y, mouseX - centerPoint.x);
	text("(" + PApplet.parseInt(mouseX - centerPoint.x) + "," + PApplet.parseInt(centerPoint.y - mouseY) + ")", mouseX, mouseY);
	text("from center atan2             " + degrees(angle), 20, 20);
	text("from center angleBetween " + degrees(angBtwn), 20, 40);
	text("from 0,0  atan2             " + degrees(angle2), 20, 60);
	text("from 0,0  angleBetween " + degrees(angBtwn2), 20, 80);
	point(width / 2, height / 2);
	point(mouseX, mouseY);
	line(width / 2, height / 2, width, height / 2);
	line(centerPoint.x, centerPoint.y, mouseX, mouseY);
	noFill();
	arc(centerPoint.x, centerPoint.y, 28, 28, -angBtwn, angBtwn);
	fill(255);
}
  public void settings() { 	size(400, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "display_angle" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
