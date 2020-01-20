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
  
  public void utiliser()
  {
    long now = millis();
    if (now - lastAttaque < 1000 / cadenceTir)
      return;
      
    if (estDistance) {
      PVector position = owner.forme.getCenter().add(owner.regardeDroite ? 10 : -10, 0);
      PVector vitesse = new PVector(owner.regardeDroite ? 500 : -500, 0);
      Projectile proj = new Projectile(position, vitesse, owner);
      
      monde.ajouterProjectile(proj);
    }
    else {
    }
    lastAttaque = now;
  }
}
