// noise map

color black = color(0, 0, 0);
color green = color(64, 128, 64);
color blue = color(0, 126, 192);
color mustard = color(187, 162, 24);
color white = color(255, 255, 255);

int numImages = 8;
PImage[] images = new PImage[numImages];

int seed = int(random(1000000));
int[] sizes = { 20 }; // { 20, 40 }
int lstep = sizes[sizes.length - 1];
int step;

float d0, d1, dz, dv;

void setup() {
  size(600, 800);
  frameRate(25);
  noStroke();

  randomSeed(seed);

  step = sizes[int(random(sizes.length))];
  d0 = random(100, 200);
  d1 = random(25, 75);
  dz = random(0, 100);
  dv = random(0, 0.1);

  textFont(createFont("IBMPlexMono-Medium.ttf", 50));
  textAlign(LEFT, TOP);

  for (int i = 0; i < numImages; i++) {
    String imageName = "data/F" + nf(i, 2) + ".png";
    images[i] = loadImage(imageName);
  }

}

void draw() {
  
  //background(blue);

  // noise map

    for (int j = 0; j < height; j += step) {
      for (int i = 0; i < width; i += step) {
        
        float n0 = noise(i / d0, j / d0, dz);
        float n1 = noise(i / d1, j / d1, dz + 10);
        float n = 1 - (n0 * 0.75 + n1 * 0.25);

        int k = int(n * images.length);

        fill(lerpColor(blue, white, n));
        rect(i, j, step, step);
        image(images[k], i, j, step, step);
        
      }
    }

  // typography

  fill(255);
  rect(0, lstep * 2, lstep * 6, lstep);
  fill(0);
  textSize(lstep * 0.7);
  text("mejking 2021", lstep / 2, lstep * 2);

  fill(255);
  rect(0, height - lstep, width, lstep);
  fill(0);
  text("#" + seed, lstep / 2, height - lstep + lstep / 8);

  dz += dv;
  
}

void keyPressed() {
  
  seed = int(random(1000000));
  step = sizes[int(random(sizes.length))];
  d0 = random(100, 200);
  d1 = random(25, 75);
  dz = random(0, 100);
  dv = random(0, 0.1);
  
}
