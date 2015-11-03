
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
    ImageSet imgSet = null;
  // **** stepping ****
  void step(float dt){
    if(!alive) return; //<>// //<>//
    handleTiles();
    super.step(dt); //<>// //<>//
  }
    //<>// //<>// //<>//
  boolean valid(){ return alive; }
  
  void interactWith(Tile tile){
    vel.x = -vel.x;
    pos.add(computePushOut(tile));
  }
}



// ************ GOOMBA ************

class Goomba extends Enemy {
  
  
  // **** constructors ****
  Goomba(float x, float y) { 
    super(x, y);
  }
  
  // **** stepping ****
  void step(float dt){
    if(!alive) return;
    super.step(dt); //<>// //<>//
  }   //<>// //<>//
  
  void draw(){
    if(imgSet != null){
      if(!alive){
        img = imgSet.get("dead");
      }else{
        img = imgSet.get("walking");
      }
    }
  super.draw();
}
}


// ************ KOOPA *************

class Koopa extends Enemy {
  
  // **** constructors ****
  Koopa(float x, float y) {
    super(x, y);
  }
  
  // **** stepping ****
  void step(float dt){
    if(!alive) return;
    super.step(dt);
  }
  void draw(){
    if(imgSet != null){
      if(!alive){
        img = imgSet.get("dead");
      }else{
        img = imgSet.get("walking");
      }
    }
  super.draw();
}
  
}

// ************ PIRANA PLANT *************

class PiranaPlant extends Enemy {
  
  // **** constructors ****
  PiranaPlant(float x, float y) {
    super(x, y);
  }
  
  // **** stepping ****
  void step(float dt){
    if(!alive) return;
    super.step(dt);
  }
  void draw(){
    if(imgSet != null){
      if(!alive){
        img = imgSet.get("dead");
      }else{
        img = imgSet.get("eating");
      }
    }
  super.draw();
}
  
}