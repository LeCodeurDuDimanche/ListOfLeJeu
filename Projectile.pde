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
  }
  
  public void afficher()
  {
    image(tileset.getImage("tir"), position.x - 5, position.y - 5, 10, 10);
  }
  
  public boolean affecte(Objet o)
  {
    if (tireur == o)
      return false;
    if (tireur != monde.joueur && o instanceof Ennemi)
      return false;
    return true;
  }
}
