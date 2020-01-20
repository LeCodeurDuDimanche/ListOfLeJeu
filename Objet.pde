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
    objetsContact = new Objet[4];
    forme = new Rectangle(position, TILE_W, TILE_H);
    regardeDroite = true;
    arme = new Arme(this, 1, true, 25);
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
    if (animationSet == null)
      image(ressources.get("default"), position.x, position.y, TILE_W, TILE_H);
    else {
      if (abs(vitesse.x) < 0.01)
        animationSet.change(0);
      else if (regardeDroite)
        animationSet.change(1);
      else if (!regardeDroite)
        animationSet.change(2);
      image(animationSet.getFrame(), position.x, position.y, TILE_W, TILE_H);
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
        objetsContact[BAS] = o;
      else
        objetsContact[HAUT] = o;
      
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
    if (objetsContact[BAS] != null || 
        (objetsContact[DROITE] != null && !objetsContact[DROITE].est_mobile) || 
        (objetsContact[GAUCHE] != null && !objetsContact[GAUCHE].est_mobile))
      vitesse.y = - 300;
  }
  public void tirer()
  {
    arme.utiliser();
    if (animationSet != null)
    {
      animationSet.change(3);
      animationSet.queue(0);
    }
  }
}
