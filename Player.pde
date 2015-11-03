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
    
    
    // Motion
    accel = game.gravity;

    accel.x = 0.2 * (Keyboard.isPressed(68) ? 1 : (Keyboard.isPressed(65) ? -1 : 0));
    
    println(vel.y);
    
    if(Keyboard.isPressed(87) && vel.y > 0 && vel.y < 0.7) {
        vel.y += 0.2;
    }
    
    
    vel = vel.add(dt * accel.x, dt * accel.y);
    vel.set(damping.x * dt * vel.x, damping.y * dt * vel.y);
    
    pos.add(new Vec2(dt * vel.x, dt * vel.y).clamp(-0.49, 0.49));
    
    // Crouch
    isCrouching = Keyboard.isPressed(83);
    size.set(0.99, isCrouching ? 0.99 : 2);
    
    
    // TODO
    // pos.y += 1 * (Keyboard.isPressed(87) ? 1 : (Keyboard.isPressed(83) ? -1 : 0));
    
    // Limits
    pos.x = max(pos.x, 0);
    pos.y = max(pos.y, 0);
    pos.x = min(pos.x, game.level.width() - 1);
    pos.y = min(pos.y, game.level.height() - 1);
    
    handleTiles();
    handleEnemies(); //<>//
    handleItems(); //<>// //<>//
    handleObstacles(); //<>// //<>//
  } //<>//
   //<>//
  void interactWith(Tile tile){ 
    Vec2 v = tile.computePushOut(this); 
    pos.add(v);
  }   
  
  void interactWith(Enemy enemy){  
  }
   //<>//
  void interactWith(Item item){ //<>//
  } //<>//
   //<>// //<>//
  void interactWith(Body body){ //<>//
    
    Vec2 v = body.computePushOut(this); 
    pos.add(v);
  } //<>//
 //<>//
  boolean valid(){ return alive; }

  
}   
