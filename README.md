# color_detect


//import java.util.*;
//import gab.opencv.*;
//import processing.video.*;
//import java.awt.Rectangle;

//import netP5.*;

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

        if(blobGroup != null) {
            blobGroup.detectBlobs(src);
            // draw reference image and rectangle
            noStroke();
            fill(blobGroup.colr);
            rect(src.width, 0, 30, src.height/4);
            image(blobGroup.output, width - src.width/4, 0, src.width/4, src.height/4);
            if(blobGroup.visible) {
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

if(color_visible == true){
    println("Yeah found the color");
    }
}

//////////////////////
// Keyboard / Mouse
//////////////////////

void mousePressed() {

        color c = get(mouseX, mouseY);
        println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
        int hue = int(map(hue(c), 0, 255, 0, 180));;
        blobGroup = new BlobGroup(this, c);
        println("color value: " + hue);
}




# opencv

import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*; // import the lib


//int rangeLow = 20;
//int rangeHigh = 35;
int Colour = 35;

Serial port;     // Create object from Serial class
Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2, "USB 2.0 Camera", 30);
  //  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  String portname = Serial.list()[7]; // <-- this index may vary!
  port = new Serial(this, portname, 9600); // new serial port item

  video.start();
}


//void mousePressed() {
// 
//  color c = get(mouseX, mouseY);
//  println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
//   
//  int hue = int(map(hue(c), 0, 255, 0, 180));
//  println("hue to detect: " + hue);
//  
//  rangeLow = hue - 5;
//  rangeHigh = hue + 5;
//}

void draw() {

  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);

    //if(faces[i].y > 100 || Colour > 33){ 
    if (faces[i].y > 100) {
      println("love");
      port.write('1');
    } else {
      println("nolove"); 
     port.write('0');
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}
