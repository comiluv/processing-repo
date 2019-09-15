int cols = 100;
int rows = 100;
float spotw, spoth;
float wallChance = 0.3;
ArrayList <Spot> grid = new ArrayList <Spot> ();
ArrayList <Spot> openSet = new ArrayList <Spot> ();
ArrayList <Spot> closedSet = new ArrayList <Spot> ();
ArrayList <Spot> path = new ArrayList <Spot> ();

Button startButton;
Button resetButton;
ArrayList <Button> buttons = new ArrayList <Button> ();

Spot start;
Spot end;
Spot current;

boolean bStart = false;
void setup()
{
	size(600, 600);
	grid = new ArrayList <Spot> ();
	openSet = new ArrayList <Spot> ();
	closedSet = new ArrayList <Spot> ();
	path = new ArrayList <Spot> ();
	buttons = new ArrayList <Button> ();
	startButton = new Button("START", 400, 1, 100, 40);
	resetButton = new Button("RESET", 500, 1, 100, 40);
	buttons.add(startButton);
	buttons.add(resetButton);
	bStart = false;

	spotw = float(width) / cols;
	spoth = float(height) / rows;
	for (int j = 0; j < rows; j++)
	{
		for (int i = 0; i < cols; i++)
		{
			grid.add(new Spot(i, j));
		}
	}

	for (Spot s : grid)
	{
		s.addNeighbors();
		s.addNeighborsWall();
	}

	start = grid.get(0);
	end = grid.get((cols - 1) + (rows - 1) * cols);
	start.wall = false;
	end.wall = false;
	openSet.add(start);
}

void mouseClicked()
{
	Button b;
	if (startButton.mouseOver())
	{
		bStart = true;
	}
	else
	if (resetButton.mouseOver())
	{
		loop();
		setup();
	}
}

void mouseDragged()
{
	boolean onButton = false;
	for (Button b : buttons)
	{
		if (b.mouseOver())
		{
			onButton = true;
			break;
		}
	}
	if (!bStart && !onButton && mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height)
	{
		Spot s;
		s = grid.get(
			int(mouseX / spotw) + int(mouseY / spoth) * cols);
		s.wall = true;
	}
}


float heuristic(Spot a, Spot b)
{
	float d = dist(a.x, a.y, b.x, b.y);
	// float d = abs(a.x - b.x) + abs(a.y - b.y);
	return d;
}

void draw()
{
	background(255);
	if (bStart)
	{
		if (openSet.size() > 0)
		{
			int lowestIndex = 0;
			for (int i = 0; i < openSet.size(); i++)
			{
				if (openSet.get(i).f < openSet.get(lowestIndex).f)
					lowestIndex = i;
			}
			current = openSet.get(lowestIndex);
			if (current == end)
			{
				println("Done!");
				noLoop();
			}

			openSet.remove(current);
			closedSet.add(current);

			ArrayList <Spot> neighbors = current.neighbors;
			for (int i = 0; i < neighbors.size(); i++)
			{
				Spot neighbor = neighbors.get(i);
				if (!closedSet.contains(neighbor) && !neighbor.wall)
				{
					float tempG = current.g + heuristic(current, neighbor);
					boolean newPath = false;

					if (openSet.contains(neighbor))
					{
						if (tempG < neighbor.g)
						{
							neighbor.g = tempG;
							newPath = true;
						}
					}
					else
					{
						neighbor.g = tempG;
						newPath = true;
						openSet.add(neighbor);
					}
					if (newPath)
					{
						neighbor.h = heuristic(neighbor, end);
						neighbor.f = neighbor.h + neighbor.g;
						neighbor.previous = current;
					}
				}
			}

			// we can keep going
		}
		else
		{
			println("No solution");
			noLoop();
			// no solution
		}
		ArrayList <Spot> path = new ArrayList <Spot> ();
		Spot temp = current;
		path.add(temp);
		while (temp.previous != null)
		{
			path.add(temp.previous);
			temp = temp.previous;
		}
		beginShape();
		for (Spot s : path)
		{
			vertex(s.x * spotw + spotw * 0.5, s.y * spoth + spoth * 0.5);
			s.show(color(0, 0, 255));
		}
		noFill();
		stroke(255);
		strokeWeight(1);
		endShape();
	}
	for (int i = 0; i < cols; i++)
	{
		for (int j = 0; j < rows; j++)
		{
			grid.get(i + j * cols).show();
		}
	}

	for (int i = 0; i < closedSet.size(); i++)
	{
		closedSet.get(i).show(color(255, 0, 0, 50));
	}
	for (int i = 0; i < openSet.size(); i++)
	{
		openSet.get(i).show(color(0, 255, 0, 50));
	}

	for (Button b : buttons)
	{
		b.show();
	}
}
