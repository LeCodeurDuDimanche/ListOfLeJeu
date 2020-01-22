class Projectile extends Objet {
  
  public Objet tireur;
  public float distance;
  public boolean gravite;
  
  public Projectile(PVector pos, PVector vitesse, Objet tireur)
  {
    super((int) pos.x, (int) pos.y);
    this.vitesse = vitesse;
    this.tireur = tireur;
    this.degats = 25;
    forme = new Cercle(position, 5);
    distance = 500;
    gravite = false;
  }
  
  public void traiterCollision(Objet o)
  {
     this.pv = 0;
     if (o.est_destructible)
       o.pv -= degats;
     degats = 0;
  }
  
  public void evoluer(float duree)
  { 
    PVector oldPos = new PVector(position.x, position.y);
    if (!gravite) appliquerForce(PVector.mult(monde.gravite, -duree));
    super.evoluer(duree);
    distance -= oldPos.sub(position).mag();
    if (distance < 0)
      pv = 0;
  }
  
  public void afficher()
  {
    image(tireur == monde.joueur ? ressources.get("flechette") : ressources.get("tir"), position.x - 5, position.y - 5, 10, 10);
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

class Grenade extends Projectile {
  
  public Grenade(PVector pos, PVector vitesse, Objet tireur)
  {
    super(pos, vitesse, tireur);
    this.degats = 20;
    forme = new Cercle(position, 12);
    distance= 2500;
    gravite = true;
  }
  
  public void traiterCollision(Objet o)
  {
     this.pv = 0;
     if (o.est_destructible)
       o.pv -= degats;
     exploser();
  }
  
  public void afficher()
  {
    pushMatrix();
    translate(position.x - 12, position.y - 12);
    
    rotate(millis() / 300.0);
    
    image(ressources.get("erlenmeier"),  0, 0, 24, 24);
    popMatrix();
  }
}
