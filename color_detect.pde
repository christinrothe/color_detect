/**
 * color_detect by
 * @christinrothe
 * @fabiantheblind
 *
 * for Input Output (Eingabe Ausgabe)
 * Fundamentals of process-oriented design
 * https://incom.org/workspace/5478
 *
 * based on ctrlr by
 * @Flave
 * @kernfruit
 * @killinglyfunny
 *
 * for Homo Effectus https://incom.org/projekt/5197
 * University of Applied Sciences Potsdam (Germany)
 * Project: DIY (Multi) Touch (less) Human Computer Interaction
 *
 *
 * ColorTracking
 * Select a colors to track
 *
 * It uses the OpenCV for Processing library by Greg Borenstein
 * https://github.com/atduskgreg/opencv-processing
 *
 * @author: Jordi Tost
 * @updated: 06/10/2014
 *
 * University of Applied Sciences Potsdam, 2014
 *
 *
 * Instructions:
 * Click on one color to track it
 */

import java.util.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

import netP5.*;

Capture video;
OpenCV opencv;
PImage src;



// List of my blob groups
BlobGroup blobGroup;
boolean color_visible = false;

void setup() {
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, video.width, video.height);

  size(opencv.width + opencv.width/4 + 30, opencv.height, P2D);
  video.start();
}

void draw() {

  background(150);

  if (video.available()) {
    video.read();
  }

  // <2> Load the new frame of our movie in to OpenCV
  opencv.loadImage(video);

  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();

  // <3> Tell OpenCV to work in HSV color space.
  opencv.useColor(HSB);

  image(src, 0, 0);

  if (blobGroup != null) {
    blobGroup.detectBlobs(src);
    // draw reference image and rectangle
    noStroke();
    fill(blobGroup.colr);
    rect(src.width, 0, 30, src.height/4);
    image(blobGroup.output, width - src.width/4, 0, src.width/4, src.height/4);
    if (blobGroup.visible) {
      color_visible = true;
      // draw positions
      blobGroup.displayFlatPositions();
    } else {
      color_visible = false;
    }
  }


  // Print text if new color expected
  textSize(20);
  stroke(255);
  fill(255);

  text("click the mouse to change the color ", 10, 25);

  if (color_visible == true) {
    println("Yeah found the color");
  }
}

//////////////////////
// Keyboard / Mouse
//////////////////////

void mousePressed() {

  color c = get(mouseX, mouseY);
  println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
  int hue = int(map(hue(c), 0, 255, 0, 180));
  ;
  blobGroup = new BlobGroup(this, c);
  println("color value: " + hue);
}

