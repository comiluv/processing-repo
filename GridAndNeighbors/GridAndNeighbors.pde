int cols = 25;
int rows = 25;
float cw, ch;

ArrayList <Cell> grid = new ArrayList <Cell> ();
Cell mouseC;

void setup()
{
	size(500, 500);
	cw = float(width) / cols;
	ch = float(height) / rows;
	for (int j = 0; j < rows; j++)
	{
		for (int i = 0; i < cols; i++)
		{
			grid.add(new Cell(i, j));
		}
	}
	for (Cell c : grid)
		c.addNeighbors();

}
void draw()
{
	background(51, 255);
	for (Cell c : grid)
	{
		c.show(color(255));
	}

	// show cell @ mouse cursor
	mouseC = grid.get(int(mouseX / cw) + int(mouseY / ch) * cols);
	mouseC.show(color(255, 0, 0));

	// show cells in neighbors ArrayList
	for (Cell n : mouseC.neighbors)
	{
		n.show(color(255, 0, 0, 50));
	}
}