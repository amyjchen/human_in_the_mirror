import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
int SCALE = 4;

void setup() {   
  fullScreen();
  video = new Capture(this, width/SCALE, height/SCALE);
  opencv = new OpenCV(this, width/SCALE, height/SCALE);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

void draw() {
  scale(SCALE);
  opencv.loadImage(video);
  image(video, 0, 0 );

  noFill();
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  BlurBox bb[] = new BlurBox[faces.length];
  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    bb[i] = new BlurBox(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    bb[i].display();
  }
}

void captureEvent(Capture c) {
  c.read();
}

class BlurBox { 
  int x, y, w, h;
  PImage blurred;

  BlurBox (int x_, int y_, int w_, int h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    blurred = new PImage(w_, h_);
  }

  void display() {
    noStroke();
    noFill();
    // TODO: FIX BLUR BOX VIDEO SAMPLE AREA TO COORDINATE WITH SCALE
    blurred = get(x, y, w, h);
    blurred.filter(BLUR, 5);
    image(blurred, x, y);
    rect(x, y, w, h);
  }
}