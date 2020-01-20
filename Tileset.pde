class Tileset{
 private int w,h,wTile,hTile;
  private ArrayList<PImage> images=null;
 
 Tileset(String name, int nbX, int nbY)
  {
    	PImage img=ressources.get(name);
    	w=nbX;
    	h=nbY;
    	wTile=img.width/w;
    	hTile=img.height/h;
      images=new ArrayList<PImage>();
      for (int y=0;y<nbY;y++)
      {
        for (int x=0;x<nbX;x++)
          images.add(img.get(x*wTile,y*hTile,wTile,hTile));
      }
  }

  PImage get(int index)
  {
    if (images==null)
      return null;
  	return images.get(index);
  }
  
  
  int getTileX()
  {
    return w;
  }
  
  int getTileY()
  {
    return h;
  }
  int getTileW()
  {
    return wTile;
  }
  
  int getTileH()
  {
    return hTile;
  }
}
