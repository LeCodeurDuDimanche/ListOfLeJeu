class Arme {

  public float cadenceTir;
  public boolean estDistance;
  public int degats;
  public long lastAttaque;
  public Objet owner;
  
  public Arme(Objet o, float cadenceTir, boolean estDistance, int degats) {
    this.cadenceTir = cadenceTir;
    this.estDistance = estDistance;
    this.degats = degats;
    this.owner = o;
  }
  
  protected void tirer(PVector position){
    position.add(owner.regardeDroite ? 10 : -10, 0);
    PVector vitesse = new PVector(owner.regardeDroite ? 500 : -500, 0);
    Projectile proj = new Projectile(position, vitesse, owner);
    proj.degats = degats;
    
    monde.ajouterProjectile(proj);
  }
  
  public void utiliser()
  {
    long now = millis();
    if (now - lastAttaque < 1000 / cadenceTir)
      return;
    
    PVector position = owner.forme.getCenter();
    if (estDistance) {
      tirer(position);
    }
    else {
      position.add(owner.regardeDroite ? TILE_W : -TILE_W, 0);
      Projectile proj = new Projectile(position, new PVector(), owner);
      proj.degats = degats;
      
      Objet o = monde.checkCollision(proj);
      
      if (o != null)
        o.traiterCollision(proj);
      
    }
    lastAttaque = now;
  }
}

class PistoletFocus extends Arme {

  public PistoletFocus(Objet owner) {
    super(owner, .5, true, 20);
  }
  
  protected void tirer(PVector position) {
    position.add(owner.regardeDroite ? 10 : -10, 0);
    PVector vitesse = PVector.sub(monde.joueur.position, position).setMag(350);
    Projectile proj = new Projectile(position, vitesse, owner);
    proj.degats = degats;
    monde.ajouterProjectile(proj);
  }
    

}

class Shotgun extends Arme {
  public Shotgun(Objet owner){
    super(owner, 1, true, 15);
  }
  
   protected void tirer(PVector position) {
    position.add(owner.regardeDroite ? 10 : -10, 0);
    PVector vitesse = new PVector(owner.regardeDroite ? 500 : -500, 0);
    
    for (int i = -2; i <= 2; i++)
    {
      PVector vitesseProj = new PVector(vitesse.x, vitesse.y).rotate(PI/ 22 * i);
      Projectile proj = new Projectile(position, vitesseProj, owner);
      proj.degats = degats;
      proj.distance = 300;
      monde.ajouterProjectile(proj);
    }
  }
}

class Pistolet extends Arme{
  public Pistolet(Objet owner){
    super(owner, 1, true, 20);
  }
}

class LanceGrenade extends Arme{
  public LanceGrenade(Objet owner){
    super(owner, .3, true, 100);
  }
  
  protected void tirer(PVector position) {
    int mult = owner.regardeDroite ? 1 : -1;
    position.add(mult * 10, 0);
    PVector vitesse = new PVector(mult * 100 , -600);
    
    if (monde.joueur == owner)
      vitesse.set(vitesse.x * 0.6, vitesse.y * 0.8);
    
    for (int i = 0; i < 3; i++)
    {
      PVector vitesseProj = new PVector(vitesse.x, vitesse.y).rotate(mult * PI / 32 * i);
      Grenade proj = new Grenade(position, vitesseProj, owner);
      proj.degats = degats;
      monde.ajouterProjectile(proj);
    }
  }
}

class Mitraillette extends Arme {
  public Mitraillette(Objet owner){
    super(owner, 4, true, 15);
  }
  
  
   protected void tirer(PVector position) {
    position.add(owner.regardeDroite ? 10 : -10, 0);
    PVector vitesse = new PVector(owner.regardeDroite ? 500 : -500, 0);
    PVector vitesseProj = new PVector(vitesse.x, vitesse.y).rotate(PI / 32 * random(-1, 1));
    Projectile proj = new Projectile(position, vitesseProj, owner);
    proj.degats = degats;
    monde.ajouterProjectile(proj);
  }
}

class Couteau extends Arme {
  public Couteau(Objet owner){
    super(owner, 2, false, 20);
  }
}
