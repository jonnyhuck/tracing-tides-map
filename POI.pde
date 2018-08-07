/**
 * Class to make 
 */
class POI {

  // publicly accessible properties
  public float x;
  public float y;
  public String name;
  
  /**
   * Constructor
   */
  public POI(float inx, float iny, String inname) {
    x = inx;
    y = iny;
    name = inname;
  }
  
  /**
   * Get the location as a PVector
   */
  public PVector getVector(){
    return new PVector(x, y);
  }
}
