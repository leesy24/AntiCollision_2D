final static boolean PRINT_GRID_ALL_DBG = true; 
//final static boolean PRINT_GRID_ALL_DBG = false;
final static boolean PRINT_GRID_ALL_ERR = true; 
//final static boolean PRINT_GRID_ALL_ERR = false;

//final static boolean PRINT_GRID_SETTINGS_DBG = true; 
final static boolean PRINT_GRID_SETTINGS_DBG = false;
//final static boolean PRINT_GRID_SETTINGS_ERR = true; 
final static boolean PRINT_GRID_SETTINGS_ERR = false;

//final static boolean PRINT_GRID_SETUP_DBG = true; 
final static boolean PRINT_GRID_SETUP_DBG = false;
//final static boolean PRINT_GRID_SETUP_ERR = true; 
final static boolean PRINT_GRID_SETUP_ERR = false;

//final static boolean PRINT_GRID_UPDATE_DBG = true; 
final static boolean PRINT_GRID_UPDATE_DBG = false;
//final static boolean PRINT_GRID_UPDATE_ERR = true; 
final static boolean PRINT_GRID_UPDATE_ERR = false;

//final static boolean PRINT_GRID_DRAW_DBG = true; 
final static boolean PRINT_GRID_DRAW_DBG = false;
//final static boolean PRINT_GRID_DRAW_ERR = true; 
final static boolean PRINT_GRID_DRAW_ERR = false;

//static color C_GRID_LINE = #808080; // Black + 0x80
static color C_GRID_LINE = #C0C0C0; // Black + 0xC0
static int W_GRID_LINE = 1;
static color C_GRID_TEXT = #404040; // Black + 0x40
//static color C_GRID_TEXT = #808080; //Black + 0x80

int[] Grid_zero_x = new int[PS_INSTANCE_MAX];
int[] Grid_zero_y = new int[PS_INSTANCE_MAX];
int[] Grid_scr_x_min = new int[PS_INSTANCE_MAX];
int[] Grid_scr_x_max = new int[PS_INSTANCE_MAX];
int[] Grid_scr_y_min = new int[PS_INSTANCE_MAX];
int[] Grid_scr_y_max = new int[PS_INSTANCE_MAX];
LinkedList<Grid_Line_Data>[] Grid_Lines_array = new LinkedList[PS_INSTANCE_MAX];
LinkedList<Grid_Text_Data>[] Grid_Texts_array = new LinkedList[PS_INSTANCE_MAX];

void Grid_settings()
{
/*
  if (Grid_zero_x == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_zero_x == null");
    return;
  }
  if (Grid_zero_y == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_zero_y == null");
    return;
  }
  if (Grid_scr_x_min == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_scr_x_min == null");
    return;
  }
  if (Grid_scr_x_max == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_scr_x_max == null");
    return;
  }
  if (Grid_scr_y_min == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_scr_y_min == null");
    return;
  }
  if (Grid_scr_y_max == null)
  {
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_scr_y_max == null");
    return;
  }
*/
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    Grid_Lines_array[i] = new LinkedList<Grid_Line_Data>();
    if (Grid_Lines_array[i] == null)
    {
      if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_Lines_array["+i+"] == null");
      return;
    }
    Grid_Texts_array[i] = new LinkedList<Grid_Text_Data>();
    if (Grid_Texts_array[i] == null)
    {
      if (PRINT_GRID_ALL_DBG || PRINT_GRID_ALL_ERR || PRINT_GRID_SETTINGS_ERR) println("Grid_settings():Grid_Texts_array["+i+"] == null");
      return;
    }
  }
}

void Grid_setup()
{
  if (PRINT_GRID_ALL_DBG || PRINT_GRID_SETUP_DBG) println("Grid_setup():Enter");
  Geid_update();
  if (PRINT_GRID_ALL_DBG || PRINT_GRID_SETUP_DBG) println("Grid_setup():Exit");
}

void Geid_update()
{
  if (PRINT_GRID_ALL_DBG || PRINT_GRID_UPDATE_DBG) println("Geid_update():Enter");
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    Grid_scr_x_min[i] = Grid_scr_y_min[i] = MAX_INT;
    Grid_scr_x_max[i] = Grid_scr_y_max[i] = MIN_INT;
    Grid_Lines_array[i].clear();
    Grid_Texts_array[i].clear();
    if (ROTATE_FACTOR[i] == 315) {
      Grid_update_rotate_315(i);
    } else if (ROTATE_FACTOR[i] == 45) {
      Grid_update_rotate_45(i);
    } else if (ROTATE_FACTOR[i] == 135) {
      Grid_update_rotate_135(i);
    } else /*if (ROTATE_FACTOR[i] == 225)*/ {
      Grid_update_rotate_225(i);
    }
    if (PRINT_GRID_ALL_DBG || PRINT_GRID_DRAW_DBG)
    {
      println("Geid_update():Grid_scr_x_min["+i+"]="+Grid_scr_x_min[i]);
      println("Geid_update():Grid_scr_x_max["+i+"]="+Grid_scr_x_max[i]);
      println("Geid_update():Grid_scr_y_min["+i+"]="+Grid_scr_y_min[i]);
      println("Geid_update():Grid_scr_y_max["+i+"]="+Grid_scr_y_max[i]);
    }
  }
  if (PRINT_GRID_ALL_DBG || PRINT_GRID_UPDATE_DBG) println("Geid_update():Exit");
}

void Grid_draw()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    // Sets the color used to draw lines and borders around shapes.
    fill(C_GRID_LINE);
    stroke(C_GRID_LINE);
    strokeWeight(W_GRID_LINE);
    for (Grid_Line_Data line_data:Grid_Lines_array[i])
    {
      line(line_data.x_start, line_data.y_start, line_data.x_end, line_data.y_end);
    }

    // Sets the color used to draw text and borders around shapes.
    fill(C_GRID_TEXT);
    stroke(C_GRID_TEXT);
    textSize(FONT_HEIGHT);
    textAlign(LEFT, BASELINE);
    for (Grid_Text_Data text_data:Grid_Texts_array[i])
    {
      text(text_data.string, text_data.x, text_data.y);
    }
  }
}

class Grid_Line_Data {
  int x_start, y_start;
  int x_end, y_end;

  Grid_Line_Data(int x_start, int y_start, int x_end, int y_end) {
    this.x_start = x_start;
    this.y_start = y_start;
    this.x_end = x_end;
    this.y_end = y_end;
  }
}

class Grid_Text_Data {
  String string;
  int x, y;

  Grid_Text_Data(String string, int x, int y) {
    this.string = string;
    this.x = x;
    this.y = y;
  }
}
