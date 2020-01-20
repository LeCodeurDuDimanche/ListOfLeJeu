public class Clavier {
  
  /**
   * Etats des differentes touches
   */
  private boolean[] touches;
  
  public final int DROITE = 1;
  public final int GAUCHE = 2;
  public final int SAUT = 3;
  public final int TIR = 4;
  public final int MAX = 5;
  
  public Clavier()
  {
    touches = new boolean[MAX];
  }

  public void keyPressed(int keycode)
  {
    setValue(keycode, true);
  }
  
  public void keyReleased(int keycode)
  {
    setValue(keycode, false);
  }
  
  private void setValue(int keycode, boolean val)
  { 
    if (keycode == RIGHT) touches[DROITE] = val;
    else if (keycode == LEFT) touches[GAUCHE] = val;
    else if (keycode == UP) touches[SAUT] = val;
    else if (keycode == ' ') touches[TIR] = val;
  }
  
  public boolean estAppuye(int touche) {
    return touche >= 0 && touche < MAX && touches[touche];
  }
}
