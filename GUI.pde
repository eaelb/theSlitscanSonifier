class GUI {
  ControlP5 gui;
  PFont font = createFont("PierSans-Regular.otf", 20);
  ControlFont Cfont = new ControlFont(font); 
  
  //Constructor, setting up all non-interactive GUI
  public GUI(){
  textFont(font, 12);
  fill(color(202, 250, 254));
  stroke(color(202, 250, 254));
  rect(0, 241, width, 39);
  stroke(color(0));
  fill(color(0));
  text("© Elisabeth Ancher Elboth for the course Computational Prototyping, RMIT 2018", 10, 265);
  fill(color(150, 150, 150));
  text("Scanline width", 1122, 57);
  fill(color(0));
  text("MENU", 1143, 42);
  textFont(font, 18);
  text("THE SLITSCAN SONIFIER", 1052, 25);
  }
  
  GUI(PApplet thePApplet) {
    gui = new ControlP5(thePApplet);

    //Adding all buttons and sliders to the far right of the user interface
    gui.addSlider("scanlineWidth").setPosition(1042, 59).setRange(1, 100).setValue(3).setSize(238, (scanHeight/6-20)).scrolled(200)
      .setColorBackground(color(85, 188, 201)).setColorActive(color(63, 238, 230)).setColorForeground(color(202, 250, 254))
      .getCaptionLabel().setFont(Cfont).setSize(12).toUpperCase(false);
    gui.addButton("freeze").setValue(0).setPosition(1042, (scanHeight*2/6)).setSize(238, (scanHeight/6))
      .setColorBackground(color(85, 188, 201)).setColorForeground(color(63, 238, 230))
      .getCaptionLabel().setFont(Cfont).setSize(12).toUpperCase(false).setText("Freeze Slitscan");
    gui.addButton("startagain").setValue(0).setPosition(1042, (scanHeight*3/6)).setSize(238, (scanHeight/6))
      .setColorBackground(color(85, 188, 201)).setColorForeground(color(63, 238, 230))
      .getCaptionLabel().setFont(Cfont).setSize(12).toUpperCase(false).setText("Start Slitscanning Again");
    gui.addButton("saveImage").setValue(0).setPosition(1042, (scanHeight*4/6)).setSize(238, (scanHeight/6))
      .setColorBackground(color(85, 188, 201)).setColorForeground(color(63, 238, 230))
      .getCaptionLabel().setFont(Cfont).setSize(12).toUpperCase(false).setText("Save Slitscan");
    gui.addButton("sonify").setPosition(1042, (scanHeight*5/6)).setSize(238, (scanHeight/6))
      .setColorBackground(color(85, 188, 201)).setColorForeground(color(63, 238, 230))
      .getCaptionLabel().setFont(Cfont).setSize(12).toUpperCase(false).setText("Sonify");
  }
}
