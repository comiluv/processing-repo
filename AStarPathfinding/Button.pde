// highly movable buttons
// reference: https://processing.org/examples/handles.html

public class Button
{
	String name;
	float x, y, widthButton, heightButton;
	boolean locked = false;
	boolean pressed = false;

	public Button (String name_, float x_, float y_, float width_, float height_)
	{
		name = name_;
		x = x_;
		y = y_;
		widthButton = width_;
		heightButton = height_;
	}

	void show()
	{
		pressEvent();
		if (!bStart && dragged())
		{
			x = mouseX - widthButton * 0.5;
			y = mouseY - heightButton * 0.5;
		}
		rectMode(CORNER);
		stroke(0);
		strokeWeight(2);
		fill(51);
		rect(x, y, widthButton, heightButton, 10);
		textAlign(CENTER);
		fill(0);
		text(name, x + 0.5 * widthButton, y + 0.5 * heightButton);
	}

	boolean dragged()
	{
		return !(!pressed || pmouseX == mouseX && pmouseY == mouseY);
	}


	boolean mouseOver()
	{
		return (mouseX > x && mouseX < x + widthButton && mouseY > y && mouseY < y + heightButton);
	}

	void pressEvent()
	{
		if (mouseOver() && mousePressed || locked)
		{
			pressed = true;
			locked = true;
		}
		else
		{
			pressed = false;
		}
	}

	void releaseEvent()
	{
		locked = false;
	}
}
