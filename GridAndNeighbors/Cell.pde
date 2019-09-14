class Cell
{
	int x, y;
	ArrayList <Cell> neighbors = new ArrayList <Cell> ();

	public Cell (int x_, int y_)
	{
		x = x_;
		y = y_;
	}

	void show(color c)
	{
		fill(c);
		noStroke();
		rect(x * cw, y * ch, cw - 1, ch - 1);
	}

	void addNeighbors()
	{
		if (x < cols - 1)
			neighbors.add(grid.get((x + 1) + y * cols));
		if (x > 0)
			neighbors.add(grid.get((x - 1) + y * cols));
		if (y < rows - 1)
			neighbors.add(grid.get(x + (y + 1) * cols));
		if (y > 0)
			neighbors.add(grid.get(x + (y - 1) * cols));
	}

}
