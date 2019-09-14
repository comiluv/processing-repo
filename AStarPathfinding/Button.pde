public class Button
{
	String name;
	float x, y, widthButton, heightButton;

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
		rectMode(CORNER);
		stroke(0);
		strokeWeight(2);
		fill(51);
		rect(x, y, widthButton, heightButton, 10);
		textAlign(CENTER);
		fill(0);
		text(name, x + 0.5 * widthButton, y + 0.5 * heightButton);
	}

	boolean mouseOver()
	{
		return (mouseX > x && mouseX < x + widthButton && mouseY > y && mouseY < y + heightButton);
	}

}
