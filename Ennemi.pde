class Ennemi extends Objet {

  public PVector[] patrouille;
  public int pointPatrouilleCourant;
  
  public Ennemi(int x, int y)
  {
    super(x, y);
    patrouille = new PVector[2];
    patrouille[0] = new PVector(max(x - 300, 0), y);
    patrouille[1] = new PVector(x + 300, y);
    pointPatrouilleCourant = 0;
    arme.cadenceTir = 0.5;
    animationSet = new AnimationSet(new Tileset("ennemi", 2, 4), 4, 0);
    
  }
  
  public void evoluer(float duree)
  {
    PVector dest;
    if (monde.joueur.distanceSq(this) > 90000 || abs(monde.joueur.position.y - position.y) > TILE_H * 3)
    {
      dest = patrouille[pointPatrouilleCourant];
      if (PVector.sub(dest, position).magSq() < 50)
        pointPatrouilleCourant = (pointPatrouilleCourant + 1) % patrouille.length;
    }
    else
    {
      dest = monde.joueur.position;
      if (abs(monde.joueur.position.y - position.y) < 40)
        tirer();
    }
      
    vitesse.x = constrain(dest.x - position.x, -120, 120);
    
    
    if ((vitesse.x > 0 && objetsContact[DROITE] != null) || 
        (vitesse.x < 0 && objetsContact[GAUCHE] != null)) 
      sauter();
    super.evoluer(duree);
  }
  
  public boolean isPerso()
  {
    return true;
  }
}
