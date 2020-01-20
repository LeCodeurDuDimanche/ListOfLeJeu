class Vue {
  
  private PVector positionVue;
  public PVector following;
  public int w, h, mondeW, mondeH;
  
  public Vue(PVector f, int w, int h, int mondeW, int mondeH)
  {
    this.w = w;
    this.h = h;
    this.mondeW = mondeW;
    this.mondeH = mondeH;
    following = f;
    positionVue = new PVector(0, 0);
  }
  
  public PVector mondeVersVue(PVector pos)
  {
    return PVector.sub(pos, getPosVuePixels());
  }
  
  public PVector vueVersMonde(PVector pos)
  {
    return PVector.add(pos, getPosVuePixels());
  }
  
  public boolean estDansVue(PVector pos)
  {
    return estDansVue(new Point(pos));
  }
  
  public boolean estDansVue(Objet o)
  {
    return estDansVue(o.forme);
  }
  
  public boolean estDansVue(Forme f)
  {
    Forme r = new Rectangle(getPosVuePixels(), w * TILE_W, h * TILE_H);
    return r.collision(f);
  }
  
  public PVector getPosVue()
  {
    return positionVue;    
  }
  
  public PVector getPosVuePixels()
  {
    return PVector.mult(getPosVue(), TILE_W);
  }
  
  public void actualiser() 
  {
    positionVue.x = constrain(following.x / TILE_W - w / 2, 0, (mondeW - w));
    positionVue.y = constrain(following.y / TILE_H - h / 2, 0, (mondeH - h));
  }
  
}
