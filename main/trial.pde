class Trial {

  int startTime;
  int endTime;
  int elapsedTime;
  float ID;
  int unsuccessful_attempts;
   
   void set_elapsed_time(){
     elapsedTime = millis() - startTime;
   }
   
   int get_elapsed_time(){
     return elapsedTime;
   }
   
   void set_ID(float ID){
      this.ID = ID;
   }
   
   float get_ID(){
     return this.ID;
   }

   Trial(){ 
     startTime = 0;
     endTime = 0;
     elapsedTime = 0;
     ID = 0.0;
   }
}
