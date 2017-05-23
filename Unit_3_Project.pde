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
import java.util.*;

Bullet[] bullets;
int bulletnum = 0;
int numbullets = 8;

float turretX = width/2;
float turretY = height/2;
float targetX = 320;
float targetY = 170;
float targetYX = 0;
float targetYY = 0;


Obstacle obstacle;
Vehicle arrow;
World world;
StopWatch sw;
MovingEntity mover0;

LinkedList<Vector2D> route = new LinkedList<Vector2D>();

Vector2D[] building1;
Building a;
BuildingPic apic;

Vector2D[] building2;
Building b;
BuildingPic bpic;

Vector2D[] building3;
Building c;
BuildingPic cpic;

Vector2D[] building4;
Building d;
BuildingPic dpic;


float ex; 
float ey;


public void setup() {
  fullScreen();
  world = new World(width, height);

  bullets = new Bullet[numbullets];
  
  for(int i = 0; i < numbullets; i++)
  {
   bullets[i] = new Bullet(width, height, 0, 0, 0); 
  }

  Vector2D pos = new Vector2D(width/2, height/2);
  obstacle = new Obstacle("Teddy", pos, 100);

  arrow = new Vehicle(
    new Vector2D(320, 170), // position
    10, // collision radius
    new Vector2D(80, 80), // velocity
    200, // maximum speed
    new Vector2D(1, 0), // heading
    1, // mass
    4, // turning rate
    200                     // max force
    ); 
    

  building1 = new Vector2D[] {
    new Vector2D(width - 650, 1), 
    new Vector2D(width - 525, 1), 
    new Vector2D(width - 525, 250), 
    new Vector2D(width - 650, 250), 
  };
  a = new Building(building1);
  apic = new BuildingPic(this, color(179, 179, 204), color(255), 2);
  a.renderer(apic);
  world.add(a);

  building2 = new Vector2D[] {
    new Vector2D(width - 101, 301), 
    new Vector2D(width, 301), 
    new Vector2D(width, 501), 
    new Vector2D(width - 101, 501), 
    new Vector2D(width - 201, 501)
  };
  b = new Building(building2);
  bpic = new BuildingPic(this, color(179, 179, 204), color(255), 2);
  b.renderer(bpic);
  world.add(b);

  building3 = new Vector2D[] {
    new Vector2D(width - 600, height -1), 
    new Vector2D(width - 600, height - 151), 
    new Vector2D(width - 200, height - 151), 
    new Vector2D(width - 200, height - 351), 
    new Vector2D(width - 1, height - 351), 
    new Vector2D(width -1, height - 1)
  };
  c = new Building(building3);
  cpic = new BuildingPic(this, color(179, 179, 204), color(255), 2);
  c.renderer(cpic);
  world.add(c);

  building4 = new Vector2D[] {
    new Vector2D(width - 790, 565), 
    new Vector2D(width - 700, 425), 
    new Vector2D(width - 400, 575), 
    new Vector2D(width - 490, 715), 
  };
  d = new Building(building4);
  dpic = new BuildingPic(this, color(179, 179, 204), color(255), 2);
  d.renderer(dpic);
  world.add(d);

  sw = new StopWatch();
  // Create the mover
  mover0 = new MovingEntity(
    new Vector2D(width/2, 10), // position
    15, // collision radius
    new Vector2D(100, 150), // velocity
    500, // maximum speed
    new Vector2D(1, 1), // heading
    10, // mass
    3, // turning rate
    200                          // max force
    );   
  // What does this mover look like
  ArrowPic view = new ArrowPic(this);

  PImage x = createImage(10, 10, 10);
  // Show collision and movement hints
  //view.showHints(Hints.HINT_COLLISION | Hints.HINT_HEADING | Hints.HINT_VELOCITY);
  // Add the renderer to our MovingEntity
  mover0.renderer(view);
  obstacle.renderer(view);
  arrow.renderer(view);
  arrow.AP().pathFactors(10, 1).pathOn();
  // Constrain movement
  Domain d = new Domain(0, 0, width, 250);

  int a = SBF.REBOUND;
  mover0.worldDomain(d, a);




  // Finally we want to add this to our game domain  
  world.add(mover0);
  world.add(obstacle);
  world.add(arrow);
  route.add(new Vector2D(arrow.pos()));
  sw.reset();
}

void draw() {
  double elapsedTime = sw.getElapsedTime();
  world.update(elapsedTime);
  background(0);
  
  // Make the movers constraint area visible
  if (arrow.AP().pathRouteLength() == 0)
    arrow.velocity(0, 0);
  background(60, 128, 60);
  fill(100, 200, 100);
  noStroke();
  drawRoute();

  Domain d = mover0.worldDomain();
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
  
  ellipse(turretX, turretY, 50, 50);
  
  for(int i = 0; i < numbullets; i++)
  {
   bullets[i].display();
   bullets[i].move();
   boolean bang = bullets[i].hit();
   if(bang){
     stop();
   }
  }
}

void mouseClicked()
{
  if (mouseX > 20 && mouseX < width - 20 && mouseY > 40 && mouseY <height - 20) {
    Vector2D wp = new Vector2D(mouseX, mouseY);
    arrow.AP().pathAddToRoute(wp);
    route.add(wp);
  }
}

void drawRoute() {
  Vector2D p0, p1;
  // Remove paths that have been travelled
  while (route.size () > arrow.AP().pathRouteLength() + 1)
    route.removeFirst();
  // Draw the path to follow (if any)
  if (route.size() > 1) {
    stroke(255);
    strokeWeight(1);
    p0 = route.get(0);
    for (int i = 1; i < route.size(); i++) {
      p1 = route.get(i);
      line((float)p0.x, (float)p0.y, (float)p1.x, (float)p1.y);
      p0 = p1;
    }
  }
}

 void mousePressed()
  {
   bulletnum = (bulletnum + 1) % numbullets;
   float x = tan((mouseX - turretX)/(turretY - mouseY));
   bullets[bulletnum] = new Bullet(turretX, turretY, 3, x, bulletnum);
  }