Gambler[] gamblers;
int numGamblers = 1000000;
int totalTries, totalDone, minTries, maxTries;
float chance = 1.0;
int txtSize = 32;
int[] scrnResult;
int[] theResult, medianResult, modeResult;
float mean, median, mode, theStandardDeviation, theIntStandardDeviation, repValue;
volatile boolean doneCalc = false;

void setup()
{
	size(800, 600);
	textSize(txtSize);
	noStroke();
	thread("calculateResult");
}

void calculateResult()
{
	int startTime = millis();
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
		// println(String.format("%d out of %d gamblers done", totalDone, gamblers.length));
	}
	//println("finished gambling at " + totalDone);

	// analyze the result by its representative values mean mode and median.
	getResult();
	//println(totalTries);
	println("calculation time: " + 0.001 * (millis() - startTime) + " seconds");
	doneCalc = true;
}

void showLoadingScreen()
{
	background(51);
	textSize(txtSize);
	textAlign(CENTER);
	fill(frameCount % 256);
	text("LOADING", width * 0.5, height * 0.5);
}

void draw()
{
	if (!doneCalc)
	{
		showLoadingScreen();
	}
	else
	{
		background(0);
		textAlign(LEFT);
		textSize(16);
		stroke(255);

		// print result
		println("mean " + mean);
		println("mode " + mode);
		println("median " + median);
		println("representative value " + repValue);
		println("standard deviation using mean " + theStandardDeviation);
		println("standard deviation using integer N " + theIntStandardDeviation);
		// draw R mean G mode B median vertical lines

		fill(255, 0, 0, 255);
		stroke(255, 0, 0, 255);
		text("mean " + mean, 7 * width / 13, height / 3);
		line(mean, 0, mean, height);
		fill(0, 255, 0, 255);
		stroke(0, 255, 0, 255);
		text("mode " + (int)mode + "   " + theResult[(int)mode], 7 * width / 13, height / 3 + txtSize);
		line(mode, 0, mode, height);
		fill(0, 0, 255, 255);
		stroke(0, 0, 255, 255);
		text("median " + (int)median, 7 * width / 13, height / 3 + 2 * txtSize);
		line(median, 0, median, height);
		fill(255);
		stroke(255, 255);
		text("representative value " + repValue, 7 * width / 13, height / 3 + 3 * txtSize);
		text("standard deviation using mean " + theStandardDeviation, 7 * width / 13, height / 3 + 4 * txtSize);
		text("standard deviation using integer N " + theIntStandardDeviation, 7 * width / 13, height / 3 + 5 * txtSize);
		text("minTries " + minTries, 7 * width / 13, height / 3 + 6 * txtSize);
		text("maxTries " + maxTries, 7 * width / 13, height / 3 + 7 * txtSize);

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
	// +1 there because no gambler can succeed in 0 tries but it needs to be in there to plot a diagram,
	// where x axis is number of tries and y axis is number of gamblers and read y amount of gamblers succeeded
	// after doing x amount of tries

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

	// getting the standard deviation

	// loop from 0 to theResult.length and get n which makes smallest standard deviation
	// that n is the representative value and use that n to get The standard deviation
	// in this specific scenario, representative value is about the mean value,
	// but since it's impossible to loop through every real number in a given range, will be using integers instead
	// therefore we might get wrong standard deviation in the end
	// ¯\_(ツ)_/¯
	// https://emojipedia.org/shrug/
	// but to compare that with when using the mean value, let's just use the mean value first to get standard deviation and see if later calculated standard deviation
	// by looping in integers is smaller than the previous one.
	// because we're using float data type so there must be errors in this kind of calculation
	// and computers can't handle infinite number of digits anyway (eg. 1/3 = 0.3333333... but in computers it's 0.33333333 that ends)
	// i don't know... i just don't...

	// get deviation array
	repValue = mean;
	float[] deviationArray = new float[gamblers.length];
	for (int i = 0; i < deviationArray.length; i++)
	{
		deviationArray[i] = gamblers[i].tries - repValue;
	}
	// now square all values in deviation array and get them average to get variance
	// make variance array
	float[] varianceArray = new float[deviationArray.length];
	float variance = 0;
	for (int i = 0; i < varianceArray.length; i++)
	{
		varianceArray[i] = sq(deviationArray[i]);
		variance += varianceArray[i];
	}
	// now get variance
	variance /= varianceArray.length;

	// now calculate standard deviation from variance
	theStandardDeviation = sqrt(variance);

	theIntStandardDeviation = Float.POSITIVE_INFINITY;
	for (int n = 0; n < theResult.length; n++)
	{
		// get deviation array
		deviationArray = new float[gamblers.length];
		for (int i = 0; i < deviationArray.length; i++)
		{
			deviationArray[i] = gamblers[i].tries - n;
		}
		// now square all values in deviation array and get them average to get variance
		// make variance array
		varianceArray = new float[deviationArray.length];
		variance = 0;
		for (int i = 0; i < varianceArray.length; i++)
		{
			varianceArray[i] = sq(deviationArray[i]);
			variance += varianceArray[i];
		}
		// now get variance
		variance /= varianceArray.length;

		// now calculate standard deviation from variance
		float standardDeviation = sqrt(variance);

		// if current standard deviation is lesser than the record value, this is the new The standard deviation
		// and n is the representative value that gives least of standard deviation
		if (standardDeviation < theIntStandardDeviation)
		{
			theIntStandardDeviation = standardDeviation;
			if (theIntStandardDeviation < theStandardDeviation)
			{
				repValue = n;
			}
		}
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
