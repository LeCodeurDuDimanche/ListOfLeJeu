class Objet {

  public PVector position, vitesse, acceleration;
  public boolean est_mobile, est_destructible;
  public int pv, degats;
  public Forme forme;
  public String contact;
  public boolean regardeDroite;
  public long lastTir;
  
  public Objet(int x, int y) 
  {
    this(x, y, true, true, 100, 0);
  }
  
  public Objet(int x, int y, boolean mobile, boolean destructible, int pv, int degats)
  {
    position = new PVector(x, y);
    vitesse = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    est_mobile = mobile;
    est_destructible = destructible;
    this.pv = pv;
    this.degats = degats;
    contact = null;
    forme = new Rectangle(position, TILE_W, TILE_H);
    regardeDroite = true;
  }
  
  public boolean checkCollision(Objet o)
  {
    return checkCollision(o.forme);
  }
  
  public boolean checkCollision(Forme f)
  {
    return f.collision(forme);
  }
  
  public void appliquerForce(PVector f)
  {
    if (est_mobile)
      acceleration.add(f);
  }
  
  public void traiterCollision(Objet o)
  {
    if (est_destructible)
      this.pv -= o .degats;
  }
  
  public void afficher()
  {
   image(tileset.getImage("default"), position.x, position.y, TILE_W, TILE_H);
  }
  
  public boolean isPerso()
  {
    return false;
  }
  
  public float distanceSq(Objet obj)
  {
    PVector a = forme.getCenter(), b = obj.forme.getCenter();
    return a.sub(b).magSq();
  }
  
  public void evoluer(float duree)
  {    
    contact = null;
    
    appliquerForce(monde.gravite);
    
    //On ajoute l'acceleraion a la vitesse
    vitesse.add(acceleration);
        
    //vitesse * duree = deplacement
    PVector deplacement = PVector.mult(vitesse, duree);
               
    //On essaye le mouvement en y
    float prevY = position.y;
    position.y += deplacement.y;
    
    Objet o = monde.checkCollision(this);
    if (o != null)
    {
      position.y = prevY;
      
      if (vitesse.y > 0)
        contact = "bas";
      else
        contact = "haut";
      
      vitesse.y = 0;
      
      traiterCollision(o);
      o.traiterCollision(this);
    }
    
    //On essaye le mouvement en x
    float prevX = position.x;
    position.x += deplacement.x;

    o = monde.checkCollision(this);
    if (o != null)
    {
      position.x = prevX;
      
      if (vitesse.x > 0)
        contact = "droite"; //On va a droite, on est bloque a droite
      else
        contact = "gauche";

      traiterCollision(o);
      o.traiterCollision(this);
    }

    vitesse.add(acceleration);
    
    //On reset l'acceleration
    acceleration.set(0, 0);
    
    //Friction
    vitesse.mult((float)0.999); 
    
    if (vitesse.x < 0) regardeDroite = false;
    else if (vitesse.x > 0) regardeDroite = true;
  }
  
  public void sauter()
  {
    if (contact != null && contact != "haut")
      vitesse.y = - 300;
  }
  public void tirer()
  {
    long now = millis();
    if (now - lastTir < 400)
      return;
      
    PVector position = forme.getCenter().add(regardeDroite ? 10 : -10, 0);
    PVector vitesse = new PVector(regardeDroite ? 500 : -500, 0);
    Projectile proj = new Projectile(position, vitesse, this);
    
    monde.ajouterProjectile(proj);
    lastTir = now;
  }
}
