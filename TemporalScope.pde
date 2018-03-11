import java.io.File;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public static final int radius = 360;
public static final int margin = 50;

boolean showDate = true;
private int init_segNum = 12;
public int current_segNum;

public PImage [] imgs;
public int index_img, count_img;

String [] imgFileLastModifieds;
PFont font;

private UserInputController controller;
private boolean debug = true;
void setup() {
    // noLoop();
    size(1230,820);
    frameRate(30);
    
    //====================================
    // load the images from 'img' folder
    //====================================
    
    String folderPath = dataPath("img") + '/';
    File folder = new java.io.File(folderPath);
    String[] filenames = folder.list();
    
    println(filenames.length);
    count_img = 0;
    for (int i=0; i<filenames.length;i++) {
      if (filenames[i].endsWith(".jpg") || filenames[i].endsWith(".png")){
        count_img++;
      }
    }
    imgs = new PImage[count_img];
    imgFileLastModifieds = new String [count_img];
    
    count_img = 0;
    for (int i=0; i<filenames.length;i++) {  
      if (filenames[i].endsWith(".jpg") || filenames[i].endsWith(".png")){
        imgs[count_img] = loadImage(folderPath + filenames[i]);
        
        File imgFile = new File(folderPath + filenames[i]);
        Date lastModifiedDate = new Date(imgFile.lastModified());
        imgFileLastModifieds[count_img] = lastModifiedDate.toString();
        
        if (debug) {
          println("img path: " + folderPath + filenames[i]);
          println("img modified time: " + imgFileLastModifieds[count_img]);
          println("img index: " + count_img);
          println("===");
        }
        count_img++;
      }
    }
    
    //====================================
    // to show date or not
    //====================================
    if(showDate)
        font = createFont("Futura.ttc",72);
    
    //====================================        
    // create controller
    //====================================
    controller = new UserInputController(radius, 100, imgs);
    println("image count " + count_img);
    //controller.changeImage(imgs[0], "applet-can-not-save", true);
    index_img = 0;
    // loop();
}

// use the draw() in KaleidoController
void draw() {
    
    controller.draw();
    
    if (showDate) {
        pushMatrix();
        textFont(font, 18);
        textAlign(CENTER);
        fill(0xFFFFFFFF);
        if (imgFileLastModifieds[index_img] == null)
          text("Oops! Unknown Date", width/2, height*0.9);
        else
          text(imgFileLastModifieds[index_img], width/2, height*0.9);
        popMatrix();
    }
}

// leave the mouse/keyboard work to UserInputController
void mouseMoved() {
  controller.mouseMoved();
}

void keyReleased() {
  controller.keyReleased();
}