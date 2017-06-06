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
int BLUR_INTENSITY = 10;

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
  opencv.loadImage(video);
  scale(-SCALE,SCALE); 
  image(video, -width/SCALE, 0 );

  noFill();
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  BlurBox bb[] = new BlurBox[faces.length];
  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    bb[i] = new BlurBox(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    println(bb[i].x, bb[i].y, bb[i].w, bb[i].h);
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
    
    blurred = get(width - x*SCALE - w*SCALE, y*SCALE, w*SCALE, h*SCALE);
    blurred.filter(BLUR, BLUR_INTENSITY);
    image(blurred, -(width/SCALE - x), y, w, h);
    
  }
}