import java.util.Map;

class Tileset {
  private String noms[] = {"ennemi", "sol", "default", "joueur", "tir"};
  private String fichiers[] = {"dougie.png", "sol.png", "boite.png", "axel.png", "flamme.png"};
  private Map<String, PImage> images;
  
  public Tileset()
  {
    images = new HashMap<String, PImage>();
    for (int i = 0; i < noms.length; i++)
      images.put(noms[i], loadImage(fichiers[i]));
  }
  
  public PImage getImage(String nom)
  {
    return images.get(nom);
  }
}
