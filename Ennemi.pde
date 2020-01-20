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
    
  }
  
  public void afficher()
  {
   pushMatrix();
   translate(position.x + TILE_W / 2, position.y);
   if (regardeDroite)
     scale(-1, 1);
   image(tileset.getImage("ennemi"), - TILE_W / 2, 0, TILE_W, TILE_H);
   popMatrix();
  }
  
  public void evoluer(float duree)
  {
    if (contact == "droite" || contact == "gauche") 
      sauter();
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
    super.evoluer(duree);
  }
  
  public boolean isPerso()
  {
    return true;
  }
}
