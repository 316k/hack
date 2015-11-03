import java.util.Iterator;

class Game {
  Level level = new Level();
  float time;
  float dt = 1;
  boolean play;
  Window window;
  Player player;
  int world = 1, level_no = 2, coins = 0;
  float last_step_dt = 0;
  
  boolean fleche = false;
  Vec2 vectur, gravity = new Vec2(0, -0.05);
  
  boolean solveObstacles=false;
  ArrayList<Item> items = new ArrayList<Item>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<Animation> animations = new ArrayList<Animation>();
  ArrayList<Body> obstacles = new ArrayList<Body>();
  ArrayList<Trigger> activeTriggers = new ArrayList<Trigger>();
  
  
    
  Game(){
    window = new Window();
    init();
  }
  
  void init() {
    
    // clear all
    items.clear();
    enemies.clear();
    animations.clear();
    obstacles.clear();
    activeTriggers.clear();
    time = 400;
    
    // load level
    level.load("data/levels/lvl" + world + "-" + level_no + "/lvl.txt");  
    activeTriggers = level.copyTriggersArray();
        
    window.setSize(16,16);
    window.setLeft(0);
    window.setBottom(0);
    
    player = new Player();
    player.pos = new Vec2(1, 2);

    player.size = new Vec2(0.96, 2);

    player.bodyColor = new Color(255, 255, 255);

    for(int i = 0; i < random(5,20); i++){
      //obstacles.add(new Body(random(0,50),random(0,50),random(1,10),random(1,10)));
    }
    for(Body b: obstacles){
      b.setColor(new Color(100,0,100));
    }
    for(int i = 0; i<4; i++){
      items.add(new Star(random(1, level.width()), 2));
      
    }
    for(int i = 0; i<4; i++){
      items.add(new Mushroom(random(1, level.width()), 2));
    }
    for(int i = 0; i<4; i++){
      items.add(new OneUp(random(1, level.width()), 2));
    }
    for(int i = 0; i<4; i++){
      items.add(new Flower(random(1, level.width()), 2));
    }
    items.add(new Star(5,5));
    for(Item i: items){
      if(i instanceof Flower){
        i.img = resources.getImage("data/img/items/flower/%d.png");
      }
      if(i instanceof Mushroom){
        i.img = resources.getImage("data/img/items/mushroom.png");
      }
      if(i instanceof OneUp){
        i.img = resources.getImage("data/img/items/oneUp.png");
      }
      if(i instanceof Star){
        i.img = resources.getImage("data/img/items/star/%d.png");
      }
    }
    for(int i = 0; i<4; i++){
      enemies.add(new Goomba(random(1, level.width()), 2));
    }
    for(int i = 0; i<10; i++){
      enemies.add(new Koopa(random(1, level.width()), 2));
    }
    for(Enemy e: enemies){
      if(e instanceof Koopa){
      e.setColor(new Color(100, 30, 70));
      }if(e instanceof Goomba){
        e.setColor(new Color(30, 30, 100));
      }
    }
    play = true;
    time = 40000;
  }
  
  boolean deplaceW = true;
  
  void step() {
    if(!play) {
      return;
    }
    // step all
    player.step(dt);
    fleche = false;
    for(Body b: obstacles){
      if(b.intersects(player)){
          b.setColor(new Color(255,140,0));
          vectur = b.computePushOut(player);
          
    println(solveObstacles);
          if(!solveObstacles){
          fleche =true;
          }
          
      }
      else{
        b.setColor(new Color(100,0,100));
      }
    }
    
    if(deplaceW) {
        float diff_right = window.right() - player.right();
        if(diff_right <= 3) {
             window.translateBy(new Vec2(3 - diff_right, 0));
        }
        
        float diff_left = player.left() - window.left();
        if(diff_left <= 3) {
             window.translateBy(new Vec2(diff_left - 3, 0));
        }

        float diff_top = window.top() - player.top();
        if(diff_top <= 3) {
             window.translateBy(new Vec2(0, 3 - diff_top));
        }
        
        float diff_bottom = player.bottom() - window.bottom();
        if(diff_bottom <= 3) {
             window.translateBy(new Vec2(0, diff_bottom - 3));
        }
        
        window.setLeft(max(window.left(), 0));
        
        if(window.right() > level.width()) {
            window.setLeft(level.width() - window.width());
        }
        
        window.setBottom(max(window.bottom(), 0));
        
       if(window.top() > level.height() + 2) {
            window.setBottom(level.height() + 2 - window.height());
        }
    }
    
    for(Enemy enemy : enemies) enemy.step(dt);
    for(Item item : items) item.step(dt);
    for(Body obstacle : obstacles) obstacle.step(dt);
    for(Animation anim : animations) anim.step(dt);
    
    // check triggers
    for(Iterator<Trigger> it = activeTriggers.iterator(); it.hasNext();) {
      Trigger trigger = it.next();
      if(trigger.triggered())
        trigger.activate();
    }
    
    // cleanup
    for(Iterator<Enemy> it = enemies.iterator(); it.hasNext();)
      if(!(it.next()).valid()) it.remove();
    for(Iterator<Item> it = items.iterator(); it.hasNext();)
      if(!(it.next()).valid()) it.remove();
    for(Iterator<Body> it = obstacles.iterator(); it.hasNext();)
      if(!(it.next()).valid()) it.remove();
    for(Iterator<Animation> it = animations.iterator(); it.hasNext();)
      if(it.next().completed()) it.remove();
    for(Iterator<Trigger> it = activeTriggers.iterator(); it.hasNext();)
      if(it.next().completed()) it.remove();
        
    time -= dt;
  }

  void draw() {
    stroke(0);
    
    background(level.backgroundColor.r, level.backgroundColor.g, level.backgroundColor.b);
    fill(level.backgroundColor.r, level.backgroundColor.g, level.backgroundColor.b);

    strokeWeight(0);
    rect(0, 0, 50, 52);
    level.drawBackgroundImages();
    level.drawTiles();
    level.drawItems();
    
    for(Item i: items){
      i.draw();
    }
for(Enemy i: enemies){
      i.draw();
    }
    for(Body b: obstacles){
      b.draw();
    }

    player.draw();
       
    if(fleche) {
        strokeWeight(0.1); 
        stroke(255, 255, 255);
        line(player.centerx(), player.centery(), player.centerx()+vectur.x, player.centery()+vectur.y);
    }

    // Score
    drawer.draw("MARIO", window.left() + 1, level.height() + 1);
    drawer.draw(nf(123, 6), window.left() + 1, level.height());
    
    // Coins & lives
    // drawer.draw(nf(player.lives, 2), window.left() + 5.5, level.height());
    drawer.draw("x" + nf(coins, 2), window.left() + 5, level.height());
    
    // Level
    drawer.draw("WORLD", window.left() + 9.5, level.height() + 1);
    drawer.draw(world + "-" + level_no, window.left() + 10, level.height());
    
    // Time
    drawer.draw("TIME", window.right() - 3, level.height() + 1);
    drawer.draw(nf((int) time/100, 3), window.right() - 2.5, level.height());
  }
  
}
