class Joueur extends Objet {
  
  public Joueur(int x, int y)
  {
    super(x, y);
    animationSet = new AnimationSet(ressources.tileset("ennemi"), 6, 0);
    arme = new Pistolet(this);
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
