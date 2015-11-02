class Player extends Body {
  
  // ImageSets (used in Step4)
  ImageSet smallMarioSet = new ImageSet("data/img/players/mariosmall");
  ImageSet smallStarMarioSet[] = {
   new ImageSet("data/img/players/mariosmalldark"),
   new ImageSet("data/img/players/mariosmallflower"),
   new ImageSet("data/img/players/mariosmallgreen"),
   new ImageSet("data/img/players/mariosmallpale")
  };
  ImageSet bigMarioSet = new ImageSet("data/img/players/mariobig");
  ImageSet bigStarMarioSet[] = {
   new ImageSet("data/img/players/mariobigdark"),
   new ImageSet("data/img/players/mariobigflower"),
   new ImageSet("data/img/players/mariobiggreen"),
   new ImageSet("data/img/players/mariobigpale")
  };
  ImageSet flowerMarioSet = new ImageSet("data/img/players/mariobigflower");
  
  
  boolean alive = true;
  boolean isCrouching;
  boolean turns = false;
  ImageSet imgSet;
  int lives = 3;
        
  Player() {
    damping = new Vec2(0.9, 0.9);
  }
     
  void step(float dt) {
    super.step(dt);
    
    // Mode pour tourner en rond
    if(turns) {
        float vx = -sin(game.time/100) / 8;
        float vy = cos(game.time/100) / 8;
        
        pos.add(new Vec2(vx,vy));
    }
    
    accel = game.gravity;
    vel = vel.add(dt * accel.x, dt * accel.y);
    vel.set(damping.x * dt * vel.x, damping.y * dt * vel.y);
    pos.add(dt * vel.x, dt * vel.y);
    
    handleTiles();
    handleEnemies();
    handleItems(); //<>//
    handleObstacles(); //<>// //<>//
  }
   //<>//
  void interactWith(Tile tile){ 
    Vec2 v = tile.computePushOut(this); 
    pos.add(v);
  }   
  
  void interactWith(Enemy enemy){  
  }
  
  void interactWith(Item item){ //<>//
  }
   //<>//
  void interactWith(Body body){ //<>//
    
    Vec2 v = body.computePushOut(this); 
    pos.add(v);
  }
 //<>//
  boolean valid(){ return alive; }

  
}   
