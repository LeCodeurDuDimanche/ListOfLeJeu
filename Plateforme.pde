class Plateforme extends Objet {
  
  public int indice = 0;
  
  public Plateforme(int x, int y)
  {
    super(x * TILE_W, y * TILE_H, false, true, 50, 0); 
  }
  
  public void calculerAffichage()
  {
    int[] voisins = new int[4];
    for (int i = 0; i < voisins.length; i++)
    {
      if (i == 4) continue;
      int pos = i * 2 + 1;
      int dx = (pos % 3) - 1;
      int dy = 1 - (pos / 3);
      float x = position.x + TILE_W / 2  + TILE_W * dx, y = position.y + TILE_H / 2 + TILE_H * dy;
      
      Objet obj = new Objet((int) x, (int) y, false, false, 0, 0);
      obj.forme = new Point(obj.position);
      
      voisins[i] = monde.checkCollision(obj) instanceof Plateforme ? 1 : 0;
    }
    
    indice = 15 - (voisins[3] * 8 + voisins[1] * 4 + voisins[2] * 2 + voisins[0]);    
  }
  
  public void afficher()
  {
    
   image(ressources.tileset("terrain").get(indice), position.x, position.y, TILE_W, TILE_H);
  }
}
