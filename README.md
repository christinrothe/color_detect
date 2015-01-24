
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
