/* 
Created by
Elisabeth Ancher Elboth
26/10/2018

Tool for creating slitscan-images, with the option of saving the images and changing the scanlinewidth,
and create a simple sonification of the image
*/

//Importing video library to access Capture
import processing.video.*;
//Import GUI library
import controlP5.*;
//Import minim and sound libraries
import ddf.minim.*;
import ddf.minim.ugens.*;

//Global variables
SaveImage img;
GUI gui;
GUI text;
Capture video;
//ControlP5 gui;
boolean runningSlitscan = true;
boolean runningSonification = false;
PImage slitscan;

//Declaring the variable for the slitscan width and height
int scanWidth = 720;
int scanHeight = 240;

//Variables used working with sound
Minim minim;
AudioOutput out;
AudioRecorder recorder;
Oscil wave;
Frequency currentFreq;
int currentX, currentY;
int movingRectW = scanWidth/10;
int movingRectH = scanHeight/4;
int soundSave = 0;

//Global variables used for moving the slitscan along the x-axis
int x = 0;
int y = 0;
int scanlineWidth;

void setup() {
  size(1280, 280);
  background(255);
  frameRate(8);

  //Instantiating the SaveImage class and GUI class
  img = new SaveImage();
  gui = new GUI(this);
  text = new GUI();
  //Setup capture
  video = new Capture(this, 320, 240);
  video.start();

  //Setup sound
  minim = new Minim(this);
  out = minim.getLineOut();
  //Create a recorder that will record from the output to the filename specified
  recorder = minim.createRecorder(out, "Data/sonification-" + soundSave + ".wav");
  //Constructs frequency from pitch A4 (440 Hz, general tuning standard)
  currentFreq = Frequency.ofPitch("A4");
  //Oscil generates audio by oscillating over a Waveform at a particular frequency and amplitude (0.6f used)
  wave = new Oscil(currentFreq, 0.6f, Waves.TRIANGLE);
}

//This event function is run when a new camera frame is available, and the read() method to capture this frame
void captureEvent(Capture video) {
  video.read();
}

void draw() {
  //println("sonification is " +runningSonification);
  //println("slitscan is " + runningSlitscan);

  //This draws the video/capture-image at pos (721,0) in the canvas
  image(video, 721, 0);

  int w = video.width;
  int h = video.height;

  //The running of the actual slitscan is within an if-statement, so the user can freeze it when desired
  if (runningSlitscan) {
    //Here I'm copying a slit from the middle of the screen capture, with full height and the width based on the variable scanlineWidth
    //Using Processing copy function, which takes 9 arguments, to draw the actual slitscan image
    //(Src - the thing i wanna copy from, the next four arguments are the rectangle I wanna copy from, and the last four arguments are the rectangle in the destination)
    copy(video, w/2, 0, scanlineWidth, h, x, y, scanlineWidth, h);
    x = x + scanlineWidth;
    //If the scan gets to the far right of the scan, it starts over again
    if (x > scanWidth-scanlineWidth) {
      x= 0;
    }
  }

  //If the user presses the "Sonify"-button, runningSonification=true, and the if-statement below starts to run
  if (runningSonification) {
    //Stops the running of the slitscan
    runningSlitscan = false;
    //Sends the actual output sound to AudioOutput, making the user able to hear it
    wave.patch(out);
    //Starts recording the sounds
    recorder.beginRecord();
    //Sets the setting for the moving rectangle that shows where in the slitscan the sound comes from
    noFill();
    stroke(255);

    //Temporarily saving the slitscan image in the PImage variable slitscan
    slitscan = get(0, 0, scanWidth, scanHeight);
    //slitscan.save("Data/tempBackgroundImg.png");
    //set(0, 0, slitscan);
    //Rectangle that moves with the currentX and currentY, showing which part of the image is the sound source
    rect(currentX, currentY, movingRectW, movingRectH);

    float sum = 0;
    //Loads a snapshot of the current display window into the pixels[] array
    slitscan.loadPixels();
    //For-loops, looping the slitscan image rectangle by rectangle
    for (int x = currentX; x < currentX + movingRectW; x++) {
      for (int y = currentY; y < currentY + movingRectH; y++) {
        int index = x + slitscan.width*y;
        //Sum is sum plus the brightness value from the color at the certain index
        sum += brightness(slitscan.pixels[index]);
      }
    }

    sum /= sq(movingRectW);
    //Setting the frequency based off of the sum of each rectangle
    currentFreq = Frequency.ofHertz(sum);
    wave.setFrequency(currentFreq);
    //Moving onto the nect rectangle to the right
    currentX += movingRectW;
    //If the sonification has reached the right, it moves onto the row below
    if (currentX > slitscan.width - movingRectW) {
      currentX = 0;
      currentY += movingRectH;
    } //If the sonification has reached the bottom of the pic, it stops running and recording, and saves the sound-file
    if (currentY >= slitscan.height) {
      currentY = 0;
      runningSonification = false;
      recorder.endRecord();
      recorder.save();
      wave.unpatch(out);
      currentFreq = Frequency.ofPitch("A4");
    }
  }
}

//A controlEvent is sent to a PApplet or a ControlListener whenever a controller value has changed
//In other words - used to monitor the buttons in the GUI
public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
}

//Freeze-button changes the status of runningSlitscan to false
public void freeze(int theValue) {
  println("a button event from freeze: "+theValue);
  runningSlitscan = false;
}
//Start-button changes the status of runningSlitscan to true
public void startagain(int theValue) {
  println("a button event from start: "+ theValue);
  runningSlitscan = true;
}
//saveImage-button runs the toDataFolder()-function from the SaveImage class
public void saveImage(int theValue) {
  println("a button event from saveImage: "+ theValue);
  img.toDataFolder();
}
//sonify-button changes the status of runningSonification to true
public void sonify(int theValue) {
  println("a button event from sonify: "+ theValue);
  //sonify();
  runningSonification = true;
}


/*

 void keyPressed(){
 if(key == 'p'){
 runningSlitscan = false;
 } else if(key == 'o'){
 runningSlitscan = true;
 } else if(key == 's'){
 saveSlitscan();
 }
 }
 */
