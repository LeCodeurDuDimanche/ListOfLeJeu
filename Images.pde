import java.util.Map;

class Images {
  private String noms[] = {"ennemi", "terrain", "default", "joueur", "tir", "break", "explosion", "erlenmeier", "colt", "fond-1", "fond-2", "fond-3", "dougie"};
  private String fichiers[] = {"ennemi.png", "generic-platformer-tiles.png", "boite.png", "axel.png", "flamme.png", "break.png", "explosion.png", "erlenmeier.png", "colt.png", "desert.jpg", "western.jpg", "espace.png", "dougie.png"};
  private String nomsTilesets[] = {"ennemi", "terrain", "joueur", "break", "explosion", "colt", "dougie"};
  private int taillesTilesets[][] = { {2, 4}, {12, 8}, {2, 4}, {4, 4}, {9, 9}, {4, 4}, {1, 1}};
  private Map<String, PImage> images;
  private Map<String, Tileset> tilesets;
  
  public Images()
  {
    images = new HashMap<String, PImage>();
    tilesets= new HashMap<String, Tileset>();
    
    for (int i = 0; i < noms.length; i++)
      images.put(noms[i], loadImage(fichiers[i]));
    for (int i = 0; i < nomsTilesets.length; i++)
      tilesets.put(nomsTilesets[i], new Tileset(get(nomsTilesets[i]), taillesTilesets[i][0], taillesTilesets[i][1]));
  }
  
  public PImage get(String nom)
  {
    return images.get(nom);
  }
  
  public Tileset tileset(String nom)
  {
    return tilesets.get(nom);
  }
}
