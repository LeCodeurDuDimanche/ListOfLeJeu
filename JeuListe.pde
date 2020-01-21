Monde monde;
Clavier clavier;
Images ressources;
int TILE_W = 32, TILE_H = 32;

int niveau = 0;
boolean perdu = false;

void setup()
{
  noStroke();
  size(640, 480);
  
  ressources = new Images();
  
  chargerNiveau(1);
  monde.calculerAffichage();
  clavier = new Clavier();
}

void draw()
{
  background(0);
  
  if (perdu) {
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Perdu", width / 2, height / 2);
    return;
  }
  
  if (! monde.evoluer())
    chargerNiveau(-1);
  
  if (monde.ennemis.size() == 0)
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
}

void chargerNiveau(int n)
{
  if (n == -1) {
    perdu = true;
    return;
  }
  
  niveau = n;
  monde = new Monde(sketchPath() + "/niveau-" + n  + ".lvl");
}

void keyPressed()
{
  clavier.keyPressed(keyCode);
}

void keyReleased()
{
  clavier.keyReleased(keyCode);
}
