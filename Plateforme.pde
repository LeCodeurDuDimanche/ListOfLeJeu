class Plateforme extends Objet {
  
  public Plateforme(int x, int y)
  {
    super(x * TILE_W, y * TILE_H, false, true, 50, 0); 
  }
  
  public void afficher()
  {
   image(tileset.getImage("sol"), position.x, position.y, TILE_W, TILE_H);
  }
}
