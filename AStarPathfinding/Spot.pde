class Spot
{
	int x, y;
	float f, g, h;
	ArrayList <Spot> neighbors = new ArrayList <Spot> ();
	ArrayList <Spot> neighborsWall = new ArrayList <Spot> ();
	Spot previous = null;
	boolean wall = false;

	public Spot (int x_, int y_)
	{
		x = x_;
		y = y_;
		if (random(1) < wallChance)
		{
			wall = true;
		}
	}
	void show()
	{
		if (wall)
		{
			fill(0);
			noStroke();
			ellipse((x + 0.5) * spotw, (y + 0.5) * spoth, spotw * 0.5, spoth * 0.5);
			// rect(x * spotw, y * spoth, spotw - 1, spoth - 1);
			for (Spot s : neighborsWall)
			{
				if (s.wall)
				{
					stroke(0);
					strokeWeight(spotw*0.5);
					line((x+0.5)*spotw,(y+0.5)*spoth,(s.x+0.5)*spotw,(s.y+0.5)*spoth);
					// rectMode(CORNERS);
					// if (x == s.x)
					// {
					// 	rect(x * spotw, y * spoth + 0.5 * spoth, s.x * spotw + s.x, s.y * spoth + 0.5 * spoth);
					// }
					// else
					// {
					// 	rect(x * spotw + 0.5 * spotw, y * spoth, s.x * spotw + 0.5 * spotw, s.y * spoth + s.y);
					// }
				}
			}
		}
	}
	void show(color c)
	{
		if (wall)
		{
			fill(0);
			noStroke();
			ellipse((x + 0.5) * spotw, (y + 0.5) * spoth, spotw * 0.5, spoth * 0.5);
		}
		else
		{
			fill(c);
			noStroke();
			rectMode(CORNER);
			rect(x * spotw, y * spoth, spotw - 1, spoth - 1);
		}
	}
	void addNeighborsWall()
	{
		if (x + 1 < cols)
		{
			neighborsWall.add(grid.get((x + 1) + y * cols));
		}
		if (x > 0)
		{
			neighborsWall.add(grid.get((x - 1) + y * cols));
		}
		if (y + 1 < rows)
		{
			neighborsWall.add(grid.get(x + (y + 1) * cols));
		}
		if (y > 0)
		{
			neighborsWall.add(grid.get(x + (y - 1) * cols));
		}
	}
	void addNeighbors()
	{
		if (x + 1 < cols)
		{
			neighbors.add(grid.get((x + 1) + y * cols));
		}
		if (x > 0)
		{
			neighbors.add(grid.get((x - 1) + y * cols));
		}
		if (y + 1 < rows)
		{
			neighbors.add(grid.get(x + (y + 1) * cols));
		}
		if (y > 0)
		{
			neighbors.add(grid.get(x + (y - 1) * cols));
		}
		if (x > 0 && y > 0)
		{
			neighbors.add(grid.get(x - 1 + (y - 1) * cols));
		}
		if (x + 1 < cols && y > 0)
		{
			neighbors.add(grid.get(x + 1 + (y - 1) * cols));
		}
		if (x > 0 && y + 1 < rows)
		{
			neighbors.add(grid.get(x - 1 + (y + 1) * cols));
		}
		if (x + 1 < cols && y + 1 < rows)
		{
			neighbors.add(grid.get(x + 1 + (y + 1) * cols));
		}
	}

}
