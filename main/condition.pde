class Condition{

  int numTrials;
  float distortion;
  int currentTrial;
  int totalTime;
  boolean useSDDR;
  String name;
  ArrayList<Trial> trials;
  
  Condition(String condition_name, int num_trials, float distortion_level, boolean use_sddr ){
    this.name = condition_name;
    this.numTrials = num_trials;
    this.distortion = distortion_level;
    this.useSDDR = use_sddr;
    this.currentTrial = 0;
    this.totalTime = 0; //FIXME: do I actually use this?
    
    this.trials = new ArrayList<Trial>(numTrials);
      for(int i=0; i<this.numTrials; i++){ this.trials.add(new Trial()); }
  }
  
  void start_trial_timer(){
      trials.get(currentTrial).startTime = millis();
  }
    
  void end_trial_timer(){
      trials.get(currentTrial).set_elapsed_time();
  }
    
  void get_trial_elapsed_time(){
      trials.get(currentTrial).set_elapsed_time();
  }
    
  void finish_trial(float ID){
      trials.get(currentTrial).set_ID(ID);
  }
  
  void update_current_trial(){
      currentTrial+=1;
  }
  
  void print_results(Table results){
      // ConditionName, TrialNumber, FittsID, CompletionTime, Errors
      String fitts =  nf(trials.get(currentTrial).get_ID(), 0, 2);
      String time = str(trials.get(currentTrial).get_elapsed_time());
      TableRow newRow = results.addRow();
      newRow.setString("Condition Name", this.name);
      newRow.setString("Trial", str(currentTrial));
      newRow.setString("ID", fitts);
      newRow.setString("Time (ms)", time);
      newRow.setString("Distortion", str(this.distortion));
      newRow.setString("Use SDDR", str(this.useSDDR));

    }
}
