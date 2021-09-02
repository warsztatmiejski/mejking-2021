import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

Capture cam;
OpenCV opencv;
Rectangle[] faces;
 
void setup() { 
  size(640, 480); 
  cam = new Capture(this);
  opencv = new OpenCV(this, cam);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  cam.start(); 
} 
 
void draw() { 
  if (cam.available()) { 
    cam.read();
    background(0);
  }
  
  opencv.loadImage(cam); 
  faces = opencv.detect();
  
  image(cam, 0, 0);
  
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
} 
