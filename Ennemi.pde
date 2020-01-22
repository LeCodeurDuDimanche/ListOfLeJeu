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
  
  public void evoluer(float duree)
  {
    evoluer(duree, true);
  }
  
  public void evoluer(float duree, boolean bouger)
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
      if (abs(monde.joueur.position.y - position.y) < imageHeight * 1.2 && monde.joueur.distanceSq(this) < 50000)
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

class Ninja extends Ennemi {
  
  public Ninja(int x, int y)
  {
    super(x, y);
    animationSet = new AnimationSet(ressources.tileset("ninja"), 4, 0);
    arme = new Couteau(this);
  }
  
  public void evoluer(float duree)
  {
    PVector dest= monde.joueur.position;
    
    if (abs(monde.joueur.position.y - position.y) < 40)
      tirer();
    if (PVector.sub(monde.joueur.position, position).add(TILE_W / 2, TILE_H / 2).magSq() < 4 * TILE_W * TILE_W)
      tirer();
      
    vitesse.x = constrain(dest.x - position.x, -140, 140);
    
    if ((vitesse.x > 0 && objetsContact[DROITE] != null && objetsContact[DROITE] != monde.joueur) || 
        (vitesse.x < 0 && objetsContact[GAUCHE] != null && objetsContact[GAUCHE] != monde.joueur)) 
      sauter();
    super.evoluer(duree);
  }
}


class Boss extends Ennemi {
  
  public String nom;
  
  public Boss(int x, int y, String nom)
  {
    super(x, y);
    this.pv = 220;
    this.nom = nom;
    this.degats = 5;
  }
}

class BossStan extends Boss {
  public BossStan(int x, int y)
  {
    super(x, y, "Lee");
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
  public BossColt(int x, int y)
  {
    super(x, y, "Colt");
    animationSet = new AnimationSet(ressources.tileset("colt"), 2, 0);
    imageWidth = TILE_W  * 2;
    imageHeight = TILE_H * 2;
    forme = new Rectangle(position, TILE_W * 2 - 1, TILE_H * 2 - 1);
    arme = new Mitraillette(this);
  }
  
  public void evoluer(float duree)
  {
    super.evoluer(duree, false);
  }
  
}
