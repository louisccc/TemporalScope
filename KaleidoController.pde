class KaleidoController {

    public float baserotate;
    public float overallrotate;
    public int currentRound;
    private float rotateKal = 0;
    
    private String[]     filenames; // the filename of images
    private String       folderPath;
    private KaleidoSeg[] kaleido_imgs;

    private int radius = 500; // radius of circle.
    private int current_nearest = 0; // current nearest photo to cursor.
    
    private boolean debug = false; // this is used to toggle debug logging.

    public KaleidoController(String folderPath) {
        
        
        File folder = new java.io.File(folderPath);
        this.filenames = folder.list();
        this.folderPath = folderPath;

        imageFileExtCheck();
        
        this.kaleido_imgs = new KaleidoSeg[this.filenames.length];   

        for (int i=0; i<this.filenames.length;i++) {  
            String imgFilePath = this.folderPath + this.filenames[i];
            this.kaleido_imgs[i] = new KaleidoSeg(imgFilePath);
            
            if (this.debug) {
                println("img path: " + imgFilePath);
                println("img modified time: " + this.kaleido_imgs[i].getLastModifiedDate());
                println("img index: " + i);
                println("===");
            }
          
        }

        if (this.debug)
            println("image count " + getImgCount());
    
    }
    
    private void imageFileExtCheck() throws InvalidParameterException{
        if (this.filenames == null || this.filenames.length == 0)
            throw new InvalidParameterException("No img files.");

        for (int i=0;i<this.filenames.length;i++) { 
            if (!filenames[i].endsWith(".jpg") && !filenames[i].endsWith(".png")){
                throw new InvalidParameterException("ONlY PNG and JPG can be used");
            }
        }
    }
    public String getCurSelectedImgModifiedTime(){
        return this.kaleido_imgs[this.current_nearest].getLastModifiedDate();
    }
    
    public int getImgCount() {
        return this.kaleido_imgs.length;
    } 

    public synchronized void draw() {
      
        background(0);
        
        // CENTER IMAGE
        
        PImage p2 = this.kaleido_imgs[this.current_nearest].getImage();
        PGraphics pg2 = createGraphics(p2.width, p2.height, JAVA2D);
        pg2.beginDraw(); 
        pg2.background(0);
        pg2.fill(255);
        pg2.noStroke();
        
        pg2.ellipse(p2.width/2, p2.height/2, this.radius, this.radius);
        
        pg2.endDraw();
        
        PImage maskedImage2 = p2;
        maskedImage2.mask(pg2);
        
        image(maskedImage2, width/2-p2.width/2, height/2-p2.height/2);
        
        // SIDE
      
        for(int i=0; i<this.kaleido_imgs.length;i++){
            if ( this.kaleido_imgs[i].isSelected() == 0 ) {
                int center_x = width / 2 - 100 / 2 + (int) (0.5*radius * sin(TWO_PI*i/this.kaleido_imgs.length));
                int center_y = height / 2 - 100 / 2 - (int) (0.5*radius * cos(TWO_PI*i/this.kaleido_imgs.length));
                this.kaleido_imgs[i].setPosition(center_x, center_y);
                this.kaleido_imgs[i].draw();
            }
        }


        int center_x = width / 2 - 200 / 2 + (int) (0.5*radius * sin(TWO_PI*this.current_nearest/this.kaleido_imgs.length));
        int center_y = height / 2 - 200 / 2 - (int) (0.5*radius * cos(TWO_PI*this.current_nearest/this.kaleido_imgs.length));
                
        this.kaleido_imgs[this.current_nearest].setPosition(center_x, center_y);
        this.kaleido_imgs[this.current_nearest].draw();
    }

    public synchronized void moveImageSelection(int positionX, int positionY) {
      
        /* The nearest picture should be scaled the biggest, 
           and the neighbors should be bigger than usual. */
      
        int min_dist = 0;
        int min_dist_idx = -1; 
      
        for(int i=0; i<this.kaleido_imgs.length;i++){
            KaleidoSeg seg = this.kaleido_imgs[i]; 
            int temp_dist = int(pow( (seg.getCenterX() - positionX), 2) + pow((seg.getCenterY() - positionY), 2));
        
            if (min_dist_idx == -1 || temp_dist < min_dist){
                min_dist = temp_dist;
                min_dist_idx = i;
            }
        }
      
        if (min_dist_idx != current_nearest){
            this.kaleido_imgs[min_dist_idx].setBig();
            this.kaleido_imgs[current_nearest].setNormal();
            this.current_nearest = min_dist_idx;
            println(positionX + " " + positionY + " select:" + this.current_nearest);
            println(this.kaleido_imgs[this.current_nearest].getCenterX() + " " + this.kaleido_imgs[this.current_nearest].getCenterY());
        }
    }

}