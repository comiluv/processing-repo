public class Disk
{
	int diskSize;
	float diskWidth, diskHeight;
	int diskColor;

	public Disk (int size_)
	{
		// size is given in argument
		diskSize = size_;
		// height is always calculated so all of it would fill an empty tower
		diskHeight = towerHeight / numDisks;
		// width is calculated to be between quarter of screen width and eighth of screen width depending on the size of the disk
		diskWidth = map(diskSize, 1, numDisks, width * 0.125, width * 0.25);
		// give the disk a random color
		diskColor = 0xFF000000 + floor(random(255)) * 0x10000 + floor(random(255)) * 0x100 + floor(random(255));
	}

	public Disk (int size_, float height_, float width_, int color_)
	{
		// disk can be constructed giving all its properties as arguments
		diskSize = size_;
		diskHeight = height_;
		diskWidth = width_;
		diskColor = color_;
	}

	void rend(int currLoc, int currIndex)
	{
		fill(diskColor);
		// calculate x and y position depending on the current location (the pole) and its index
		// and factoring in disks width and height
		float x = width * currLoc *  0.25 - diskWidth * 0.5;
		float y = height - (1 + currIndex) * diskHeight;
		// println("size " + diskSize + " x " + x + " y " + y);
		rect(x, y, diskWidth, diskHeight, 10);

	}
}
