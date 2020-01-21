class Projectile extends Objet {
  
  public Objet tireur;
  public float distance;
  
  public Projectile(PVector pos, PVector vitesse, Objet tireur)
  {
    super((int) pos.x, (int) pos.y);
    this.vitesse = vitesse;
    this.tireur = tireur;
    this.degats = 25;
    forme = new Cercle(position, 5);
    distance = 200;
  }
  
  public void traiterCollision(Objet o)
  {
     this.pv = 0;
  }
  
  public void evoluer(float duree)
  { 
    PVector oldPos = new PVector(position.x, position.y);
    appliquerForce(PVector.mult(monde.gravite, -1));
    super.evoluer(duree);
    distance -= oldPos.sub(position).mag();
    if (distance < 0)
      pv = 0;
  }
  
  public void afficher()
  {
    image(ressources.get("tir"), position.x - 5, position.y - 5, 10, 10);
  }
  
  public boolean affecte(Objet o)
  {
    if (tireur == o)
      return false;
    if (tireur != monde.joueur && o.isPerso() && o != monde.joueur)
      return false;
    if (o instanceof Projectile)
      return this.affecte(((Projectile) o).tireur);
      
    return true;
  }
}
