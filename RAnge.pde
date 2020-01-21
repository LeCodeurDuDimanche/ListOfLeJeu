class Range implements Iterable<Integer>{

  public int deb, fin, inc;
  
  public Range(String desc) {
     inc = 1;
     if (desc.contains(":"))
     {
       String[] range = desc.split(":");
       deb = Integer.parseInt(range[0]);
       if (range[1].contains(";"))
       {
          range = range[1].split(";");
          fin = Integer.parseInt(range[0]);
          inc = Integer.parseInt(range[1]);
       }
       else 
         fin = Integer.parseInt(range[1]);
     }
     else
       deb = fin = Integer.parseInt(desc);
       
  }
  
  public Iterator<Integer> iterator() {
    return new Iterator<Integer>() {
      int value = deb;
      public Integer next(){
        int v = value;
        value += inc;
        return v;
      }
      public boolean hasNext() {
        return value <= fin;
      }
    };
  }

}
