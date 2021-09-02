// Mejking 2021 Festival
// Visual Identity
// test app
// by @fallenartist

import processing.video.*;
import processing.sound.*;
import gab.opencv.*;
import java.awt.Rectangle;

Capture cam;
OpenCV opencv;
Rectangle[] faces;

BrownNoise noise;
SinOsc sine;

color[] cp = {
  color(0, 126, 192),
  color(24, 154, 208),
  color(58, 168, 214),
  color(94, 186, 220),
  color(128, 199, 228),
  color(163, 216, 235),
  color(197, 229, 243),
  color(232, 244, 250),
  color(245, 251, 255)
};
color black = color(0, 0, 0);
color green = color(64, 128, 64);
color blue = color(0, 126, 192);
color mustard = color(187, 162, 24);
color white = color(255, 255, 255);

//PFont font_med;
//PFont font_bold;
//font_med = createFont("IBMPlexMono-Medium.ttf", 50);
//font_bold = createFont("IBMPlexMono-Bold.ttf", 50);

float nValues;

int numImages = 8;
PImage[] images = new PImage[numImages];

int seed = int(random(1000000));
int[] sizes = { 20, 40 };
int lstep = sizes[sizes.length - 1];
int step;

float d0, d1, dz, dv;
int fx = 0, fy = 0, fw = 0, fh = 0, fi;
float ratio;

float luma(color c){
  return (.299f*red(c)) + (.587f*green(c)) + (.114f*blue(c));
}
float cl;

void setup() {
  size(600, 800);
  frameRate(25);
  noStroke();

  cam = new Capture(this);
  opencv = new OpenCV(this, cam);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  cam.start();

  randomSeed(seed);
  noiseSeed(seed);

  step = sizes[int(random(sizes.length))]; //int(random(2, 5))*10;
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

  noise = new BrownNoise(this);
  noise.play(0.2);

  sine = new SinOsc(this);
  sine.play(200, 0.4);
}

void draw() {
  
  background(cp[0]);
  
  if (cam.available()) {
    cam.read();
  }

  int m = millis();
  //sine.stop();
  nValues = 0;
  
  // detect faces
  opencv.loadImage(cam);
  faces = opencv.detect();
  fw = 0;
  fi = -1;
  for (int i = 0; i < faces.length; i++) {
    if (faces[i].width > fw) {
      fx = faces[i].x;
      fy = faces[i].y;
      fw = faces[i].width;
      fh = faces[i].height;
      fi = i;
    }
  }

  if (fi > -1) { // human detected!
    
    ratio = float(width) / float(height);

    image(cam, 0, 0);
    
    copy(cam, int(fx - (fw * ratio - fw) / 2), fy, int(fw * ratio), fh, 0, 0, width / step, height / step);
    PImage face_img = get(0, 0, width / step, height / step);
    face_img.filter(GRAY);
    
    for (int j = 0; j < face_img.height; j++) {
      for (int i = 0; i < face_img.width; i++) {
        float n = brightness(face_img.get(i, j)) / 256;
        int k = int(n * images.length);

        fill(lerpColor(blue, white, n)); //cp[k]
        //fill(green);
        rect(i * step, j * step, step, step);
        image(images[k], i * step, j * step, step, step);
      }
    }
    
  } else { // noise map

    for (int j = 0; j < height; j += step) {
      for (int i = 0; i < width; i += step) {
        float n0 = noise(i / d0, j / d0, dz);
        float n1 = noise(i / d1, j / d1, dz + 10);
        float n = 1 - (n0 * 0.75 + n1 * 0.25);

        int k = int(n * images.length);

        fill(lerpColor(blue, white, n)); //cp[k]
        //fill(green);
        rect(i, j, step, step);
        image(images[k], i, j, step, step);

        nValues += n;
      }
    }
    
  }

  // typography

  fill(255);
  rect(0, lstep * 2, lstep * 6, lstep);
  fill(0);
  textSize(lstep * 0.7);
  text("mejking 2021", lstep / 2, lstep * 2);

  fill(255);
  rect(0, lstep * 4, lstep * 7, lstep);
  fill(0);
  textSize(lstep * 0.5);
  text("sztuka i elektronika", lstep / 2, lstep * 4 + lstep / 8);

  fill(255);
  rect(0, height - lstep, width, lstep);
  fill(0);
  text("#" + seed, lstep / 2, height - lstep + lstep / 8);
  
  // sound
  float r = random(0, 100);
  if (r<5) {
    sine.set(random(150, 250), 0.4, 0, 0);
    noise.set(random(0.1, 0.2), 0, 0);
    step = sizes[int(random(sizes.length))];
  }

  dz += dv;

  //noLoop();
  
  // save("maps/Map_a2x1_ID" + seed + ".png");
  
}

void keyPressed() {
  
  seed = int(random(1000000));
  step = sizes[int(random(sizes.length))];
  d0 = random(100, 200);
  d1 = random(25, 75);
  dz = random(0, 100);
  dv = random(0, 0.1);
  
  //loop();
  
}
