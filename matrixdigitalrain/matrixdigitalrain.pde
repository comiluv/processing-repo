// inspired by Emily Xie's work in
// coding train's matrix digital rain tutorial
// https://www.youtube.com/watch?v=S1TQCi9axzg
// ported and modified to processing.java

Stream[] streams;
String fntName = "Yu Gothic UI";
PFont fnt;
int symbolSize = 14;

float fadeInterval = 1.6;

void setup()
{
	fnt = createFont(fntName, symbolSize);
	size(1600, 800);
	background(0);
	// fullScreen();
	textFont(fnt);
	textSize(symbolSize);
	streams = new Stream[floor(width / symbolSize)];
	int x = 0;
	for (int i = 0; i < width / symbolSize; i++)
	{
		Stream str = new Stream(x, random(-height, height));
		str.generateSymbols();
		streams[i] = str;
		x += symbolSize;
	}
}
void draw()
{
	fill(0, 150);
	rect(0, 0, width, height);
	for (Stream stream : streams)
	{
		stream.render();
	}
}
