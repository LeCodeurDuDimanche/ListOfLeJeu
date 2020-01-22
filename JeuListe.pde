import processing.sound.*;
//SoundFile musique;

Monde monde;
Clavier clavier;
Images ressources;
int TILE_W = 32, TILE_H = 32;

int niveau = 0, tries = 1;
boolean perdu = false, animationFinNiveau = false, fini = false;
long debutAnimation, compteur, totalTime, debut;
float score = 0;
String fond;

PFont font;

void setup()
{
  noStroke();
  size(640, 480);
  
  ressources = new Images();
  
  font = createFont("airstrike.ttf", 42);
  textFont(font);
  
  niveau = 3;
  monde = new Monde(sketchPath() + "/niveau-" + niveau + ".lvl");
  monde.calculerAffichage();
  fond = "fond-" + niveau;
  //musique = new SoundFile(this, "musique-" + niveau + ".mp3");
 // musique.play();
  
  clavier = new Clavier();
  
  debutAnimation = millis();
  debut = millis();
  
  textSize(40);
  textAlign(CENTER, CENTER);
}

void draw()
{
  background(0);
  
  image(ressources.get(fond), map(monde.vue.positionVue.x, 0, monde.w, -200, 0), map(monde.vue.positionVue.y, 0, monde.h, -50, 0), width + 200, height + 50);
  
  if (fini) {
    fill(100, 0, 0, 200);
    rect(0, height / 2 - height / 4, 0, height / 2);
    fill(255);
    textSize(42);
    text("Vous êtes une légende", width / 2, height / 2 - 50);
    textSize(24);
    text("Score : " + (int)score, width / 2, height / 2 + 50);
    return;
  }
  
  
  if (perdu) {
    monde.afficher();
    fill(100, 0, 0, 200);
    rect(0, height / 2 - height / 4, 0, height / 2);
    fill(255);
    textSize(42);
    text("Mission échouée", width / 2, height / 2 - 50);
    textSize(24);
    text("Appuyez sur [Entree] pour réessayer", width / 2, height / 2 + 50);
    if (key == ENTER || key == RETURN)
     {       
      monde = new Monde(sketchPath() + "/niveau-" + niveau  + ".lvl");
      monde.calculerAffichage();
      perdu = false;
     }
     tries++;
     debut = millis();  
    
  }
  else if (animationFinNiveau)
  {
    monde.afficher();
    gererAnimations();
  }
  else {
    
    if (! monde.evoluer())
      chargerNiveau(-1);
    
    if (monde.joueur.pv >0 && monde.boss == null && monde.ennemis.size() == 0 || monde.boss != null && monde.boss.pv <= 0)
      chargerNiveau(niveau + 1);
    
    monde.afficher();
    
    PVector vitesse = monde.joueur.vitesse;
    float depl = 150;
    if (clavier.estAppuye(clavier.DROITE))
        vitesse.x = depl;
    else if (clavier.estAppuye(clavier.GAUCHE))
      vitesse.x = -depl;
    
    if (clavier.estAppuye(clavier.SAUT))
      monde.joueur.sauter();
      
    if (clavier.estAppuye(clavier.TIR))
    {
      monde.joueur.tirer();
    }
    compteur = millis() - debut;
  }
  
  fill(255);
  textSize(16);
  text(nf(compteur / 1000., 0, 2), 30, 15);
}

void gererAnimations() {
   long now = millis();
   long t = now - debutAnimation;
   
   float x = width;
   if (t < 1500)
   {
      x = map(t, 0, 1500, 0, width);
   }
   
   textSize(42);
   fill(200, 200, 0, 200);
   rect(x - width, height / 2 - height / 4, x, height / 2);
   fill(255);
   text("Niveau terminé !", width - x, height / 2 - height / 4, width, height / 4);
   
   if (t >= 1800)
   {
     textSize(24);
     text(monde.ennemisDetruits + " ennemis tués", width / 2, height / 2);
   }
   if (t >= 2500)
     text(monde.objetsDetruits + " objets détruits", width / 2, height / 2 + 45);
   if (t >= 3000)
     text(monde.tirs + " munitions utilisées", width / 2, height / 2 + 90);
     
     
   if (t >= 3300)
   {   
     text("Appuyez sur [Entrée] pour continuer", width / 2, height / 2 + 150);
     if (key == ENTER || key == RETURN)
     {
       animationFinNiveau = false;
       
      totalTime += compteur;
      debut = millis();
      score += 1000 * monde.objetsDetruits + 3000 * monde.ennemisDetruits + 10000;
      
      if (niveau < 3) {
        monde = new Monde(sketchPath() + "/niveau-" + niveau  + ".lvl");
        monde.calculerAffichage();
        
        fond = "fond-" + niveau;
      }
      else {
        fini = true;
        
        score = score / ((totalTime / 10000) * sqrt(tries));
      }
     }
     
   }
  
}

void chargerNiveau(int n)
{
  if (n == -1) {
    perdu = true;
    return;
  }
  
  niveau = n;
  animationFinNiveau =true;
  debutAnimation = millis();
}

void keyPressed()
{
  clavier.keyPressed(keyCode);
}

void keyReleased()
{
  clavier.keyReleased(keyCode);
}
