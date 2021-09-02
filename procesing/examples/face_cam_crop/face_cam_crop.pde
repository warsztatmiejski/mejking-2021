import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

Capture cam;
OpenCV opencv;
Rectangle[] faces;

int fx = 0, fy = 0, fw = 0, fh = 0, fi;
float cratio, fratio;

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
    noFill();
  }

  opencv.loadImage(cam);
  faces = opencv.detect();

  fw = 0;
  fi = -1;
  // get closest face
  for (int i = 0; i < faces.length; i++) {
    if (faces[i].width > fw) {
      fx = faces[i].x;
      fy = faces[i].y;
      fw = faces[i].width;
      fh = faces[i].height;
      fi = i;
    }
  }

  if (fi > -1) { // face(s) detected
    
    cratio = float(width) / float(height);
    fratio = float(fw) / float(fh);
    
    image(cam, 0, 0);
    copy(cam, int(fx - (fw * cratio - fw) / 2), fy, int(fw * cratio), fh, 0, 0, width, height);
    copy(cam, 0, 0, width, height, 20, 20, int(width / 5), int(height / 5));
    
    stroke(255, 0, 0);
    strokeWeight(2);
    for (int i = 0; i < faces.length; i++) {
      if (i == fi) stroke(0, 255, 0);
      rect(int(faces[i].x / 5) + 20, int(faces[i].y / 5) + 20, int(faces[i].width / 5), int(faces[i].height / 5));
    }
    //rect(int(fx / 5) + 20, int(fy / 5) + 20, int(fw / 5), int(fh / 5));
    
  } else {
    
    // no face
    
  }
}
