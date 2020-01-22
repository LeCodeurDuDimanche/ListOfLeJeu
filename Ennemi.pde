class Ennemi extends Objet {

  public PVector[] patrouille;
  public int pointPatrouilleCourant;
  
  public Ennemi(int x, int y)
  {
    super(x, y);
    patrouille = new PVector[2];
    patrouille[0] = new PVector(max(x - 300, 0), y);
    patrouille[1] = new PVector(x + 50, y);
    pointPatrouilleCourant = 0;
    animationSet = new AnimationSet(ressources.tileset("ennemi"), 4, 0);
    arme = new Pistolet(this);
    arme.cadenceTir = 0.3;
  }
  
  public void evoluerObjet(float duree)
  {
    super.evoluer(duree);
  }
  
  public void evoluer(float duree)
  {
    evoluer(duree, true, true);
  }
  
  public void evoluer(float duree, boolean bouger, boolean tirer)
  {
    PVector dest;
    if (monde.joueur.distanceSq(this) > 80000 || abs(monde.joueur.position.y - position.y) > TILE_H * 3)
    {
      dest = patrouille[pointPatrouilleCourant];
      if (PVector.sub(dest, position).magSq() < 8000)
        pointPatrouilleCourant = (pointPatrouilleCourant + 1) % patrouille.length;
    }
    else
    {
      dest = monde.joueur.position;
      if (tirer && abs(monde.joueur.position.y - position.y) < imageHeight * 1.2 && (!bouger || monde.joueur.distanceSq(this) < 50000))
        tirer();
    }
    if (bouger && PVector.sub(monde.joueur.position, position).add(TILE_W / 2, TILE_H / 2).magSq() > 4 * TILE_W * TILE_W)
      vitesse.x = constrain(dest.x - position.x, -120, 120);
    else vitesse.x = (dest.x - position.x) / 1000.0;
    
    if ((vitesse.x > 0 && objetsContact[DROITE] != null) || 
        (vitesse.x < 0 && objetsContact[GAUCHE] != null)) 
      sauter();
    super.evoluer(duree);
  }
  
  public boolean isPerso()
  {
    return true;
  }
}

class Dougie extends Ennemi {
  
  public Dougie(int x, int y)
  {
    super(x, y);
    animationSet = new AnimationSet(ressources.tileset("dougie"), 1, 0);
    pv = 2;
  }
  
  public void evoluer(float duree)
  {
    PVector dest= monde.joueur.position;
      
    vitesse.x = dest.x > position.x ? 140 : -140;
    
    if ((vitesse.x > 0 && objetsContact[DROITE] != null && objetsContact[DROITE] != monde.joueur) || 
        (vitesse.x < 0 && objetsContact[GAUCHE] != null && objetsContact[GAUCHE] != monde.joueur)) 
      sauter();
    if (monde.joueur.forme.getCenter().dist(forme.getCenter()) < TILE_W + 5)
      exploser();
    evoluerObjet(duree);
  }
  
  public void traiterCollision(Objet o)
  {
    if (o == monde.joueur)
    {
      o.pv -= 30;
      pv = 0;
      exploser();
    }
  }
}


class Boss extends Ennemi {
  
  public String nom;
  public int pvmax;
  
  public Boss(int x, int y, String nom)
  {
    super(x, y);
    this.pv = pvmax = 220;
    this.nom = nom;
    this.degats = 5;
  }
}

class BossStan extends Boss {
  private long lastMove, lastDougie, lastStan;
  private PVector dest;
  
  public BossStan(int x, int y)
  {
    super(x, y, "Stan");
    this.pv = pvmax = 200;
    dest = new PVector(x,y);
    arme = new PistoletFocus(this);
    
    animationSet = new AnimationSet(ressources.tileset("stan"), 4, 0);
    imageWidth = TILE_W  * 3;
    imageHeight = TILE_H * 3;
    forme = new Rectangle(position, TILE_W - 1, TILE_H * 3 - 1);
    imageX = -TILE_W + 3;
  }
  
  public void evoluer(float duree)
  {
    if (monde.joueur.position.dist(position) < 500)
    {
      long now = millis();
      int phase = (int) map(pv, 250, 0, 0, 3);
      switch(phase)
      {
        case 3:
        case 2:
          if (now - lastStan > 5000)
          {
            Ennemi ennemi = new Ennemi((int) monde.joueur.position.x - 300, (int) monde.joueur.position.y);
            if (monde.checkCollision(ennemi) == null)
              monde.ennemis.add(ennemi);
            lastStan = now;
          }
        case 1 :
          if (now - lastDougie > 5000)
          {
            monde.ennemis.add(new Dougie((int) monde.joueur.position.x - (random(1) > .5 ? 300 : -300), 20));
            lastDougie = now;
          }
        case 0:
          if (now - lastMove > 2000)
          {
            lastMove = now;
            dest = PVector.add(monde.joueur.position, new PVector(0, -250).rotate(random( -PI/2, PI/2)));
          }
          arme.utiliser();
          break;
      }
    }
    
    vitesse = PVector.sub(dest, position).setMag(80);
    evoluerObjet(duree);
  }
}

class BossBreak extends Boss {
  public BossBreak(int x, int y)
  {
    super(x, y, "Break");
    animationSet = new AnimationSet(ressources.tileset("break"), 8, 0);
    imageWidth = TILE_W  * 3;
    imageHeight = TILE_H * 3;
    forme = new Rectangle(position, TILE_W - 1, TILE_H * 3 - 1);
    imageX = -TILE_W + 3;
    arme = new LanceGrenade(this);
  }
}

class BossColt extends Boss {
  
  public boolean tirer;
  public long last; 
  
  public BossColt(int x, int y)
  {
    super(x, y, "Colt");
    animationSet = new AnimationSet(ressources.tileset("colt"), 2, 0);
    imageWidth = TILE_W  * 2;
    imageHeight = TILE_H * 2;
    forme = new Rectangle(position, TILE_W * 2 - 1, TILE_H * 2 - 1);
    arme = new Shotgun(this);
    last = 0;
    
    this.pv = pvmax = 500;
  }
  
  public void evoluer(float duree)
  {
    if (pv < 250)
      arme = new Mitraillette(this);
    if (millis() - last > (tirer ? 3000 : 5000))
    {
      tirer = !tirer;
      last = millis();
    }
    super.evoluer(duree, false, tirer);
  }
  
}
