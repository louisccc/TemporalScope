class KaleidoSeg {
    
    private PImage image;
    private PImage big_image;
    
    private PImage center_image;
    private int radius = 500; // radius of circle.
    
    private int pos_x; 
    private int pos_y;
    private int pos_radius = 70;
    private int pos_radius_big_c = 2;
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
        this.center_image = getCopy(original_size_img);
        
        if (this.image.height>this.image.width) {
          int ratio = this.pos_radius/this.image.width;
          this.image.resize(this.pos_radius, this.image.height*ratio);
          this.big_image.resize(this.pos_radius*pos_radius_big_c, this.image.height*pos_radius_big_c*ratio);
          this.center_image.resize(this.radius, this.radius/this.image.width*this.image.height);
        } else {
          int ratio = this.pos_radius/this.image.height;
          this.image.resize(this.image.width*ratio, this.pos_radius);
          this.big_image.resize(this.image.width*ratio*pos_radius_big_c, this.pos_radius*pos_radius_big_c);
          this.center_image.resize(this.radius/this.image.height*this.image.width, this.radius);
        }
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
        if (this.selection == 0)
            return this.pos_x + this.pos_radius / 2;
        else 
            return this.pos_x + this.pos_radius;
    }
    
    public int getCenterY(){
        if (this.selection == 0) 
            return this.pos_y + this.pos_radius / 2;
        else
            return this.pos_y + this.pos_radius;
    }

    public String getLastModifiedDate(){
        return this.lastModifiedDate;
    }
    
    public PImage getImage(){
        return this.center_image;
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
    public int isSelected() {
        return this.selection;
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
        
        if (this.selection == 1)
          pg.ellipse(this.pos_radius, this.pos_radius, this.pos_radius*2, this.pos_radius*2);
        else
          pg.ellipse(this.pos_radius/2, this.pos_radius/2, this.pos_radius, this.pos_radius);
        pg.stroke(128);
        pg.strokeWeight(5);
        pg.endDraw();
        // draw the kaleidoscope with masking
        
        PImage maskedImage = p;
        maskedImage.mask(pg);
        
        image(maskedImage, this.pos_x, this.pos_y);
    }
}