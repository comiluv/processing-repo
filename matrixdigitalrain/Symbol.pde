class Symbol
{
	float x, y, speed, switchInterval, opacity;
	boolean first;
	String value;
	
	Symbol (float x_, float y_, float speed_, float opacity_, boolean first_)
	{
		x = x_;
		y = y_;
		value = "";
		speed = speed_;
		first = first_;
		switchInterval = round(random(2, 25));
		opacity = opacity_;
	}

	void setToRandomSymbol()
	{
		float charType = round(random(0, 5));
		if (frameCount % switchInterval == 0)
		{
			if (charType > 1)
			{
				char c = (char)(0x30A0 + round(random(0, 96)));
				value = Character.toString(c);
			}
			else
			{
				value = Integer.toString(floor(random(0, 10)));
			}
		}
	}

	void rain()
	{
		y = y >= height ? 0 : y + speed;
	}
}
