import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class gamblersfallacy extends PApplet {

Gambler[] gamblers;
int numGamblers = 1000000;
int totalTries, totalDone, minTries, maxTries;
float chance = 1;
int txtSize = 32;
int[] scrnResult;
int[] theResult, medianResult, modeResult;
int mean, median, mode;

public void setup()
{
	
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

public void draw()
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
	text("mode " + mode + "   " + theResult[mode], 3 * width / 5, height / 3 + txtSize);
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
		line(i, height, i, height - map(barHeight, 0, barHeightMax, 0, 0.8f * height));
	}

	println("done.");
	noLoop();
}

public void getResult()
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
	mean = totalTries / gamblers.length;
	float medianIndex = 0;

	// getting the mode value. loop through theResult[num of tries] = num of gamblers array
	// and get the index number that holds largest number of gamblers.

	for (int i = 0; i < theResult.length; i++)
	{
		if (theResult[i] > theResult[mode])
		{
			mode = i;
		}
	}

	// getting the median value. sort the array, median index is number of elements in the array + 1 / 2
	// but subtract by 1 because index actually starts at 0
	// if number of elements is not odd, get two values at number of elements in the array / 2 and +1 of that
	// and get the average.
	medianResult = sort(medianResult);
	medianIndex = (medianResult.length + 1) / 2 - 1;
	if ((medianResult.length) % 2 != 0)
	{
		median = medianResult[(medianResult.length + 1) / 2 - 1]; //start from zero
	}
	else
	{
		median = (medianResult[(medianResult.length) / 2 - 1] + medianResult[(medianResult.length) / 2]) / 2;
	}
}

public void gambletick()
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
//simple gambler class
class Gambler
{
  //number of tries 
  int tries;
  //succeeded
  boolean done;

  Gambler() {
    //number of tries starts at zero
    tries = 0;
    //not done when created
    done = false;
  }

  public void update()
  {
    //if it's not done
    if (!done) {
      // gambling count goes up by 1
      tries++;
      // quit gambling if succeeded
      done = random(100) <= chance;
    }
  }
}
  public void settings() { 	size(400, 400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "gamblersfallacy" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
