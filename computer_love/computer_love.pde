/**
 * computer_love by
 * @christinrothe
 * @fabiantheblind
 * @updated: 29/01/2015
 *
 * for Input Output (Eingabe Ausgabe)
 * Fundamentals of process-oriented design
 * https://incom.org/workspace/5478
 *
 * based on Homo-Effectus https://github.com/FH-Potsdam/Homo-Effectus
 * by
 * @Flave
 * @kernfruit
 * @killinglyfunny
 *
 * https://incom.org/projekt/5197
 * University of Applied Sciences Potsdam (Germany)
 * Project: DIY (Multi) Touch (less) Human Computer Interaction
 *
 * Facetracking ----------------
 * Just put your face into the frame
 *
 * ColorTracking ---------------
 * Select a colors to track
 *
 * Options ---------------------
 * press 'o' or 'O' to disable enable src drawing
 *
 *
 * It uses the OpenCV for Processing library by Greg Borenstein
 * https://github.com/atduskgreg/opencv-processing
 *
 * based on examples by
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
OpenCV opencv_color;
OpenCV opencv_face;
PImage src;
Serial port;     // Create object from Serial class


//int rangeLow = 20;
//int rangeHigh = 35;
int Colour = 35;

// List of my blob groups
BlobGroup blobGroup;

boolean color_visible = false;
boolean face_visible = false;
boolean show_src = true; // key command

void setup() {
 // video = new Capture(this, 640/2, 480/2, "USB 2.0 Camera");
  video = new Capture(this, 640/2, 480/2);
  opencv_color = new OpenCV(this, 640/2, 480/2);
  opencv_face = new OpenCV(this, 640/2, 480/2);
  opencv_face.loadCascade(OpenCV.CASCADE_FRONTALFACE);

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
 scale(2);

  // <2> Load the new frame of our movie in to OpenCV
  opencv_face.loadImage(video);
  opencv_color.loadImage(video);

  // Tell OpenCV to use color information
  // this is just for displaying the source image
  // get a snapshot to show the source
  // can be disabled in the final app
  if(show_src==true){
  opencv_face.useColor();
  src = opencv_face.getSnapshot();
    image(src, 0, 0);
  }

  if (blobGroup != null) {
    blobGroup.detectBlobs(src);
    // draw reference image and rectangle
    noStroke();
    fill(blobGroup.colr);
    rect(src.width, 0, 30, src.height/4);
    if(show_src){
      image(blobGroup.output, width - src.width/4, 0, src.width/4, src.height/4);
    }
    if (blobGroup.visible) {
      color_visible = true;
      // draw positions
      if (show_src){
          blobGroup.displayFlatPositions();
        }
    } else {
      color_visible = false;
    }
  }

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv_face.detect();

  if (faces.length > 0) {
    if (show_src == true){
      rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    }
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
    println("love");
//    port.write('1');
  } else {
    println("no love");
//    port.write('0');
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
  blobGroup = new BlobGroup(this, c, opencv_color);
  println("color value: " + hue);
}

void keyPressed(){
  if(key == 'o' || key == 'O'){
    show_src = !show_src;
  }
}
