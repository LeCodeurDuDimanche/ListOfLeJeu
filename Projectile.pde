class Projectile extends Objet {
  
  public Objet tireur;
  
  public Projectile(PVector pos, PVector vitesse, Objet tireur)
  {
    super((int) pos.x, (int) pos.y);
    this.vitesse = vitesse;
    this.tireur = tireur;
    this.degats = 25;
    forme = new Cercle(position, 5);
  }
  
  public void traiterCollision(Objet o)
  {
     this.pv = 0;
  }
  
  public void evoluer(float duree)
  {    
    appliquerForce(PVector.mult(monde.gravite, -1));
    super.evoluer(duree);
    if (position.x < -100 || position.x > 100 + monde.w * TILE_W)
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
