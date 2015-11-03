
// ************** Item base class ********************* 
// base class for all items

abstract class Item extends Body {
  boolean consumed = false;
  
  // **** constructors ****
  Item() {}
  Item(float x, float y){ 
    super(x, y);
  }
  Item(Item o){ 
    super(o);
    this.consumed = o.consumed;
  }
  abstract Item copy();
  
  // **** stepping ****
  void step(float dt){
    super.step(dt);
  }
  
  // **** interactions ****
  
  void pickedUpBy(Player player) {}
  boolean valid(){ return !consumed; }
}



// ***************** Grow ********************
// temporary item that creates appropriate item (mushroom or flower) on grow (out of tile)

class Grow extends Item{  
  Grow(){}
  Grow(Grow o){ super(o); }
  Grow copy(){ return new Grow(this); }
}



// **************** Mushroom ***********************

class Mushroom extends Item{
  
  Mushroom() { super(0,0); }
  Mushroom(float x, float y) {
    super(x, y);
  }
  Mushroom(Mushroom o){ super(o); this.img = o.img; }
  Mushroom copy(){ return new Mushroom(this); }
}



// ****************** Flower ***********************

class Flower extends Item{
  
  Flower() { super(0,0); }  
  Flower(float x, float y) {
    super(x, y);
  }
  Flower(Flower o){ super(o); this.img = o.img.copy(); }
  Flower copy(){ return new Flower(this); }
}




// ************* One Up ****************

class OneUp extends Item{
  OneUp() { super(0,0); }
  OneUp(float x, float y) {
    super(x, y);
  }
  OneUp(OneUp o){ super(o); }
  OneUp copy(){ return new OneUp(this); }
}



// *************** Coin ******************

class Coin extends Item{
  Coin() { super(0,0); }
  Coin(float x, float y) { super(x, y); }
  Coin(Coin o){ super(o); }
  Coin copy(){ return new Coin(this); }
}



// ****************** Star **********************

class Star extends Item{
  
  Star() { super(0,0); }
  Star(float x, float y) {
    super(x, y);
    accel.set(0,-0.01);
    vel.set(0.1, 0);
  }
  void step(float dt){
    super.step(dt);
    handleTiles();
  }
  Star(Star o){ super(o); }
  Star copy(){ return new Star(this); }
  
  void interactWith(Tile tile){
     Vec2 v = tile.computePushOut(this);
     float x = (v.x == 0)? 1 : -1*v.x/abs(v.x);
     float y = (v.y == 0)? 1 : -1*v.y/abs(v.y);
     vel.mult(x,y);
     pos.add(v.clamp(-0.40, 0.40));
  }
}
