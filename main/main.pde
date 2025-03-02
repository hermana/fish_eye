int NUM_SQUARES =30;

int MIN_SQUARE_SIZE=20;
int MAX_SQUARE_SIZE=100;
ArrayList<Square> squares = new ArrayList<Square>();


void setup() {
  size(1080, 1080);
  generateSquares();
}

void draw() {
  background(200);
  noStroke();
  
  for (int i = 0; i < NUM_SQUARES; i++) {
    //FIXME: where to define distortion level.
    squares.get(i).draw_square(0);
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
