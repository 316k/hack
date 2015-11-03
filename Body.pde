
// ************ Body base class **************
// base class for all interacting game element
// (player, enemies, items, tiles, ...)

class Body{
  Vec2 pos = new Vec2(); // position of botom-left corner
  Vec2 size = new Vec2(1);  
  Vec2 vel = new Vec2();
  Vec2 accel = new Vec2(0,0);
  Vec2 damping = new Vec2(1,1);
  Image img = null;
  boolean visible = true;
  boolean flipX = false;
  
  //color of the body
  Color bodyColor = new Color();
  void setColor(Color c) {bodyColor = c;}
  
  
  // **** constructors ****
  Body(){}
  Body(float x, float y){ pos.x = x; pos.y = y;}
  Body(float x, float y, float sx, float sy){ pos.x = x; pos.y = y; size.x = sx; size.y = sy; }
  Body(Body o){
    pos = o.pos.copy();
    size = o.size.copy();
    vel = o.vel.copy();
    accel = o.accel.copy();
    damping = o.damping.copy();
    visible = o.visible;
    img = o.img;
  }
  
  
  // **** stepping ****
  void step(float dt) {
    pos.add(vel);
    vel.add(accel);
  }
  
  // **** Utilitary functions ****
  float left(){ return pos.x; }
  float right(){ return pos.x + size.x; }
  float bottom(){ return pos.y; }
  float top(){ return pos.y + size.y; }
  float centerx(){ return pos.x + size.x/2; }
  float centery(){ return pos.y + size.y/2; }
  
  // says whether body intersects another or not.
  boolean intersects(Body body) {
    return abs(centerx() - body.centerx()) <= abs(size.x/2 + body.size.x/2) &&
        abs(centery() - body.centery()) <= abs(size.y/2 + body.size.y/2);
    /*
       ((left() <= body.right()   && body.right() <= right())
    || (left() <= body.left()     && body.left() <= right())
    || (body.left() <= right()    && right() <= body.right())
    || (body.left() <= left()     && left() <= body.right()))
   && ((bottom() <= body.bottom() && body.bottom() <= top())
    || (bottom() <= body.top()    && body.top() <= top())
    || (body.bottom() <= bottom() && bottom() <= body.top())
    || (body.bottom() <= top()    && top() <= body.top()));*/
  }
  
  // computes the shortest translation to apply to body so it doesn't intersect with this.
  Vec2 computePushOut(Body body) {
    Vec2 v = new Vec2(0,0);
    
    float depX = 0;
    float depY = 0;

    depX = size.x/2f + body.size.x/2f - abs(centerx() - body.centerx());
    depY = size.y/2f + body.size.y/2f - abs(centery() - body.centery());
    
    if(this instanceof Player)
        println(depX + " + " + depY);
    
    if(abs(depX) < abs(depY))
      v.add((centerx() > body.centerx() ? -1 : 1) * depX, 0);
    else
      v.add(0, (centery() > body.centery() ? -1 : 1) * depY);
    
    return v;
  }
  
  // interraction loop functions.
  void handlePlayer() {
    if(this.intersects(game.player))
      interactWith(game.player);
  }
  
  float distanceTo(Body body) {
    float x = centerx() - body.centerx();
    float y = centery() - body.centery();
    
    return sqrt(x * x + y * y);
  }
  
  void handleTiles(){
    ArrayList<Tile> tiles = new ArrayList<Tile>();
    for(int i= max(floor(left()),0) ; i<= min(ceil(right()),game.level.width()-1) ; i++) {
      for(int j= max(floor(bottom()),0) ; j< min(ceil(top()),game.level.height()-1); j++) {
        if(game.level.tiles[i][j] != null){
          tiles.add(game.level.tiles[i][j]);
        }
      }
    }
    // sort
    Tile tempTile;
    int n=tiles.size();
    for(int i=0; i<n; i++) {
     int closestTileId = -1;
     float smallestDistance = 1.0e10;
     for(int j=i; j<n; j++) {
       float dist = this.distanceTo(tiles.get(j));
       if(dist < smallestDistance) {
         closestTileId = j;
         smallestDistance = dist;
       }
     }
     tempTile = tiles.get(closestTileId);
     tiles.set(closestTileId, tiles.get(i));
     tiles.set(i, tempTile);
    }
    //    
    for(Tile tile : tiles){
     
      if(tile != null && this.intersects(tile))
        this.interactWith(tile);
    }
  }

  
  void handleItems() {
    // interact with dynamic objects
    for(Item item : game.items)
      if(this.intersects(item))
        this.interactWith(item);
        
    // select static items close to the body, and interract with them.
    Item items[] = {};
    for (Item item : items)
      if (item != null && this.intersects(item))
        this.interactWith(item);
  }
  void handleEnemies(){
    for(Enemy enemy : game.enemies)
      if(this.intersects(enemy))
        this.interactWith(enemy);
  }
  void handleObstacles(){
    for(Body obstacle : game.obstacles)
      if(this.intersects(obstacle)) 
        this.interactWith(obstacle);
  }
  
  void draw() {
    if(img == null) {
        fill(bodyColor.r, bodyColor.g, bodyColor.b);
        rect(pos.x, pos.y, size.x, size.y);
        return;
    }
    
    drawer.draw(img, pos.x, pos.y, flipX);
  };
  
  
  // **** Functions to overload by children if needed ****
  boolean valid() { return true; }  
  void interactWith(Player player){}
  void interactWith(Enemy enemy){}
  void interactWith(Item item){}
  void interactWith(Tile tile){}
  void interactWith(Body body){}
}
