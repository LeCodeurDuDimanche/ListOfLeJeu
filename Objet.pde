class Objet {
  
  public final static int HAUT = 0, BAS = 1, GAUCHE = 2, DROITE = 3;

  public PVector position, vitesse, acceleration;
  public boolean est_mobile, est_destructible;
  public int pv, degats;
  public Forme forme;
  public boolean regardeDroite;
  public Objet[] objetsContact;
  public Arme arme;
  public AnimationSet animationSet;
  public int imageWidth, imageHeight, imageX;
  
  public Objet(int x, int y) 
  {
    this(x, y, true, true, 20, 0);
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
    objetsContact = new Objet[4];
    forme = new Rectangle(position, TILE_W - 1, TILE_H - 1);
    regardeDroite = true;
    arme = null;
    imageWidth = TILE_W;
    imageHeight = TILE_H;
    imageX= 0;
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
    if (est_destructible && o.pv > 0)
      this.pv -= o.degats;
  }
  
  public void afficher()
  {
    if (animationSet == null)
      image(ressources.get("default"), position.x, position.y, TILE_W, TILE_H);
    else {
      
      if (arme != null && millis() - arme.lastAttaque < 500)
        animationSet.change(3);
      else if (abs(vitesse.x) < 0.01)
        animationSet.change(0);
      else
        animationSet.change(1);
      
      pushMatrix();
      translate(position.x + imageWidth / 2 + imageX, 0);
      if (!regardeDroite)
        scale(-1, 1);
        
      image(animationSet.getFrame(), - imageWidth / 2, position.y, imageWidth, imageHeight);
      popMatrix();
    }
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
    for (int i = 0; i< 4; i++)
      objetsContact[i] = null;
    
    appliquerForce(PVector.mult(monde.gravite, duree));
    
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
        objetsContact[BAS] = o;
      else
        objetsContact[HAUT] = o;
      
      traiterCollision(o);
      o.traiterCollision(this);
      
      vitesse.y = 0;
    }
    
    //On essaye le mouvement en x
    float prevX = position.x;
    position.x += deplacement.x;

    o = monde.checkCollision(this);
    if (o != null)
    {
      position.x = prevX;
      
      if (vitesse.x > 0)
        objetsContact[DROITE] = o;
      else
        objetsContact[GAUCHE] = o;
      
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
    if (objetsContact[BAS] != null)
      vitesse.y = - 300;
  }
  public void tirer()
  {
    if (arme == null)
      return;
 
    arme.utiliser();
  }
  
   public boolean affecte(Objet o)
  {
    if (o instanceof Projectile)
      return o.affecte(this);
    
    return true;
  }
}
