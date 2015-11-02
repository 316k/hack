
// ************ Body base class **************
// base class for all interacting game element
// (player, enemies, items, tiles, ...)

class Body{
  Vec2 pos = new Vec2(); // position of botom-left corner
  Vec2 size = new Vec2(1);  
  Vec2 vel = new Vec2();
  Vec2 accel = new Vec2();
  Vec2 damping = new Vec2(1,1);
  Image img = null;
  boolean visible = true;
  
  //color of the body
  Color bodyColor = new Color();
  void setColor(Color c) {bodyColor = c;}
  
  
  // **** constructors ****
  Body(){}
  Body(float x, float y){ pos.x = x; pos.y = y; }
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
  }
  
  // **** Utilitary functions ****
  float left(){ return pos.x; }
  float right(){ return pos.x + size.x; }
  float bottom(){ return pos.y; }
  float top(){ return pos.y + size.y; }
  float centerx(){ return pos.x + size.x/2; }
  float centery(){ return pos.y + size.y/2; }
  
  
  // says whether body intersects another or not.
  boolean intersects(Body body){
    return 
       ((left() <= body.right()   && body.right() <= right())
    || (left() <= body.left()     && body.left() <= right())
    || (body.left() <= right()    && right() <= body.right())
    || (body.left() <= left()     && left() <= body.right()))
    && ((bottom() <= body.bottom() && body.bottom() <= top())
    || (bottom() <= body.top()    && body.top() <= top())
    || (body.bottom() <= bottom() && bottom() <= body.top() )
    || (body.bottom() <= top()    && top() <= body.top()));
  }
   //<>//
    
  // computes the shortest translation to apply to body so it doesn't intersect with this.
  Vec2 computePushOut(Body body) {
    Vec2 v = new Vec2(0,0);
    float depX = (abs(left()-body.right()) <= abs(right()-body.left()))? left()-body.right() : right()-body.left();
    float depY = (abs(top()-body.bottom()) <= abs(bottom()-body.top()))? top()-body.bottom() : bottom()-body.top();
    
    if(abs(depX )<= abs(depY)) //<>//
      v.add(depX, 0);
    else //<>//
      v.add(0, depY);
    return v;  
  }
  
  
  // interraction loop functions. //<>//
  void handlePlayer(){
    if(this.intersects(game.player)) //<>//
      interactWith(game.player);
  }
  void handleTiles(){
    // select tiles close to the body, and interract with them.
    ArrayList<Tile> tiles = new ArrayList<Tile>();
    for(Tile tile : tiles)
      if(tile != null && this.intersects(tile))
        this.interactWith(tile);
  }
  void handleItems(){
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
      if(this.intersects(obstacle)&&game.solveObstacles)
        this.interactWith(obstacle);
  }
  
  void draw() {
    if(img == null) {
        fill(bodyColor.r, bodyColor.g, bodyColor.b);
        rect(pos.x, pos.y, size.x, size.y);
        return;
    }
    drawer.draw(img, pos.x, pos.y);
  };
  
  
  // **** Functions to overload by children if needed ****
  boolean valid() { return true; }  
  void interactWith(Player player){}
  void interactWith(Enemy enemy){}
  void interactWith(Item item){}
  void interactWith(Tile tile){}
  void interactWith(Body body){}
}
