class Stream
{
	float x, y;
	int totalSymbols;
	Symbol[] symbols;
	
	float speed;

	Stream(float x_, float y_)
	{
		x = x_;
		y = y_;
		totalSymbols = round(random(5, (height / symbolSize) * 0.5));
		symbols = new Symbol[totalSymbols];
		speed = round(random(5, 22));
	}

	void generateSymbols()
	{
		boolean first = random(1) < 0.25;

		float opac = 255;
		for (int i = 0; i < symbols.length; i++)
		{
			symbols[i] = new Symbol(x, y, speed, opac, first);
			symbols[i].setToRandomSymbol();
			y -= symbolSize;
			first = false;
			opac -= (255 / symbols.length) / fadeInterval;
		}

	}
	void render()
	{
		for (Symbol s : symbols)
		{
			noStroke();
			if (s.first)
			{
				fill(140, 255, 170, s.opacity);
			}
			else
			{
				fill(0, 255, 70, s.opacity);
			}
			text(s.value, s.x, s.y);
			s.rain();
			s.setToRandomSymbol();
		}
	}

}
