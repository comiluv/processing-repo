import g4p_controls.*;

float len;
float angle = PI / 3;

void setup()
{
	size(600, 600);
	//fullScreen(JAVA2D);
	frameRate(60);
	stroke(255);
	createGUI();
	len = height * 0.33;
}
void draw()
{
	background(51);
	translate(width * 0.5, height);
	branch(len);
}

void branch(float len)
{
	line(0, 0, 0, -len);
	translate(0, -len);
	if (len > 1)
	{
		pushMatrix();
		rotate(angle);
		branch(len * 0.67);
		popMatrix();
		pushMatrix();
		rotate(-angle);
		branch(len * 0.67);
		popMatrix();
	}
}

void setAngle(float r)
{
	angle = PI * r;
	float angle_degrees = angle / PI * 180;
	String textAngle = str(angle) +  "rads\n" + str(angle_degrees) +  "degrees";
	label2.setText(textAngle);
}
