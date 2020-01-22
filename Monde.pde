import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.io.FileReader;
import java.io.BufferedReader;


class Monde {

  public int w, h;
  public Joueur joueur;
  public Boss boss;
  public List<Ennemi> ennemis;
  public List<Objet> objets;
  public List<Projectile> projectiles;
  public List<AnimationRect> animations;
  public long lastTime;
  public Vue vue;
  public PVector gravite;
  public int objetsDetruits, ennemisDetruits, tirs;
  
  public Monde(int w, int h)
  {
    init(w, h);
     for (int x = 0; x < w; x++)
      objets.add(new Plateforme(x, h - 1));
      
    
     for (int x = 0; x < 5; x++)
      objets.add(new Ennemi(x * 100, 50));
  }
  
  public Monde(String fichier) 
  {
    load(fichier);
  }
  
  private void calculerAffichage()
  {
    for (Objet o : objets)
    {
      if (o instanceof Plateforme)
        ((Plateforme) o).calculerAffichage();
    }
  }
  
  private void init(int w, int h)
  {
    this.w = w;
    this.h = h;
    
    this.joueur = new Joueur(1, h / 2);
    ennemis = new ArrayList<Ennemi>();
    objets = new ArrayList<Objet>();
    projectiles = new ArrayList<Projectile>();
    animations = new ArrayList<AnimationRect>();
    
    vue = new Vue(joueur.position, width / TILE_W, height / TILE_H, w, h);
    
    gravite = new PVector(0, 5);
  }
  
  private void loadObjet(int x, int y, String[] tokens)
  {
    switch(tokens[0]) {
           case "O":
             objets.add(new Objet(x, y, Boolean.parseBoolean(tokens[3]),  Boolean.parseBoolean(tokens[4]), Integer.parseInt(tokens[5]), Integer.parseInt(tokens[6])));
             break;
           case "J":
             joueur.position.set(x, y);
             break;
           case "E":
             ennemis.add(new Ennemi(x, y));
             break;
           case "P":
             objets.add(new Plateforme(x, y));
             break;
           case "I":
             Plateforme p = new Plateforme(x, y);
             p.est_destructible = false;
             objets.add(p);
             break;
           case "N":
             ennemis.add(new Ninja(x, y));
             break;
           case "BossStan":
             boss = new BossStan(x, y);
             break;
           case "BossBreak":
             boss = new BossBreak(x, y);
             break;
           case "BossColt":
             boss = new BossColt(x, y);
             break;
       }
  }
  
  public void load(String fichier) {
      BufferedReader stream = null;
    try {
       stream = new BufferedReader(new FileReader(fichier));
       
       String ligne = stream.readLine();
       
       while ((ligne.length() == 0 || ligne.charAt(0) == '#'))
         ligne = stream.readLine();
         
       String[] coords = ligne.split(" ");
       init(Integer.parseInt(coords[0]), Integer.parseInt(coords[1]));
       
       while ((ligne = stream.readLine()) != null)
       {
         ligne = ligne.trim();
         if (ligne.length() == 0 || ligne.charAt(0) == '#')
           continue;
           
         String[] tokens = ligne.split(" ");
         Range xRange = new Range(tokens[1]);
         Range yRange = new Range(tokens[2]);
                  
         for (int x : xRange)
           for (int y : yRange)
             loadObjet(x, y, tokens);;
       }
         
       stream.close();
    } catch (IOException e) {
      System.err.println(e);
      exit();
    }
  }
  
  private void enleverMorts(List<? extends Objet> objets)
  {
    Iterator<? extends Objet> i = objets.iterator();
 
    while(i.hasNext()) {
        Objet o = i.next();
        if (o.pv <= 0 || o.position.y > h * TILE_H + 100) {
            i.remove();
            if (!o.isPerso() && o.est_mobile && !(o instanceof Projectile))
              objetsDetruits++;
            if (o.isPerso())
              ennemisDetruits++;
        }
    }    
  }
  
