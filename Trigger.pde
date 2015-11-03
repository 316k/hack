interface Trigger{
  boolean triggered();
  void activate();
  boolean completed();
}


class EnemyTrigger implements Trigger{
  Enemy enemy;
  boolean completed = false;
    
  boolean triggered() {
    return abs(game.player.pos.x-enemy.pos.x)<5;
}
  void activate() {
   println(enemy.pos.x);
    game.enemies.add(enemy);
    completed = true;
  }
  
  boolean completed() {return completed;}
}