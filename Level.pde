class CellContent {
  Tile tile = null;
  Image background = null;
  Item item = null;
}

class Level {
  Color backgroundColor = new Color();
  Image[][] backgroundImages = new Image[0][0];
  Tile[][] tiles = new Tile[0][0];
  Item[][] staticItems = new Item[0][0];
  ArrayList<Trigger> triggers = new ArrayList<Trigger>(); 
  
  Level(){}
  
  // dimensions in tiles.
  int width(){ return tiles.length; }
  int height(){ return tiles[0].length; }
  
  Image getBackgroundImage(int i, int j){ return (i < 0 || i >= width() || j < 0 || j >= height())? null : backgroundImages[i][j]; }  
  Tile getTile(int i, int j){ return (i < 0 || i >= width() || j < 0 || j >= height())? null : tiles[i][j]; }
  Item getStaticItem(int i, int j){ return (i < 0 || i >= width() || j < 0 || j >= height())? null : staticItems[i][j]; }
  
  
    void drawBackgroundImages() {
        for(int i = 0; i < width(); ++i) {
          for(int j = 0; j < height(); ++j) {
            if(backgroundImages[i][j] != null) {
                drawer.draw(backgroundImages[i][j], i, j);
            }
          }
        }
    }
  
    void drawTiles() {
        for(int i = 0; i < width(); ++i) {
          for(int j = 0; j < height(); ++j) {
            if(tiles[i][j] != null) {
                Tile t = tiles[i][j];
                drawer.draw(t.img, t.pos.x, t.pos.y);
            }
          }
        }
    }

  void drawItems(){
  }
  
  // ***** LOADING FUNCTIONS *****
  void load(String file) {
    
    // read lvl.txt
    String path = (file.lastIndexOf("/") >= 0)? file.substring(0, file.lastIndexOf("/")+1) : ""; 
    String mapFile = null, cellPropertiesFile = null, triggerFile = null;
    String[] lines = loadStrings(file);
    HashMap<String, String> properties = new HashMap<String, String>();
    for(String line : lines){
      
      // tokenize
      String[] tokens = line.split(" ");
      for(int iToken = 0; iToken < tokens.length; iToken++) {      
        String[] tokenParts = tokens[iToken].split("=");
        String name = tokenParts[0];
        String value = tokenParts[1];
        properties.put(name, value);
      }
      
      if(properties.get("property").equals("background")) { backgroundColor.set(int(properties.get("r")), int(properties.get("g")), int(properties.get("b"))); }
      if(properties.get("property").equals("map")) { mapFile = path+properties.get("file"); }
      if(properties.get("property").equals("cellProperties")) { cellPropertiesFile = path+properties.get("file"); }
      if(properties.get("property").equals("triggers")) { triggerFile = path+properties.get("file");}
      
    }
    
    triggers = loadTriggers(triggerFile);    
    char[][] map = loadMap(mapFile);
    HashMap<Character, CellContent> tileProperties = loadTileProperties(cellPropertiesFile);
    
    
    final int w = map.length, h = map[0].length;
    backgroundImages = new Image[w][h];
    tiles = new Tile[w][h];
    staticItems = new Item[w][h];
        
    // creates the tile array based on the read symbols and their properties.
    for(int i = 0; i < w; ++i) {
      for(int j = 0; j < h; ++j) {
        backgroundImages[i][j] = tileProperties.get(map[i][j]).background;
        tiles[i][j] = tileProperties.get(map[i][j]).tile;
        if(tiles[i][j] != null) {
          tiles[i][j] = tiles[i][j].copy();
          tiles[i][j].pos.set(i, j);
        }
        staticItems[i][j] = tileProperties.get(map[i][j]).item;
        if(staticItems[i][j] != null) {
          staticItems[i][j] = staticItems[i][j].copy();
          staticItems[i][j].pos.set(i, j);
        }        
      }
    }
  }
  
