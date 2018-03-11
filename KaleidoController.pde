class KaleidoController {

    private int scalefactor;
    private int screenradius;

    public float baserotate;
    public float overallrotate;
    public int currentRound;
    private float rotateKal = 0;

    private PImage img, imgH;
    private PGraphics graph, graphH;
    private KaleidoSeg kaleidoscope;
    
    private PImage[] imgs;
    private KaleidoSeg[] kaleido_imgs;
    private int radius = 500;
    private int current_nearest = 0;
    
    public KaleidoController(int screenradius, int scalefactor, PImage[] imgs) {
        this.screenradius = screenradius;
        this.scalefactor = scalefactor;
        this.imgs = imgs;
        
        kaleido_imgs = new KaleidoSeg[this.imgs.length];   
        for (int i=0; i<this.imgs.length;i++){
          this.kaleido_imgs[i] = new KaleidoSeg(this.imgs[i], screenradius);
        }
//        for (int i=0; i<this.imgs.length;i++){
//          this.kaleido_imgs[this.imgs.length+i] = new KaleidoSeg(this.imgs[i], screenradius);
//        }              
    }

    /*public synchronized PGraphics getBuffer() {
      return kaleidoscope.getBuffer();
    }*/
    public KaleidoSeg getKaleidoscope() {
      return kaleidoscope;
    }


    public synchronized void draw() {
      // draw every image
      
      pushMatrix();
//      translate(margin,margin);
      background(0);
      
      popMatrix();    
      pushMatrix();
      stroke(255);
      strokeWeight(5);
      noFill();
      ellipse(width/2, height/2, radius, radius);
      popMatrix();
      
      for(int i=0; i<this.kaleido_imgs.length;i++){
        int center_x = width / 2 - 100 / 2 + (int) (0.5*radius * sin(TWO_PI*i/this.kaleido_imgs.length));
        int center_y = height / 2 - 100 / 2 - (int) (0.5*radius * cos(TWO_PI*i/this.kaleido_imgs.length));
        this.kaleido_imgs[i].setPosition(center_x, center_y);
        this.kaleido_imgs[i].draw();
      }
      
      
        
    }

    public synchronized void setSegmentNumber(int segments) {
      
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
        index_img = current_nearest;
        current_nearest = max_dist_idx;
        println(positionX + " " + positionY + " select:" + current_nearest  );
      }
    }
}