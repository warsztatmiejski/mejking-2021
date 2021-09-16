// noise map

color black = color(0, 0, 0);
color green = color(64, 128, 64);
color blue = color(0, 126, 192);
color mustard = color(187, 162, 24);
color white = color(255, 255, 255);

int num_images = 8;
PImage[] images = new PImage[num_images];

IntList ii = new IntList();
int[] iish;

int seed = int(random(1000000));
int[] sizes = { 20, 40, 80 };
int min_step = min(sizes);
int max_step = max(sizes);
int step;

float d0, d1, dz, dv, rvx, rvy;

float[] rr;

PRNG prng = new PRNG();

void setup() {
  size(600, 800);
  frameRate(25);
  noStroke();

  randomSeed(seed);
  
  d0 = random(100, 200);
  d1 = random(25, 75);
  dz = random(0, 100);
  dv = random(0, 0.1);
  
  rr = new float[(width / max_step * height / max_step) / int(random(8, 13)) * 2];
  for (int i = 0; i < rr.length; i+=2) {
    rr[i] = random(width / max_step);
    rr[i+1] = random(height / max_step);
  }

  textFont(createFont("IBMPlexMono-Medium.ttf", 50));
  textAlign(LEFT, TOP);
  
  for (int i = 0; i < num_images; i++) ii.append(i);
  ii.shuffle();
  iish = ii.array();

  for (int i = 0; i < num_images; i++) {
    String image_name = "data/F" + nf(i, 2) + ".png";
    images[i] = loadImage(image_name);
  }

}

void draw() {

  // noise map
  // 3 passes at 1x, 2x & 4x step size
  // with decreasing random frequency infill
  
  for (int p = 0; p < sizes.length; p++) {
    
    step = sizes[p];

    for (int j = 0; j < height; j += step) {
      for (int i = 0; i < width; i += step) {
        
        int loc = int(i + j * width);
        
        float n0 = prng.perlin(i / (d0 + dz), j / (d0 + dz));
        float n1 = prng.perlin(i / (d1 + dz), j / (d1 + dz));
        float n = 1 - (n0 * 0.75 + n1 * 0.25);
        int k = int(n * num_images);
        
        if (p == 0) { // draw all

          fill(lerpColor(blue, white, iish[k]/10.0));
          rect(i, j, step, step);
          image(images[iish[k]], i, j, step, step);
        
        } else if (p == 1 && iish[k] < 4) { // draw some of the shades
          
          fill(lerpColor(blue, white, iish[k]/10.0));
          rect(i, j, step, step);
          image(images[iish[k]], i, j, step, step);
          
        } else if (p == 2) {
          
          for (int r = 0; r < rr.length; r += 2) {
            if (i == int(rr[r]) * step && j == int(rr[r+1]) * step) {
              fill(lerpColor(blue, white, iish[k]/10.0));
              rect(i, j, step, step);
              image(images[iish[k]], i, j, step, step);
            }
          }
          
        }

      }
    }
    
  }

  // typography

  fill(255);
  rect(0, min_step * 2, min_step * 6, min_step);
  fill(0);
  textSize(min_step * 0.7);
  text("mejking 2021", min_step / 2, min_step * 2);

  fill(255);
  rect(0, height - min_step, width, min_step);
  fill(0);
  text("#" + seed, min_step / 2, height - min_step + min_step / 8);

  // move stuff
  dz += dv;
  
  //noLoop();
  
}

void keyPressed() {
  
  seed = int(random(1000000));
  randomSeed(seed);
  d0 = random(100, 200);
  d1 = random(25, 75);
  dz = random(0, 100);
  dv = random(0, 0.1);
  
  ii.shuffle();
  iish = ii.array();
  
  rr = new float[(width / max_step * height / max_step) / int(random(8, 13)) * 2];
  for (int i = 0; i < rr.length; i+=2) {
    rr[i] = random(width / max_step);
    rr[i+1] = random(height / max_step);
  }
  
  //loop();
  
}
