Monde monde;
Clavier clavier;
Images ressources;
int TILE_W = 32, TILE_H = 32;

void setup()
{
  noStroke();
  size(640, 480);
  ressources = new Images();
  monde = new Monde(sketchPath() + "/niveau.lvl");
  clavier = new Clavier();
}

void draw()
{
  background(0);
  if (monde.evoluer()) {
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
      monde.joueur.tirer();
  }
  else
  {
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("NIQUE TA MERE LA CHIENNE", width / 2, height / 2);
    noLoop();
  }
}

void keyPressed()
{
  clavier.keyPressed(keyCode);
}

void keyReleased()
{
  clavier.keyReleased(keyCode);
}
