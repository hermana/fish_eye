/////////////////////////SHARED FUNCTIONS /////////////////////////////

int fish_eye_transform(int p, int f, float distortion){
    float r=0;
    float maxDiff=0;
    
    if(p<f){
      maxDiff = float(f);
    }else{
      maxDiff = float(width - f);
    }
   
    float d = abs(float(p) - float(f));
    float g=0;
    if(d > 0){
     g = (distortion +1)/(distortion + maxDiff / d); //CHECK ORDER OF OPERATIONS HERE?
    }
    
    if(p == f){
      r = p;
    }else if(p > f){
      r = f + g * maxDiff; 
    }else{
      r = f - g * maxDiff;
    }

    return int(r);
}

/////////////////////////SQUARE CLASS /////////////////////////////

class Square{
  int x1;
  int y1;
  int x2;
  int y2;
  int x3;
  int y3;
  int x4;
  int y4;
  boolean target;
  
  Square(int X1, int Y1, int X2, int Y2, int X3, int Y3, int X4, int Y4){
    this.x1 = X1;
    this.y1 = Y1;
    this.x2 = X2;
    this.y2 = Y2;
    this.x3 = X3;
    this.y3 = Y3;
    this.x4 = X4;
    this.y4 = Y4;
    this.target = false;
  }
  
  void draw_square(float distortion){
     color colour = this.target ? color(0, 255, 0) : color(255, 255, 0);
     fill(colour);
     
     int fish_x1 = fish_eye_transform(this.x1, mouseX, distortion);
     int fish_y1 = fish_eye_transform(this.y1, mouseY, distortion);
     int fish_x2 = fish_eye_transform(this.x2, mouseX, distortion);
     int fish_y2 = fish_eye_transform(this.y2, mouseY, distortion);
     int fish_x3 = fish_eye_transform(this.x3, mouseX, distortion);
     int fish_y3 = fish_eye_transform(this.y3, mouseY, distortion);
     int fish_x4 = fish_eye_transform(this.x4, mouseX, distortion);
     int fish_y4 = fish_eye_transform(this.y4, mouseY, distortion);

     quad(fish_x1, fish_y1, fish_x2, fish_y2, fish_x3, fish_y3, fish_x4, fish_y4);

  }

  void set_as_target(){
    this.target = true;
  }
}

/////////////////////////GRIDLINE CLASS /////////////////////////////

class GridLine {

  int x1;
  int y1;
  int x2;
  int y2;
  
  GridLine(int X1, int Y1, int X2, int Y2){
    this.x1 = X1;
    this.y1 = Y1;
    this.x2 = X2;
    this.y2 = Y2;
  }

  void draw_gridline(float distortion){
    stroke(0);
    int X1 = fish_eye_transform(this.x1, mouseX, distortion);
    int Y1 = fish_eye_transform(this.y1, mouseY, distortion);
    int X2 = fish_eye_transform(this.x2, mouseX, distortion);
    int Y2 = fish_eye_transform(this.y2, mouseY, distortion);
    line(X1, Y1, X2, Y2);
  }
}
