//simple gambler class
class Gambler
{
  //number of tries 
  int tries;
  //succeeded
  boolean done;

  Gambler() {
    //number of tries starts at zero
    tries = 0;
    //not done when created
    done = false;
  }

  void update()
  {
    //if it's not done
    if (!done) {
      // gambling count goes up by 1
      tries++;
      // quit gambling if succeeded
      done = random(100) <= chance;
    }
  }
}
