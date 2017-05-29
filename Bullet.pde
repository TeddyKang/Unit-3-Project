class Bullet{
  Vector2D location;
  Vector2D dir;
  
  float xpos;
  float ypos;
  float speed;
  float angle;
  int bulletnum;
  
  Bullet(float Xpos, float Ypos, Vector2D dir_, float speed_, int bulletnum_)
  {
    location = new Vector2D (Xpos, Ypos);
    xpos = Xpos;
    ypos = Ypos;
    speed = speed_;
    dir = dir_;
    bulletnum = bulletnum_;
  }

  
  
  void update()
  {
     display();
     move();
     collision();
  }
  
  void display(){
    ellipse((float)location.x, (float)location.y, 10, 10);
  }
  
  void move()
  {
   dir.normalize();
   dir.mult(speed);
   location.add(dir);
  }
  
  boolean collision()
  {
    if(dist((float)location.x, (float)location.y, (float)arrow.pos().x, (float)arrow.pos().y) < 10)
    {
     return true; 
    }
    return false;
  }
  
  //boolean hit()
  //{
  // float dist
  // if(dist < 10)
  // {
  //  return true; 
  // }
  // else{
  //  return false; 
  // }
  //}
  
  
  
  

}