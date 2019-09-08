//Blob b;
//ArrayList<Blob> blobs;
int num_blobs = 10;
Blob[] blobs;

void setup()
{
	size(300, 300);
	colorMode(HSB);
	//blobs = new ArrayList<Blob>();
	blobs = new Blob[num_blobs];
	for (int i = 0; i < num_blobs; i++)
	{
		//blobs.add(new Blob(random(width), random(height)));
		blobs[i] = (new Blob(random(width), random(height)));
	}
}

void draw()
{
	background(51);

	loadPixels();
	for (int x = 0; x < width; x++)
	{
		for (int y = 0; y < height; y++)
		{
			int index = x + y * width;
			float sum = 0;
			for (Blob b : blobs)
			{
				float d = dist(x, y, b.pos.x, b.pos.y);
				sum += 40 * b.r / d;
			}
			sum = constrain(sum, 0, 220);
			pixels[index] = color(sum, 255, 255);
		}
	}
	updatePixels();
	for (Blob b : blobs)
	{
		b.update();
		//b.show();
	}
}
