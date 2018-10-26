class SaveImage {

  //variables here
  PImage partialSave;
  int savePath = 0;

  //Function that saves the current drawing, as a png to the Data-folder
  void toDataFolder() {

    //Temporarily saving the drawing, without the header and menu
    partialSave = get(0, 0, 720, 240);
    //Saving to file
    partialSave.save("Data/slitscan-" + savePath + ".png");
    savePath++;

  }
}
