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
        
  Player() {}
     
  void step(float dt) {
    super.step(dt);
    
    if(turns) {
        float vx = -sin(game.time/100) / 8;
        float vy = cos(game.time/100) / 8;
        
        pos.add(new Vec2(vx,vy));
    }
    handleTiles();
    handleEnemies();
    handleItems();
    handleObstacles(); //<>// //<>//
  }
  
  void interactWith(Tile tile){ //<>// //<>//
  }   
  
  void interactWith(Enemy enemy){  
  }
  
  void interactWith(Item item){
  }
  
  void interactWith(Body body){ //<>//
    
    Vec2 v = body.computePushOut(this); //<>//
    println("hello");
    pos.add(v);
  }
 //<>//
  boolean valid(){ return alive; }

  
}   
