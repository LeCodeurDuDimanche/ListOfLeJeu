import java.util.Map;

class Images {
  private String noms[] = {"ennemi", "sol", "default", "joueur", "tir"};
  private String fichiers[] = {"ennemi.png", "sol.png", "boite.png", "axel.png", "flamme.png"};
  private Map<String, PImage> images;
  
  public Images()
  {
    images = new HashMap<String, PImage>();
    for (int i = 0; i < noms.length; i++)
      images.put(noms[i], loadImage(fichiers[i]));
  }
  
  public PImage get(String nom)
  {
    return images.get(nom);
  }
}
