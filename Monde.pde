import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.io.FileReader;
import java.io.BufferedReader;


class Monde {

  public int w, h;
  public Joueur joueur;
  public List<Ennemi> ennemis;
  public List<Objet> objets;
  public List<Projectile> projectiles;
  public long lastTime;
  public Vue vue;
  public PVector gravite;
  
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
    for (Objet o :objets)
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
             monde.joueur = new Joueur(x, y);
             break;
           case "E":
             ennemis.add(new Ennemi(x, y));
             break;
           case "P":
             objets.add(new Plateforme(x, y));
             break;
       }
  }
  
  public void load(String fichier) {
      BufferedReader stream = null;
    try {
       stream = new BufferedReader(new FileReader(fichier));
       
       String ligne = stream.readLine();
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
        }
    }
  }
  
  public boolean evoluer()
  {
    if (lastTime == 0) lastTime = millis();
    long now = millis();
    float duree = (now - lastTime) / 1000.0;
    
    joueur.evoluer(duree);
    
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
      if (obj != o && aIgnorer != o && o.affecte(obj) && o.checkCollision(obj))
        return o;
    }
    
    for (Projectile p : projectiles)
    {
      if (obj != p && aIgnorer != p && p.affecte(obj) && p.checkCollision(obj))
        return p;
    }
    if (true || ! obj.isPerso())
    {
      for (Ennemi e: ennemis)
      {
        if (obj != e && aIgnorer != e && e.affecte(obj) && e.checkCollision(obj))
          return e;
      }
      if (obj != joueur && aIgnorer != joueur && joueur.affecte(obj) && joueur.checkCollision(obj))
        return joueur;
    }
    return null;
  }
  
  public void ajouterProjectile(Projectile p)
  {
    if (checkCollision(p, p.tireur) == null)
      projectiles.add(p);
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
    
    if (vue.estDansVue(joueur))
      joueur.afficher();
      
    popMatrix();
  }
  

}
