class Joueur extends Objet {
  
  public Joueur(int x, int y)
  {
    super(x, y);
    animationSet = new AnimationSet(ressources.tileset("ennemi"), 6, 0);
     this.pv = 100;
    if (niveau == 1) {
      arme = new Pistolet(this);
      arme.cadenceTir = 1.5;
    }
    else if (niveau == 2)
    {
      arme = new LanceGrenade(this);
      arme.cadenceTir = .8;
    }
    else if (niveau == 3)
    {
      arme = new Mitraillette(this);
    }
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
