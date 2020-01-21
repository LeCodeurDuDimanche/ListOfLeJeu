class Tileset{
 private int w,h,wTile,hTile;
  private ArrayList<PImage> images=null;
 
 Tileset(PImage img, int nbX, int nbY)
  {
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
