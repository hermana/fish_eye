int NUM_SQUARES =30;

int MIN_SQUARE_SIZE=20;
int MAX_SQUARE_SIZE=100;
int GRID_SIZE=10;
ArrayList<Square> squares = new ArrayList<Square>();
ArrayList<GridLine> gridlines = new ArrayList<GridLine>();
ArrayList<Condition> conditions = new ArrayList<Condition>();
Condition currentCondition;
int conditionIndex;
Table results;

String RESULTS_FILENAME = "./results.csv";

enum State{
  INSTRUCTIONS, 
  TRIAL, 
  FINISHED
}

State state;

void setup() {
  PFont myFont = createFont("Arial", 32, true); 
  textFont(myFont);
  textAlign(CENTER);

  state = State.INSTRUCTIONS;
  //String condition_name, int num_trials, float distortion_level, boolean use_sddr 
  conditions.add(new Condition("Minimal distortion", 5, 0.5, false));
  
  conditionIndex=0;
  currentCondition = conditions.get(conditionIndex);
  
  size(1080, 1080);
  generateSquares();
  generateGridLines();
  
  results = new Table();
  results.addColumn("Condition Name");
  results.addColumn("Trial");
  results.addColumn("ID");
  results.addColumn("Time (ms)");
  results.addColumn("Errors");
  results.addColumn("Strength");
  results.addColumn("Condition Type");
}

void draw() {
  background(200);
  noStroke();
  background(200);
  switch(state){
   case INSTRUCTIONS:
     fill(0);
     text(currentCondition.name, width/2, height/2);
     text("Click to continue.", width/2, (height/2)+250);
     break;
   case TRIAL:
      float distortion = currentCondition.distortion;
      for (int i = 0; i < NUM_SQUARES; i++) {
        //FIXME: where to define distortion level.
        squares.get(i).draw_square(distortion);
      }
      for (int i = 0; i < gridlines.size(); i++){
        gridlines.get(i).draw_gridline(distortion);
      }
     break;
   case FINISHED:
      fill(0);
      text("The experiment has finished.", width/2, height/2);
      text("Click to exit.", width/2, (height/2)+50);
   default:
     break;
  }
}

void mouseClicked() {
  switch(state){
    case INSTRUCTIONS:
      state = State.TRIAL;
      break;
    case TRIAL: 
        if(isTargetClicked()){
            currentCondition.end_trial_timer();
            float ID = get_fitts();
            currentCondition.finish_trial(ID);
            currentCondition.print_results(results);
            resetTarget();        
            if(currentCondition.currentTrial >= currentCondition.numTrials){
              conditionIndex+=1;
              if(conditionIndex < conditions.size()){
                 currentCondition = conditions.get(conditionIndex);
                 state = State.INSTRUCTIONS;
                 generateSquares();
              }else{
                state = State.FINISHED;
              }              
            }else{
               currentCondition.update_current_trial();
               currentCondition.start_trial_timer();
            }
       }
      break;
    case FINISHED:
      saveTable(results, RESULTS_FILENAME, "csv");  
      exit();
      break;
    default:
      break;
  }
}


boolean isTargetClicked(){
  for (Square s: squares){
    if (s.is_clicked(mouseX, mouseY) && s.is_target()){
      return true;
    }
  }
  return false;
}

void resetTarget(){
  int target = int(random(0, NUM_SQUARES));
  int s = 0;
  while(s<NUM_SQUARES){
    if(squares.get(s).is_target()){ 
      squares.get(s).set_as_not_target();
     }
    if(s == target){ squares.get(s).set_as_target(); }
    s++;
  }
}


float get_fitts(){
  for (Square s: squares){
    if (s.is_target()){
      return s.get_ID(mouseX, mouseY);
    }
  }
  return 0.0;
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
