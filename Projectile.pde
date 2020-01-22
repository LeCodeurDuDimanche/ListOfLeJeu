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
    distance = 500;
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

class Grenade extends Projectile {
  
  public Grenade(PVector pos, PVector vitesse, Objet tireur)
  {
    super(pos, vitesse, tireur);
    this.degats = 20;
    forme = new Cercle(position, 12);
    distance= 2500;
  }
  
  public void traiterCollision(Objet o)
  {
     this.pv = 0;
     exploser();
  }
  
  public void exploser()
  {
     Tileset exp = ressources.tileset("explosion");
     monde.animations.add(new AnimationRect(new Animation(exp, 0, exp.getTileX() * exp.getTileY() - 1, 100), (int) position.x, (int) position.y, 50, 50));

     Projectile obj = new Projectile(position, new PVector(), this);
     obj.forme = new Cercle(obj.position, 40);
     
     Objet collider = monde.checkCollision(obj, this);
     int i = 0;
     while (collider != null && collider != monde.joueur && collider != monde.boss && i++ < 20)
     {
       if (collider.est_destructible) collider.pv = 0;
       collider = monde.checkCollision(obj);
     }
     
     if (collider == monde.joueur) monde.joueur.pv -= degats;
      
  }
  
  public void evoluer(float duree)
  { 
    appliquerForce(monde.gravite);
     super.evoluer(duree);
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