  public boolean evoluer()
  {
    if (lastTime == 0) lastTime = millis();
    long now = millis();
    float duree = (now - lastTime) / 1000.0;
    
    joueur.evoluer(duree);
    
    if (boss != null)
      boss.evoluer(duree);
    
    for (Ennemi e : ennemis)
      e.evoluer(duree);
    
    for (Objet o : objets)
      o.evoluer(duree);
      
    for (Projectile p : projectiles)
      p.evoluer(duree);
      
    lastTime = now;
    
    //Eliminer trucs morts et hors screen
    enleverMorts(ennemis);
    enleverMorts(objets);
    enleverMorts(projectiles);
    
    return joueur.pv > 0 && joueur.position.y <= h * TILE_H + 100;
  }
  
  public Objet checkCollision(Objet obj)
  {
    return checkCollision(obj, null);
  }

  public Objet checkCollision(Objet obj, Objet aIgnorer)
  {
    for (Objet o: objets)
    {
      if (obj != o && aIgnorer != o && o.affecte(obj) && o.pv >0 && o.checkCollision(obj))
        return o;
    }
    
    for (Projectile p : projectiles)
    {
      if (obj != p && aIgnorer != p && p.affecte(obj) && p.pv > 0 && p.checkCollision(obj))
        return p;
    }

    for (Ennemi e: ennemis)
    {
      if (obj != e && aIgnorer != e && e.affecte(obj) && e.pv > 0 && e.checkCollision(obj))
        return e;
    }
    if (obj != joueur && aIgnorer != joueur && joueur.affecte(obj) && joueur.pv > 0 && joueur.checkCollision(obj))
      return joueur;
    
    if (obj != boss && aIgnorer != boss && boss != null && boss.pv > 0 && boss.affecte(obj) && boss.checkCollision(obj))
      return boss;
    return null;
  }
  
  public void ajouterProjectile(Projectile p)
  {
    if (checkCollision(p, p.tireur) == null)
    {
      if (p.tireur == monde.joueur)
        tirs++;
      projectiles.add(p);
    }
  }
  
  
  public void afficher()
  {
    vue.actualiser();
    PVector posVuePixels = vue.getPosVuePixels();
    
    pushMatrix();
    translate(-posVuePixels.x, -posVuePixels.y);
    
    for (Objet o : objets)
      if (vue.estDansVue(o))
        o.afficher();
        
    for (Projectile p : projectiles)
      if (vue.estDansVue(p))
        p.afficher();
    
    for (Ennemi e : ennemis)
      if (vue.estDansVue(e))
        e.afficher();
    
    if (vue.estDansVue(joueur) && joueur.pv > 0)
      joueur.afficher();
      
    if (boss != null && vue.estDansVue(boss) && boss.pv > 0)
      boss.afficher();
      
    Iterator<AnimationRect> i = animations.iterator();
    while(i.hasNext()) {
        AnimationRect a = i.next();
        a.animation.getFrame(); // trigger wasReset
        if (a.animation.wasReset) {
            i.remove();
        }
    }
    
    for (AnimationRect a : animations)
      a.afficher();
      
    popMatrix();

    dessinerBarreDeVie(joueur.pv, 60, 10, height - 25, 100, 20);
    
    if (boss != null && vue.estDansVue(boss))
    {
       textSize(24);
       text(boss.nom, width - 300, height - 15);
       dessinerBarreDeVie(monde.boss.pv, 220, width - 230, height - 25, 200, 20);
    }
  }
  
  private void dessinerBarreDeVie(float pvs, float max, float x, float y, float wBar, float hBar)
  {
    
    pvs = constrain(pvs, 0, max);
    
    stroke(0);
    strokeWeight(3);
    fill(200, 50, 50);
    
    pushMatrix();
    translate(x, y);
    beginShape();
    vertex(9, -1);
    vertex(wBar + 11, -1);
    vertex(wBar + 1, hBar + 1);
    vertex(-1, hBar + 1);    
    endShape(CLOSE);
    
    float vie = wBar * (pvs / max);
    noStroke();
    fill(50, 200, 50);
    
    beginShape();
    vertex(10, 0);
    vertex(vie + 10, 0);
    vertex(vie, hBar);
    vertex(0, hBar);    
    endShape(CLOSE);
    
    fill(0);
    
    textSize(14);
    text(((int) pvs) + "  PV", wBar / 2 + 5, hBar / 2 - 2);
    
    noStroke();
    popMatrix();
  }
  

}
