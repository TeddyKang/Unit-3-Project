import game2dai.entities.*;
import game2dai.entityshapes.ps.*;
import game2dai.maths.*;
import game2dai.*;
import game2dai.entityshapes.*;
import game2dai.fsm.*;
import game2dai.steering.*;
import game2dai.utils.*;
import game2dai.graph.*;

//package game2dai.entities;
import game2dai.Domain;
import game2dai.maths.Geometry2D;
import game2dai.maths.Vector2D;
import game2dai.utils.ObstacleSAXParser;

Obstacle obstacle;

World world;
StopWatch sw;
MovingEntity mover0;

float ex; 
float ey;


public void setup() {
  fullScreen();
  world = new World(width, height);
  
  Vector2D pos = new Vector2D(width/2,height/2);
  obstacle = new Obstacle("Teddy", pos, 100);
  
  sw = new StopWatch();
  // Create the mover
  mover0 = new MovingEntity(
      new Vector2D(width/2, 10), // position
      15,                              // collision radius
     new Vector2D(100, 150),            // velocity
      500,                              // maximum speed
      new Vector2D(1,1),              // heading
      10,                               // mass
      3,                             // turning rate
      200                          // max force
  );   
  // What does this mover look like
  ArrowPic view = new ArrowPic(this);
  
  PImage x = createImage(10,10,10);
  // Show collision and movement hints
  //view.showHints(Hints.HINT_COLLISION | Hints.HINT_HEADING | Hints.HINT_VELOCITY);
  // Add the renderer to our MovingEntity
  mover0.renderer(view);
  obstacle.renderer(view);
  // Constrain movement
  Domain d = new Domain(0, 0, width, 250);
  
  int a = SBF.REBOUND;
  mover0.worldDomain(d, a);
  
  

  
  // Finally we want to add this to our game domain  
  world.add(mover0);
  world.add(obstacle);
  sw.reset();
}

void draw() {
  double elapsedTime = sw.getElapsedTime();
  world.update(elapsedTime);
  background(0);
  // Make the movers constraint area visible
  Domain d = mover0.worldDomain();
  fill(255, 200, 200);
  noStroke();
  rect((float)d.width, (float)d.height, (float)d.width, (float)d.height);
  //background(0);
  world.draw(elapsedTime);
  
  float mouseposX = mouseX;
  float mx = mouseposX - ex;
  ex += mx * 0.05;
  float mouseposY = mouseY;
  float my = mouseposY - ey;
  ey += my * 0.05;
  
  ellipse(ex, ey, 10, 10);
}