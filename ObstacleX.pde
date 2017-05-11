/*class Obstacle extends BaseEntity {

  public Obstacle(String name, Vector2D pos, double colRadius) {
    super(name, pos, colRadius);
    visible = true;
  }
  
}

public Building(String name, Vector2D offset, Vector2D[] contour){
    super(name);
    this.contour = new Vector2D[contour.length];
    minX = minY = Double.MAX_VALUE;
    maxX = maxY = -Double.MAX_VALUE;
    pos.set(offset);
    for(int i = 0; i < contour.length; i++){
      this.contour[i] = new Vector2D(contour[i]);
      minX = FastMath.min(minX, this.contour[i].x);
      maxX = FastMath.max(maxX, this.contour[i].x);
      minY = FastMath.min(minY, this.contour[i].y);
      maxY = FastMath.max(maxY, this.contour[i].y);
    }
    this.triangle = Triangulator.triangulate(this.contour);
    visible = true;
  }*/