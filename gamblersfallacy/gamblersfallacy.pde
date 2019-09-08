Gambler[] gamblers;
int numGamblers = 1000000;
int totalTries, totalDone, minTries, maxTries;
float chance = 1;
int txtSize = 32;
int[] scrnResult;
int[] theResult, medianResult, modeResult;
float mean, median, mode;

void setup()
{
	size(400, 400);
	textSize(txtSize);
	noStroke();
	// make a gambler array that contains numGamblers number of gamblers
	gamblers = new Gambler[numGamblers];
	for (int i = 0; i < numGamblers; i++)
	{
		gamblers[i] = new Gambler();
	}
	// start gambling until everyone's done
	totalDone = 0;
	//println("starting gamble from " + totalDone);
	while (totalDone < gamblers.length)
	{
		gambletick();
		println(String.format("%d out of %d gamblers done", totalDone, gamblers.length));
	}
	//println("finished gambling at " + totalDone);

	// analyze the result by its representative values mean mode and median.
	getResult();
	//println(totalTries);
}

void draw()
{
	background(0);
	textSize(16);
	stroke(255);

	// print result
	println("mean " + mean);
	println("mode " + mode);
	println("median " + median);
	// draw R mean G mode B median vertical lines

	fill(255, 0, 0, 255);
	stroke(255, 0, 0, 255);
	text("mean " + mean, 3 * width / 5, height / 3);
	line(mean, 0, mean, height);
	fill(0, 255, 0, 255);
	stroke(0, 255, 0, 255);
	text("mode " + mode + "   " + theResult[(int)mode], 3 * width / 5, height / 3 + txtSize);
	line(mode, 0, mode, height);
	fill(0, 0, 255, 255);
	stroke(0, 0, 255, 255);
	text("median " + median, 3 * width / 5, height / 3 + 2 * txtSize);
	line(median, 0, median, height);
	fill(255);
	stroke(255, 255);
	text("minTries " + minTries, 3 * width / 5, height / 3 + 3 * txtSize);
	text("maxTries " + maxTries, 3 * width / 5, height / 3 + 4 * txtSize);



	// draw vertical grid
	stroke(255, 50);
	for (int i = 0; i < width / 100; i++)
	{
		line(i * 100, 0, i * 100, height);
	}

	// scale height of each bar that maximum height is about 80% of height of the screen and draw graph
	stroke(255);
	int barHeightMax = 0;
	for (int i = 0; i < theResult.length; i++)
	{
		barHeightMax = barHeightMax < theResult[i] ? theResult[i] : barHeightMax;
	}
	println(barHeightMax);
	for (int i = 0; i < theResult.length; i++)
	{
		float barHeight = theResult[i];
		line(i, height, i, height - map(barHeight, 0, barHeightMax, 0, 0.8 * height));
	}

	println("done.");
	noLoop();
}

void getResult()
{
	minTries = gamblers[0].tries < gamblers[1].tries ? gamblers[0].tries : gamblers[1].tries;
	maxTries = gamblers[0].tries >= gamblers[1].tries ? gamblers[0].tries : gamblers[1].tries;
	// loop through every gambler in the array
	for (int i = 0; i < gamblers.length; i++)
	{
		// add a gambler's number of tries to total number of tries pool
		totalTries += gamblers[i].tries;
		// update minimum and maximum number of tries in the pool
		if (gamblers[i].tries < minTries)
		{
			minTries = gamblers[i].tries;
		}
		else if (gamblers[i].tries > maxTries)
		{
			maxTries = gamblers[i].tries;
		}
	}

	theResult = new int[maxTries + 1];
	medianResult = new int[gamblers.length];

	// theResult[num of tries] = num of gamblers who did that tries
	// eg. if there are number of 8 gamblers who succeeded after doing 5 tries, theResult[5] = 8;
	// medianResult holds list of each gamblers' tries in each element and later be sorted and used to calculate median.
	for (int i = 0; i < gamblers.length; i++)
	{
		theResult[gamblers[i].tries]++;
		medianResult[i] = gamblers[i].tries;
	}
	//println(theResult);
	mean = 1.0 * totalTries / gamblers.length;
	float medianIndex = 0;

	// getting the mode value. loop through theResult[num of tries] = num of gamblers array
	// and get the index number that holds largest number of gamblers.

	for (int i = 0; i < theResult.length; i++)
	{
		if (theResult[i] > theResult[(int)mode])
		{
			mode = i;
		}
	}

	// getting the median value. sort the array, median index is number of elements in the array + 1 / 2
	// but subtract by 1 because index actually starts at 0
	// if number of elements is not odd, get two values at number of elements in the array / 2 and +1 of that
	// and get the average.
	medianResult = sort(medianResult);
	medianIndex = (medianResult.length + 1) * 0.5 - 1;
	if ((medianResult.length) % 2 != 0)
	{
		median = medianResult[(int)((medianResult.length + 1) * 0.5 - 1)]; //start from zero
	}
	else
	{
		median = (medianResult[(int)((medianResult.length) *0.5 - 1)] + medianResult[(int)((medianResult.length) *0.5)]) * 0.5;
	}
}

void gambletick()
{
	//loop for every gamblers in the gambler array
	totalDone = 0;
	for (int i = 0; i < gamblers.length; i++)
	{
		//perform gamble
		gamblers[i].update();
		if (gamblers[i].done)
		{
			totalDone++;
		}
	}
}
