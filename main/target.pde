class Square{

  int w;
  int h;
  int x;
  int y;
  boolean target;
  
  Square(int X, int Y, int W, int H){
    this.x = X;
    this.y = Y;
    this.w = W;
    this.h = H;
    this.target = false;
  }
  
  void draw_square(){
     color colour = this.target ? color(255, 255, 0) : color(0, 255, 0);
     fill(colour);
     rect(this.x, this.y, this.w, this.h);
  }

  void set_as_target(){
    this.target = true;
  }
}
