import java.util.Iterator;

class Game {
  Level level = new Level();
  float time;
  float dt = 1;
  boolean play;
  Window window;
  Player player;
  int world = 1, level_no = 1, coins = 0;
  float last_step_dt = 0;
  
  boolean fleche = false;
  Vec2 vectur;
  
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
    player.size = new Vec2(1, 2);
    for(int i = 0; i < random(5,20); i++){
      obstacles.add(new Body(random(0,50),random(0,50),random(1,10),random(1,10)));
    }
    for(Body b: obstacles){
      b.setColor(new Color(100,0,100));
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
        // FIXME window.setLeft(min(level.width() - window.left(), window.left()));
        window.setBottom(max(window.bottom(), 0));
        // FIXME window.setBottom(min(level.height() - 1, window.bottom()));
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

  void draw(){
    stroke(0);
    
    background(level.backgroundColor.r, level.backgroundColor.g, level.backgroundColor.b);
    fill(level.backgroundColor.r, level.backgroundColor.g, level.backgroundColor.b);

    strokeWeight(0);
    rect(0, 0, 50, 52);
    level.drawBackgroundImages();
    level.drawTiles();
    level.drawItems();
    

    for(Body b: obstacles){
      b.draw();
    }

    player.draw();
       
    if(fleche){
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
    println(time);
    drawer.draw("TIME", window.right() - 3, level.height() + 1);
    drawer.draw(nf((int) time/100, 3), window.right() - 2.5, level.height());
  }
  
}
