import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.security.*;

boolean showDate = true;
PFont font;

UserInputController controller;

void setup(){
    
    size(1230,820);
    frameRate(30);
      
    controller = new UserInputController(dataPath("img") + '/');
    
    if(showDate) {
        font = createFont("Futura.ttc",72);
    }
}

void draw() {
    
    controller.draw();
    
    if (showDate) {
        pushMatrix();
        textFont(font, 18);
        textAlign(CENTER);
        fill(0xFFFFFFFF);
        text(controller.getCurSelectedImgModifiedTime(), width/2, height*0.9);
        popMatrix();
    }
}

void mouseMoved() {controller.mouseMoved();}
void keyReleased(){controller.keyReleased();}