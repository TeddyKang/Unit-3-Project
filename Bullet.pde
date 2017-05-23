class Bullet{
  float xpos;
  float ypos;
  float speed;
  float angle;
  int bulletnum;
  
  Bullet(float Xpos, float Ypos, float speed_, float angle_, int bulletnum_)
  {
    xpos = Xpos;
    ypos = Ypos;
    speed = speed_;
    angle = angle_;
    bulletnum = bulletnum_;
  }
  
  void update()
  {
     display();
     move();
  }
  
  void display(){
    ellipse(xpos, ypos, 10, 10);
  }
  
  void move()
  {
   xpos = xpos + speed;
   ypos = ypos - speed;
  }
  
  boolean hit()
  {
   float dist = sqrt(sq(targetX - xpos) + sq(targetY - ypos));
   if(dist < 20)
   {
    return true; 
   }
   else{
    return false; 
   }
  }
  
  
  
  
}