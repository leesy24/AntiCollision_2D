class Points_Data {
  public int length;
  public int x[], y[];
  public int w[];
  public color c[];
  public int scr_x[], scr_y[];
  
  Points_Data (int n) {
    length = n;
    x = new int[n];
    y = new int[n];
    w = new int[n];
    c = new color[n];
    scr_x = new int[n];
    scr_y = new int[n];
  }
}
