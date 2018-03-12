class KaleidoController {

    public float baserotate;
    public float overallrotate;
    public int currentRound;
    private float rotateKal = 0;

    private PImage img, imgH;
    private PGraphics graph, graphH;
    
    private PImage[]     imgs; // images
    private String[]     filenames; // the filename of images
    private String       folderPath;
    private String[]     fileLastModifieds;
    private KaleidoSeg[] kaleido_imgs;

    private int radius = 500; // radius of circle
    private int current_nearest = 0;
    
    private boolean debug = false; // this is used to toggle debug logging.

    public KaleidoController(String folderPath) {
        
        
        File folder = new java.io.File(folderPath);
        this.filenames = folder.list();
        this.folderPath = folderPath;

        imageFileExtCheck();
        
        //====================================
        // load the images from 'img' folder
        //====================================
        this.imgs = new PImage[this.filenames.length];
        this.fileLastModifieds = new String [this.filenames.length];
        this.kaleido_imgs = new KaleidoSeg[this.filenames.length];   

        for (int i=0; i<this.filenames.length;i++) {  
            String imgFilePath = this.folderPath + this.filenames[i];
            
            this.imgs[i] = loadImage(imgFilePath);
            this.kaleido_imgs[i] = new KaleidoSeg(this.imgs[i]);
            
            File imgFile = new File(folderPath + filenames[i]);
            Date lastModifiedDate = new Date(imgFile.lastModified());
            this.fileLastModifieds[i] = lastModifiedDate.toString();
            
            if (this.debug) {
                println("img path: " + imgFilePath);
                println("img modified time: " + this.fileLastModifieds[i]);
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
        return this.fileLastModifieds[this.current_nearest];
    }
    
    public int getImgCount() {
        return this.imgs.length;
    } 

    public synchronized void draw() {
      
        pushMatrix();
        background(0);
        popMatrix();    
        
        pushMatrix();
        stroke(255);
        strokeWeight(5);
        noFill();
        ellipse(width/2, height/2, this.radius, this.radius);
        popMatrix();
      
        for(int i=0; i<this.kaleido_imgs.length;i++){
            int center_x = width / 2 - 100 / 2 + (int) (0.5*radius * sin(TWO_PI*i/this.kaleido_imgs.length));
            int center_y = height / 2 - 100 / 2 - (int) (0.5*radius * cos(TWO_PI*i/this.kaleido_imgs.length));
            this.kaleido_imgs[i].setPosition(center_x, center_y);
            this.kaleido_imgs[i].draw();
        }

    }

    public synchronized void moveImageSelection(int positionX, int positionY) {
      
        /* The nearest picture should be scaled the biggest, 
           and the neighbors should be bigger than usual. */
      
        int max_dist = 0;
        int max_dist_idx = 0; 
      
        for(int i=0; i<this.kaleido_imgs.length;i++){
            KaleidoSeg seg = this.kaleido_imgs[i]; 
            int temp_dist = int(pow( (seg.getCenterX() - positionX), 2) + pow((seg.getCenterY() - positionY), 2));
        
            if (temp_dist > max_dist){
                max_dist = temp_dist;
                max_dist_idx = i;
            }
        }
      
        if (max_dist_idx != current_nearest){
            this.kaleido_imgs[max_dist_idx].setBig();
            this.kaleido_imgs[current_nearest].setNormal();
            this.current_nearest = max_dist_idx;
            println(positionX + " " + positionY + " select:" + this.current_nearest);
        }
    }

}