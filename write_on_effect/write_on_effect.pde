// port from Processing 2 to Processing 3
// removed deprecated getFont() method and used getNative() with type casting with (Font)
// also fixed static field should be accessed in a static way warning
// source: https://forum.processing.org/one/topic/write-on-effect.html

import java.awt.*;
import java.awt.font.*;
import java.awt.geom.*;
PFont font;
float lastx;
float lasty;
float[] coords = {0, 0, 0, 0, 0, 0};
PathIterator pi;
String test;
void setup()
{
	size(1000, 200);
	background(255);
	test = "Type Something: ";
	font = createFont("Arial", 40);
	GlyphVector v = ((Font)font.getNative()).createGlyphVector(new FontRenderContext(((Font)font.getNative()).getTransform(), true, false), test);
	Shape s = v.getGlyphOutline(0);
	pi = s.getPathIterator(((Font)font.getNative()).getTransform());
	pi.currentSegment(coords);
	lastx = coords[0];
	lasty = coords[1];
	pi.next();
	smooth();
}
int k;
void draw()
{
	translate(0, 100);
	if (!pi.isDone())
	{
		if (pi.currentSegment(coords) != PathIterator.SEG_MOVETO)
		{
			line(coords[0], coords[1], lastx, lasty);
		}
		lastx = coords[0];
		lasty = coords[1];
		pi.next();
	}
	else if ( k < test.length())
	{
		GlyphVector v = ((Font)font.getNative()).createGlyphVector(new FontRenderContext(((Font)font.getNative()).getTransform(), true, false), test);
		Shape s = v.getGlyphOutline(k++);
		pi = s.getPathIterator(((Font)font.getNative()).getTransform());
		pi.currentSegment(coords);
		lastx = coords[0];
		lasty = coords[1];
		pi.next();
	}
}
void keyTyped()
{
	test += key;
}
