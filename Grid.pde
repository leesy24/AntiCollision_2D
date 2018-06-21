//final static boolean PRINT_GRID_ALL_DBG = true; 
final static boolean PRINT_GRID_ALL_DBG = false;
final static boolean PRINT_GRID_ALL_ERR = true; 
//final static boolean PRINT_GRID_ALL_ERR = false;

//final static boolean PRINT_GRID_SETTINGS_DBG = true; 
final static boolean PRINT_GRID_SETTINGS_DBG = false;
//final static boolean PRINT_GRID_SETTINGS_ERR = true; 
final static boolean PRINT_GRID_SETTINGS_ERR = false;

//final static boolean PRINT_GRID_DRAW_DBG = true; 
final static boolean PRINT_GRID_DRAW_DBG = false;
//final static boolean PRINT_GRID_DRAW_ERR = true; 
final static boolean PRINT_GRID_DRAW_ERR = false;

//static color C_GRID_LINE = #808080; // Black + 0x80
static color C_GRID_LINE = #C0C0C0; // Black + 0xC0
static int W_GRID_LINE = 1;
static color C_GRID_TEXT = #404040; // Black + 0x40
//static color C_GRID_TEXT = #808080; //Black + 0x80

int[] Grid_zero_x;
int[] Grid_zero_y;
int[] Grid_scr_x_min;
int[] Grid_scr_x_max;
int[] Grid_scr_y_min;
int[] Grid_scr_y_max;

void Grid_settings()
{
  Grid_zero_x = new int[PS_INSTANCE_MAX];
  if (Grid_zero_x == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_zero_x == null");
    return;
  }
  Grid_zero_y = new int[PS_INSTANCE_MAX];
  if (Grid_zero_y == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_zero_y == null");
    return;
  }
  Grid_scr_x_min = new int[PS_INSTANCE_MAX];
  if (Grid_scr_x_min == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_scr_x_min == null");
    return;
  }
  Grid_scr_x_max = new int[PS_INSTANCE_MAX];
  if (Grid_scr_x_max == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_scr_x_max == null");
    return;
  }
  Grid_scr_y_min = new int[PS_INSTANCE_MAX];
  if (Grid_scr_y_min == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_scr_y_min == null");
    return;
  }
  Grid_scr_y_max = new int[PS_INSTANCE_MAX];
  if (Grid_scr_y_max == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_scr_y_max == null");
    return;
  }
}

void Grid_draw()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    Grid_scr_x_min[i] = Grid_scr_y_min[i] = MAX_INT;
    Grid_scr_x_max[i] = Grid_scr_y_max[i] = MIN_INT;
    if (ROTATE_FACTOR[i] == 315) {
      Grid_draw_rotate_315(i);
    } else if (ROTATE_FACTOR[i] == 45) {
      Grid_draw_rotate_45(i);
    } else if (ROTATE_FACTOR[i] == 135) {
      Grid_draw_rotate_135(i);
    } else /*if (ROTATE_FACTOR[i] == 225)*/ {
      Grid_draw_rotate_225(i);
    }
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_DRAW_DBG)
    {
      println("Grid_draw():Grid_scr_x_min["+i+"]="+Grid_scr_x_min[i]);
      println("Grid_draw():Grid_scr_x_max["+i+"]="+Grid_scr_x_max[i]);
      println("Grid_draw():Grid_scr_y_min["+i+"]="+Grid_scr_y_min[i]);
      println("Grid_draw():Grid_scr_y_max["+i+"]="+Grid_scr_y_max[i]);
    }
  }
}
