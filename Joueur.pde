class Joueur extends Objet {
  
  public Joueur(int x, int y)
  {
    super(x, y);
  }
  
  public void afficher()
  {
   pushMatrix();
   translate(position.x + TILE_W / 2, position.y);
   if (regardeDroite)
     scale(-1, 1);
   image(tileset.getImage("joueur"), - TILE_W / 2, 0, TILE_W, TILE_H);
   popMatrix();
  }
  
  public void evoluer(float duree)
  {
    super.evoluer(duree);
    
    //Friction
    if (contact == "bas")
    {
      vitesse.x *= 0.8;
    }
    
  }
  
  public void sauter()
  {
    if (contact != null && contact != "haut")
      vitesse.y = - 450;
  }
  
  public boolean isPerso()
  {
    return true;
  }
}
