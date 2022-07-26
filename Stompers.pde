  public class Stompers extends AnimatedSprite{
  float boundaryTop, boundaryBottom;
  public Stompers(PImage img, float scale, float bTop, float bBottom){
    super(img, scale);
    moveTop = new PImage[1];
    moveTop[0] = loadImage("g3.png");
    
    moveBottom = new PImage[1];
    moveBottom[0] = loadImage("g3.png");
    
    currentImages = moveBottom;
    direction = BOTTOM_FACING;
    boundaryTop = bTop;
    boundaryBottom = bBottom;
    change_y = 1; 
  }
  void update(){
    // call update of Sprite(super)
    super.update();
    
    // if right side of spider >= right boundary
    //   fix by setting right side of spider to equal right boundary
    //   then change x-direction 
    // else if left side of spider <= left boundary
    //   fix by setting lfet side of spider to equal left boundary
    //   then change x-direction 
    if(getTop() >= boundaryTop){
      setTop(boundaryTop);
      change_y *= -1;
    } else if(getBottom() <= boundaryBottom){
      setBottom(boundaryBottom);
      change_y *= -1;
    }

  }
  
  public void selectDirection(){
    if(change_y > 0)
      direction = BOTTOM_FACING;
    else if(change_y < 0)
      direction = TOP_FACING;     
  }

  // if direction is RIGHT_FACING, LEFT_FACING or NEUTRAL_FACING
  // set currentImages to the appropriate PImage array. 
  public void selectCurrentImages(){
    if(direction == BOTTOM_FACING)
      currentImages = moveBottom;
    else if(direction == TOP_FACING)
      currentImages = moveTop;
    else
      currentImages = standNeutral;
  }
  
}
