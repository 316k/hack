interface Trigger{
  boolean triggered();
  void activate();
  boolean completed();
}


class EnemyTrigger implements Trigger{
  Enemy enemy;
  boolean completed = false;
    
  boolean triggered() {
    return abs(game.player.pos.x-enemy.pos.x)<16.1;
}
  void activate() {
    //game.enemies.add(enemy);
    completed = true;
  }
  
  boolean completed() {return completed;}
}