  private char[][] loadMap(String file) {
    String[] lines = loadStrings(file);
    int w = lines[0].length(), h = lines.length;
    char[][] map = new char[w][h];
    
    for(int i=0; i < h; i++) {
        for(int j=0; j < w; j++) {
            map[j][h - 1 - i] = lines[i].charAt(j);
        }
    }
    
    return map;
  }
  
    
  private HashMap<Character, CellContent> loadTileProperties(String file) {
    HashMap<Character, CellContent> tileProperties = new HashMap<Character, CellContent>();
    String[] lines = loadStrings(file);
    CellContent currentCellContent = null;
    char index = (char)-1;
    
    for(String line : lines) {
      String[] tokens = line.split(" ");
      if(tokens[0].length() == 0 || tokens[0].charAt(0) == '%') continue;
      if(tokens[0].length() == 1) {
        index = tokens[0].charAt(0);
        currentCellContent = new CellContent();
        tileProperties.put(index, currentCellContent);
      } else {
        
        HashMap<String, String> properties = new HashMap<String, String>();
        for(int iToken = 0; iToken < tokens.length; iToken++) {
          String[] tokenParts = tokens[iToken].split("=");
          String name = tokenParts[0];
          String value = tokenParts[1];
          properties.put(name, value);
        }
        
        if(properties.get("property").equals("background")) {
          currentCellContent.background = resources.getImage(properties.get("image"));
        } else if(properties.get("property").equals("tile")) {
          
          if (properties.get("type").equals("solid")) {
          
            currentCellContent.tile = new SolidTile();
            currentCellContent.tile.size = new Vec2(1, 1);
            
            currentCellContent.tile.img = resources.getImage(properties.get("image"));
            
          } else if (properties.get("type").equals("breakable")) {
            //TODO(step6)
          } else if(properties.get("type").equals("container")) {
            //TODO(step7)
          }
          
        } else if(properties.get("property").equals("item")) {
            //currentCellContent.item= new Item();
           // currentCellContent.item.size = new Vec2(1, 1);
           // currentCellContent.item.img = resources.getImage("data/img/items/flower/%d.png");
        }
      }
    }
    return tileProperties;
  } 
  
  private ArrayList<Trigger> loadTriggers(String file){
    ArrayList<Trigger> triggers = new ArrayList<Trigger>();
    String[] lines = loadStrings(file);
    println(lines.length);
    for(String line : lines){
    
      // read trigger properties
      String[] tokens = line.split(" ");
      if(tokens[0].length() == 0 || tokens[0].charAt(0) == '%') continue;
      
      HashMap<String, String> properties = new HashMap<String, String>();
      
      for(int iToken = 0; iToken < tokens.length; iToken++) {
        String[] tokenParts = tokens[iToken].split("=");
        String name = tokenParts[0];
        String value = tokenParts[1];
        properties.put(name, value);
      }
      
      int x = (int) properties.get("x").charAt(0);
      int y = (int) properties.get("y").charAt(0);
        println(properties.get("type")+" "+properties.get("type").equals("goomba"));
      
      if(properties.get("type").equals("goomba")|| properties.get("type").equals("koopa")){
        
        Enemy mechant = new Goomba(x,y);
        EnemyTrigger enemyT = new EnemyTrigger();
        if(properties.get("type").equals("goomba")){
          mechant = new Goomba(x,y);
        }if(properties.get("type").equals("koopa")){
          mechant = new Koopa(x,y);
        }
        mechant.imgSet = new ImageSet(properties.get("imageSet"));
        enemyT.enemy = mechant;
        triggers.add(enemyT);
    }
  }
    return triggers;
  }
  
  ArrayList<Trigger> copyTriggersArray() {
    println(triggers.size());
    ArrayList<Trigger> result = new ArrayList<Trigger>();
    for(Trigger trig : triggers) {
      result.add(trig);
    }
    return result;
  }
}