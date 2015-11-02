
final int cellSize = 2*16; // in pixels, use multiples of 16
int fps = 50;

// global variables
Drawer drawer = new Drawer();
Resources resources = new Resources();
Game game;

// Processing calls this only once at the beggining of the program.
void setup() {
  noSmooth(); // to get the blocky aspect
  frameRate(fps);
  game = new Game();
}

// Processing runs this every frame.
void draw() {
  game.step();
  pushMatrix();
    scale(cellSize,-cellSize);
    translate(-game.window.bottomLeft.x, -game.window.height()-game.window.bottomLeft.y);  
    game.draw();
  popMatrix();
}

void onKeyPress(int keyCode){

    // Player
    // W
    game.player.pos.y += (keyCode == 87) ? 0.5 : 0;
    // A
    game.player.pos.x += (keyCode == 65) ? -0.5 : 0;
    // S
    game.player.pos.y += (keyCode == 83) ? -0.5 : 0;
    // D
    game.player.pos.x += (keyCode == 68) ? 0.5 : 0;
    
    game.player.pos.x = max(game.player.pos.x, 0);
    game.player.pos.y = max(game.player.pos.y, 0);

    game.player.pos.x = min(game.player.pos.x, game.level.width() - 1);
    game.player.pos.y = min(game.player.pos.y, game.level.height() - 1);
    
    println(keyCode);
    
    if(keyCode == 48 || (50 <= keyCode && keyCode <= 57)) {
        keyCode = (keyCode == 48 ? 58 : keyCode); // 0 devrait aller après 9
        game.player.pos.x = min(game.level.width() * (keyCode - 50)/8, game.level.width() - 1);
        
    }
    
    // World
    // Up
    if(keyCode == 38)
      game.window.translateBy(new Vec2(0, 0.5));
    // Left
    if(keyCode == 37)
      game.window.translateBy(new Vec2(-0.5, 0));
    // Down
    if(keyCode == 40)
      game.window.translateBy(new Vec2(0, -0.5));
    // Right
    if(keyCode == 39)
      game.window.translateBy(new Vec2(0.5, 0));
    //P mettre sur pause l'execution automatique  
    if(keyCode == 80) {
      game.play = !game.play;
    }
    //T = tourner
    if(keyCode == 84) {
      game.player.turns = !game.player.turns;
    }
    //M toggle mouse control 
    if(keyCode == 77) {
      mouse = !mouse;
    }
    //L toggle window movement 
    if(keyCode == 76) {
      game.deplaceW = !game.deplaceW;
    }
    //1 pour init
    if(keyCode == 49) {
      game.init();
    }
    //O = toggle obstacles
    if(keyCode == 79){
      game.solveObstacles = !game.solveObstacles;
    }
    
    
}

void onKeyRelease(int keyCode){
}

boolean mouse =false;
// mouse arguments x and y given in tile units, relative to window (not relative to absolute world).
void onMouseMove(float x, float y) {
  if(mouse){
  Vec2 MouseVect = new Vec2(game.window.left()+x, game.window.bottom()+y);
  game.player.pos = MouseVect;
  }
}

void onMousePress(float x, float y) {
}

void onMouseRelease(float x, float y) {
}
