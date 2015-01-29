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
import java.awt.*;
import processing.serial.*; // import the lib

Capture video;
OpenCV opencv;
PImage src;
Serial port;     // Create object from Serial class


//int rangeLow = 20;
//int rangeHigh = 35;
int Colour = 35;

// List of my blob groups
BlobGroup blobGroup;
boolean color_visible = false;
boolean face_visible = false;
void setup() {
  video = new Capture(this, 640/2, 480/2, "USB 2.0 Camera");
//  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  size(640, 480, P2D);
  String portname = Serial.list()[7]; // <-- this index may vary!
  port = new Serial(this, portname, 9600); // new serial port item

  video.start();
}

void draw() {

  background(150);

  if (video.available()) {
    video.read();
  }
//  scale(2);

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
//    image(blobGroup.output, width - src.width/4, 0, src.width/4, src.height/4);
    if (blobGroup.visible) {
      color_visible = true;
      // draw positions
      blobGroup.displayFlatPositions();
    } else {
      color_visible = false;
    }
  }

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();

  if (faces.length > 0) {
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    if (faces[0].y > 100) {
      face_visible = true;
    } else {
      face_visible = false;
    }
  }else{
      face_visible = false;
  }


  // Print text if new color expected
//  textSize(20);
//  stroke(255);
//  fill(255);

//  text("click the mouse to change the color ", 10, 25);

  if ((color_visible == true) || (face_visible == true)) {
//    println("love");
    port.write('1');
  } else {
//    println("no love");
    port.write('0');
  }
  
  println("Face visible: " + face_visible);
  println("Faces length: " + faces.length);
  println("Color visible: " + color_visible);
}

void captureEvent(Capture c) {
  c.read();
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
