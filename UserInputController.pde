class UserInputController extends KaleidoController {
   
   public UserInputController(String folderPath) { 
       super(folderPath);
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