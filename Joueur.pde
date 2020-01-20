class Joueur extends Objet {
  
  public Joueur(int x, int y)
  {
    super(x, y);
    pv = 400;
    arme.cadenceTir = 2;
    arme.degats = 50;
    animationSet = new AnimationSet(new Tileset("ennemi", 2, 4), 6, 0);
  }

  public void evoluer(float duree)
  {
    super.evoluer(duree);
    
    //Friction
    if (objetsContact[BAS] != null)
    {
      vitesse.x *= 0.5;
    }
    
  }
  
  public boolean isPerso()
  {
    return true;
  }
}
