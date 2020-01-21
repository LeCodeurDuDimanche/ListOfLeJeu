class Joueur extends Objet {
  
  public Joueur(int x, int y)
  {
    super(x, y);
    pv = 400;
    animationSet = new AnimationSet(ressources.tileset("joueur"), 6, 0);
    arme = new Couteau(this);
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
