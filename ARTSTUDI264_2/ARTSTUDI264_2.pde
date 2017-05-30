/* CITATIONS:
 * https://gist.github.com/neufuture/1975615
 * https://github.com/atduskgreg/opencv-processing/blob/master/examples/LiveCamTest/LiveCamTest.pde
 * 
 * USEFUL LINKS:
 * http://atduskgreg.github.io/opencv-processing/reference/gab/opencv/OpenCV.html
 * https://processing.org/reference/filter_.html
 * https://forum.processing.org/two/discussion/9309/how-to-flip-image
 * https://github.com/atduskgreg/opencv-processing/tree/master/lib
 *
 */

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
int SCALE = 4;

/* TODOS: 
 * !! 1 and 2 are both math ugh
 * 1. fix blur to work with scale
 * 2. flip image
 * 
 * 3. facial recognition (person-specific)
 * 4. annotations
 * 5. database things
 */

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
    blurred = get(x + (width - x)/SCALE, y+ (height - y)/SCALE, w, h);
    blurred.filter(BLUR, 1);
    image(blurred, x, y);
    rect(x, y, w, h);
  }
}