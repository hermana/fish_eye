int NUM_SQUARES =30;

int MIN_SQUARE_SIZE=20;
int MAX_SQUARE_SIZE=100;
int GRID_SIZE=10;
ArrayList<Square> squares = new ArrayList<Square>();
ArrayList<GridLine> gridlines = new ArrayList<GridLine>();


void setup() {
  size(1080, 1080);
  generateSquares();
  generateGridLines();
}

void draw() {
  background(200);
  noStroke();
  
  float distortion = 0.5;
  
  for (int i = 0; i < NUM_SQUARES; i++) {
    //FIXME: where to define distortion level.
    squares.get(i).draw_square(distortion);
  }
  for (int i = 0; i < gridlines.size(); i++){
    gridlines.get(i).draw_gridline(distortion);
  }
}

void generateSquares() {
  int attempts = 0;
  while (squares.size() <  NUM_SQUARES && attempts < 1000) {
    int s = int(random(MIN_SQUARE_SIZE, MAX_SQUARE_SIZE));
    int x = int(random(width - s));
    int y = int(random(height - s));
    Square newSquare = new Square(x, y, x+s, y, x+s, y+s, x, y+s);
    
    boolean overlaps = false;
    for (int i = 0; i < squares.size(); i++) {
      Square existing = squares.get(i);
      if (rectsOverlap(newSquare.x1, newSquare.y1, s, existing.x1, existing.y1, existing.x2-existing.x1)) {
        overlaps = true;
        break;
      }
    }
    
    if (!overlaps) {
      squares.add(newSquare);
    }
    attempts++;
  }
  int target= int(random(0, NUM_SQUARES));
  squares.get(target).set_as_target();
}

boolean rectsOverlap(float x1, float y1, int s1, float x2, float y2, int s2) {
  return !(x1 + s1 < x2 || x1 > x2 + s2 || y1 + s1 < y2 || y1 > y2 + s2);
}

void generateGridLines(){
  // horizontal lines
  int x=0;
  while(x<height){
    x+=height/GRID_SIZE;
    gridlines.add(new GridLine(0, x, width, x));
  }
  //vertical lines
  int y=0;
  while(y<=width){
    y+= width/GRID_SIZE;
    gridlines.add(new GridLine(y, 0, y, height));
  }
}
