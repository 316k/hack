import java.util.Iterator;

class Game{
  Level level = new Level();
  float time;
  float dt = 1;
  boolean play;
  Window window;
  Player player;
  
  ArrayList<Item> items = new ArrayList<Item>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<Animation> animations = new ArrayList<Animation>();
  ArrayList<Body> obstacles = new ArrayList<Body>();
  ArrayList<Trigger> activeTriggers = new ArrayList<Trigger>();
    
  Game(){
    window = new Window();
    init();
  }
  
  void init(){    
    
    // clear all
    items.clear();
    enemies.clear();
    animations.clear();
    obstacles.clear();
    activeTriggers.clear();
    
    // load level
    level.load("data/levels/lvl1-1/lvl.txt");  
    activeTriggers = level.copyTriggersArray();
        
    window.setSize(16,16);
    window.setLeft(19);
    window.setBottom(19);
    
    player = new Player();
    player.pos = new Vec2(25, 25);
    player.size = new Vec2(1, 2);
    for(int i = 0; i < random(5,20); i++){
      obstacles.add(new Body(random(0,50),random(0,50),random(1,10),random(1,10)));
    }
    for(Body b: obstacles){
      b.setColor(new Color(100,0,100));
    }
    
    
    play = true;
    time = 0;
  }
  
  boolean deplaceW = true;
  
  void step() {
    if(!play) {
      return;
    }

    // step all
    player.step(dt);
    for(Body b: obstacles){
      if(b.intersects(player)){
          b.setColor(new Color(255,140,0));
      }
      else{
        b.setColor(new Color(100,0,100));
      }
    }
    if(deplaceW){
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
        
    time += dt;
  }

  void draw(){
    
    background(0,0,0);
    stroke(0.1);
    strokeWeight(0);
    for(int i=0; i < 50; i++) {
        for(int j=0; j < 50; j++) {
          int a = (i + j) % 2 == 0 ? 255 : 0;
          
          fill(0, a, 255 - a);
          
          rect(i, j, 1, 1);
      }
    }
    player.draw();
    for(Body b: obstacles){
      b.draw();
    }
  }
  
}