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
    animationSet = new AnimationSet(ressources.tileset("ennemi"), 4, 0);
    arme = new Pistolet(this);
    arme.cadenceTir = 0.3;
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
    if (PVector.sub(monde.joueur.position, position).add(TILE_W / 2, TILE_H / 2).magSq() > 4 * TILE_W * TILE_W)
      vitesse.x = constrain(dest.x - position.x, -120, 120);
    else vitesse.x = 0;
    
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
