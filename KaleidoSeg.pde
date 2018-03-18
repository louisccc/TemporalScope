class KaleidoSeg {
    
    private PImage image;
    private PImage big_image;
    
    private int pos_x; 
    private int pos_y;
    private int pos_radius = 100;
    private int center_x; 
    private int center_y;
    
    private int selection = 0;
    private String lastModifiedDate = "";
    private String image_path = "";
    
    public KaleidoSeg(String image_path) {
        this.image_path = image_path;
        PImage original_size_img = loadImage(image_path);
        this.image = original_size_img;
        this.big_image = getCopy(original_size_img);
        this.image.resize(this.pos_radius, this.pos_radius);
        this.big_image.resize(this.pos_radius*2, this.pos_radius*2);
        this.selection = 0;
        
        File imgFile = new File(image_path);
        Date lastModifiedDate = new Date(imgFile.lastModified());
        this.lastModifiedDate = lastModifiedDate.toString();   
    }

    private PImage getCopy(PImage image) {
        PImage newImage = createImage(image.width, image.height, image.format);
        newImage.loadPixels();
        System.arraycopy(image.pixels, 0, newImage.pixels, 0, image.pixels.length);
        newImage.updatePixels();
        return newImage;
    }

    public void setPosition(int x, int y){
      this.pos_x = x;
      this.pos_y = y;
    }
    
    public int getCenterX(){
      return this.pos_x + this.pos_radius / 2;
    }
    
    public int getCenterY(){
      return this.pos_y + this.pos_radius / 2;
    }

    public String getLastModifiedDate(){
        return this.lastModifiedDate;
    }
    
    public void setRadius(int r){
      this.pos_radius = r;
    }
    public void setBig() {
      this.selection = 1;
    }
    public void setNormal() {
      this.selection = 0;
    }

    public synchronized void draw() {
        
        // draw the circle in suitable size
        PImage p;
        if(this.selection == 1) 
          p = this.big_image;
        else
          p = this.image;
        PGraphics pg = createGraphics(p.width, p.height, JAVA2D);
        pg.beginDraw(); 
        pg.background(0);
        pg.fill(255);
        pg.noStroke();
        pg.ellipse(p.width/2, p.height/2, p.width, p.height);
        pg.stroke(128);
        pg.strokeWeight(5);
        pg.endDraw();
        // draw the kaleidoscope with masking
        
        PImage maskedImage = p;
        maskedImage.mask(pg);
        image(maskedImage, this.pos_x, this.pos_y);
    }
}