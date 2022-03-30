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

int seed = 18041977;

int[] sizes = { 20, 40, 80 };
int min_step = min(sizes);
int max_step = max(sizes);
int step;

float d0, d1, dz, dv, dr, rvx, rvy;
int rl;
int[] rr;

FastNoiseLite noise = new FastNoiseLite();
RandAnywhere rand;

void setup() {
  size(600, 800);
  frameRate(25);
  noStroke();

  rand = new RandAnywhere(seed);
  println("lcg: " + toFixed(rand.random(), 5));
  
  noise.SetSeed(seed);
  noise.SetNoiseType(FastNoiseLite.NoiseType.OpenSimplex2);
  
  d0 = toFixed(rand.random(5, 10), 5);
  d1 = toFixed(rand.random(1, 5), 5);
  dz = toFixed(rand.random(0, 1), 5);
  dv = toFixed(rand.random(0, 0.1), 5);
  dr = floor(rand.random(8, 13));
  
  println("d0: " + d0 + ", d1: " + d1 + ", dz: " + dz + ", dv: " + dv + ", dr: " + dr);
  
  rl = floor(width / max_step * height / max_step / dr) * 2;
  //rr = new int[(width / max_step * height / max_step) / int(rand.random(8, 13)) * 2];
  println(rl);
  rr = new int[rl];
  for (int i = 0; i < rl; i+=2) {
    rr[i] = floor(toFixed(rand.random(width / max_step), 5));
    rr[i+1] = floor(toFixed(rand.random(height / max_step), 5));
  }
  println(rr);

  textFont(createFont("IBMPlexMono-Medium.ttf", 50));
  textAlign(LEFT, TOP);
  
  for (int i = 0; i < num_images; i++) ii.append(i);
  iish = shuffle(ii.array()); // random LCG!
  //iish = ii.array();
  println(iish);

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
        
        //int loc = int(i + j * width);
        
        float n0 = toFixed(noise.GetNoise(i / (d0 + dz), j / (d0 + dz)), 5);
        float n1 = noise.GetNoise(i / (d1 + dz), j / (d1 + dz));
        float n = 1 - (abs(n0) * 0.75 + abs(n1) * 0.25);
        int k = floor(n * (num_images - 1));
        if (i < 2) println("n0:" + n0);
        
        if (p == 0) { // draw all

          fill(lerpColor(blue, white, iish[k]/float(num_images)));
          rect(i, j, step, step);
          //image(images[iish[k]], i, j, step, step);
        
        } else if (p == 1 && iish[k] < 4) { // draw some of the shades
          
          fill(lerpColor(blue, white, iish[k]/float(num_images)));
          rect(i, j, step, step);
          //image(images[iish[k]], i, j, step, step);
          
        } else if (p == 2) {
          
          for (int r = 0; r < rr.length; r += 2) {
            if (i == int(rr[r]) * step && j == int(rr[r+1]) * step) {
              fill(lerpColor(blue, white, iish[k]/float(num_images)));
              rect(i, j, step, step);
              //image(images[iish[k]], i, j, step, step);
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
  
  noLoop();
  
}

void keyPressed() {
  
  seed = int(rand.random(10000000));
  rand.randomSeed(seed);
  noise.SetSeed(seed);
  
  d0 = rand.random(5, 10);
  d1 = rand.random(1, 5);
  dz = rand.random(0, 1);
  dv = rand.random(0, 0.1);
  
  ii.shuffle();
  iish = ii.array();
  
  rr = new int[(width / max_step * height / max_step) / int(rand.random(8, 13)) * 2];
  for (int i = 0; i < rr.length; i+=2) {
    rr[i] = int(rand.random(width / max_step));
    rr[i+1] = int(rand.random(height / max_step));
  }
  
  //println(rr);
  loop();
  
}

int[] shuffle(int[] array) {
  int m = array.length;
  int t, i;
  
  while (m > 0) {
    i = floor(rand.random() * m--);
    t = array[m];
    array[m] = array[i];
    array[i] = t;
  }

  return array;
}

float toFixed(float n, int d) {
  return Float.parseFloat(String.format("%." + d + "f", n));
}
