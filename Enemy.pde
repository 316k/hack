
// ****************** Enemy base class **********************
// base class for all enemies
// (koopa, goomba, piranhaplant, ...)

abstract class Enemy extends Body {
  boolean alive = true;
  
  // **** constructors ****
  Enemy(float x, float y) {
    super();
    vel.set(0.1,0);
    pos.set(x,y);
  }
    
  // **** stepping ****
  void step(float dt){
    if(!alive) return; //<>//
    handleTiles();
    super.step(dt); //<>//
  }
    //<>// //<>//
  boolean valid(){ return alive; }
  
  void interactWith(Tile tile){
    vel.x = -vel.x;
    pos.add(computePushOut(tile));
  }
}



// ************ GOOMBA ************

class Goomba extends Enemy {
  ImageSet imgSet = null;
  
  // **** constructors ****
  Goomba(float x, float y) { 
    super(x, y);
  }
  
  // **** stepping ****
  void step(float dt){
    if(!alive) return;
    super.step(dt); //<>//
  }   //<>//
}


// ************ KOOPA *************

class Koopa extends Enemy {
  ImageSet imgSet = null;
  
  // **** constructors ****
  Koopa(float x, float y) {
    super(x, y);
  }
  
  // **** stepping ****
  void step(float dt){
    if(!alive) return;
    super.step(dt);
  }
  
}