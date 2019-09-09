// visualization of tower of hanoi problem using recursive function
// https://en.wikipedia.org/wiki/Tower_of_Hanoi
// https://www.openprocessing.org/sketch/482860/ this looks like an iterative solution
// Jaeho Choi

int numDisks = 10;
int stepSol = 0;
boolean useMouseClick = false; // set this to true to use mouse click every move
float sleepInterval = 0.1; // interval between moves in seconds
ArrayList <Disk> towerSource, towerAux, towerTarget;
ArrayList <ArrayList <Disk> > recSolution;
float towerWidth, towerHeight;
float txtSize = 14;
int maxSteps = (int)pow(2, numDisks) - 1;
// https://www.google.com/search?q=volatile+boolean
volatile boolean doneLoading = false;
void setup()
{
	size(800, 600);
	noStroke();
	textSize(txtSize);
	towerWidth = 40;
	towerHeight = height * 0.5;
	towerSource = new ArrayList <Disk> ();
	towerAux = new ArrayList <Disk> ();
	towerTarget = new ArrayList <Disk> ();
	recSolution = new ArrayList <ArrayList <Disk> > ();
	// awesome multi threading support
	thread("loadData");
}

void draw()
{
	if (!doneLoading)
	{
		showLoadingScreen();
	}
	else
	{
		background(51, 255);
		textAlign(LEFT);
		textSize(txtSize);
		fill(255);
		text(stepSol / 3, 0, txtSize);
		text((100.0 * (stepSol / 3) / maxSteps) + "%", 0, 2 * txtSize);
		// draw towers
		fill(100, 80, 20);
		// source tower (left)
		rect(width * 0.25 - towerWidth * 0.5, height - towerHeight, towerWidth, towerHeight, 10, 10, 0, 0);
		// aux tower (middle)
		rect(width * 0.5 - towerWidth * 0.5, height - towerHeight, towerWidth, towerHeight, 10, 10, 0, 0);
		// target tower (right)
		rect(width * 0.75 - towerWidth * 0.5, height - towerHeight, towerWidth, towerHeight, 10, 10, 0, 0);

		// render disks
		// println(stepSol);
		for (int i = 0; i < recSolution.get(stepSol + 0).size(); i++)
		{
			recSolution.get(stepSol + 0).get(i).rend(1, i);
		}
		for (int i = 0; i < recSolution.get(stepSol + 1).size(); i++)
		{
			recSolution.get(stepSol + 1).get(i).rend(2, i);
		}
		for (int i = 0; i < recSolution.get(stepSol + 2).size(); i++)
		{
			recSolution.get(stepSol + 2).get(i).rend(3, i);
		}
		stepSol += 3;

		if (stepSol > recSolution.size() - 3)
		{
			fill(255);
			text("Done", 0, txtSize * 3);
			println("done");
			noLoop();
		}
		if (useMouseClick)
		{
			noLoop();
		}
		else
		{
			sleep(sleepInterval);
		}
	}
}

void initializeDisks()
{
	for (int i = numDisks; i > 0; i--)
	{
		towerSource.add(new Disk(i));
	}
}

void solveHanoi(int n, ArrayList s, ArrayList t, ArrayList a)
{
	if (n > 0)
	{
		solveHanoi(n - 1, s, a, t);
		t.add(s.remove(s.size() - 1));
		// only save status when a change is made
		saveSnapshot();
		solveHanoi(n - 1, a, t, s);
	}
}

void saveSnapshot()
{
	// simple and dirty way of saving snapshot of every pole on the screen
	// supposedly could use clone() as in https://www.geeksforgeeks.org/clone-method-in-java-2/
	// but didn't
	recSolution.add(new ArrayList <Disk> ());
	for (int i = 0; i < towerSource.size(); i++)
	{
		recSolution.get(recSolution.size() - 1).add(new Disk(
								    towerSource.get(i).diskSize, towerSource.get(i).diskHeight, towerSource.get(i).diskWidth, towerSource.get(i).diskColor));
	}
	recSolution.add(new ArrayList <Disk> ());
	for (int i = 0; i < towerAux.size(); i++)
	{
		recSolution.get(recSolution.size() - 1).add(new Disk(
								    towerAux.get(i).diskSize, towerAux.get(i).diskHeight, towerAux.get(i).diskWidth, towerAux.get(i).diskColor));
	}
	recSolution.add(new ArrayList <Disk> ());
	for (int i = 0; i < towerTarget.size(); i++)
	{
		recSolution.get(recSolution.size() - 1).add(new Disk(
								    towerTarget.get(i).diskSize, towerTarget.get(i).diskHeight, towerTarget.get(i).diskWidth, towerTarget.get(i).diskColor));
	}
}

void sleep(float seconds)
{
	float now = (float)millis();
	while ((float)millis() < now + seconds * 1000)
	{
		// DO NOTHING
	}
}

void mouseClicked()
{
	if (useMouseClick && maxSteps >= stepSol / 3)
	{
		loop();
	}
}

void showLoadingScreen()
{
	background(51, 255);
	fill(255, frameCount % 255);
	textAlign(CENTER);
	textSize(width / 8);
	text("LOADING", width * 0.5, height * 0.5);
}

void loadData()
{
	initializeDisks();
	// save initial status
	saveSnapshot();
	solveHanoi(numDisks, towerSource, towerTarget, towerAux);
	doneLoading = true;
}