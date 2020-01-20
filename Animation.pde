import java.util.HashMap;

class Animation{

  private ArrayList<PImage> frames;
  private int index, delay;
  private long lastTime;
  private boolean paused;
  public boolean wasReset;
  
  Animation(ArrayList<PImage> _frames, int FPS)
  {
    frames= new ArrayList<PImage>(_frames);
    delay = 1000 / FPS;
    paused = true;
  }
  
  Animation(Tileset tileset, int begin, int end, int FPS)
  {
    frames=new ArrayList<PImage>();
    for (int i=begin; i<=end; i++)
      frames.add(tileset.get(i));
    delay=1000/FPS;
    paused=true;
  }

 PImage getFrame()
 {
   wasReset = false;
   long now = millis();
   if (paused)
    {
      index=0;
      lastTime=now;
      paused=false;
    }
  
   if (now-lastTime>delay)
   {
     index++;
     index %= frames.size();
     wasReset = index == 0;
     lastTime=now;
    }
     return frames.get(index);
  }

  int width()
  {
    return frames.get(index).width;
  }
  
  int height()
  {
    return frames.get(index).height;
  }

  void resize(int w, int h)
  {
    for (PImage f: frames)
      f.resize(w,h);
  }

   //Pause it and resume it on next call to show()
   void pause()
   {
     paused=true;
   }
}

class AnimationSet{
  private ArrayList<Animation> anims=new ArrayList<Animation>();
  private int current=0;
  private List<Integer> queue;
  
  AnimationSet(ArrayList<Animation> _anims) throws IllegalArgumentException
  {
     anims = new ArrayList<Animation>(_anims);
     queue = new ArrayList<Integer>();
  }
  
   AnimationSet(Tileset tileset,int FPS, int offset)
  {
    int w=tileset.getTileX();
    for (int i=0; i < tileset.getTileY(); i++)
    {
      int index = i + offset;
      anims.add(new Animation(tileset,index*w,(index+1)*w-1,FPS));
    }
     queue = new ArrayList<Integer>();
    current=0;
  }
  
  void queue(int key)
  {
    queue.add(key);
  }
  
  void add(Animation anim)
  {
  		anims.add(anim);
  }
  
  PImage getFrame()
  {
    anims.get(current).paused = false;
    PImage img = anims.get(current).getFrame();
    if (anims.get(current).wasReset && queue.size() > 0)
    {
      current = queue.get(0);
      queue.remove(0);
      img = anims.get(current).getFrame();
    }
    return img;
  }
  
  int width()
  {
    return anims.get(current).width();
  }
  
  int height()
  {
    return anims.get(current).height();
  }
  
  void resize(int w, int h)
  {
    for (Animation a: anims)
       a.resize(w,h);
  }
  
  void change(int key)
  {
    	anims.get(current).pause();
      current = key;
  }
}
