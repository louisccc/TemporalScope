class UserInputController extends KaleidoController {
   
  private PVector lastVector = new PVector(0,0);
  
   public UserInputController(int screenradius, int scalefactor, PImage[] imgs) { 
       super(screenradius, scalefactor, imgs);
   }
   
   public void keyReleased() {
     
       switch(keyCode) {
           case UP:
             // change mode
             break;
           case DOWN:
             // change mode
             break;
           default:
             break;
        }
   }
    
   public void mouseMoved() {
      moveImageSelection(mouseX, mouseY);
    }
}


