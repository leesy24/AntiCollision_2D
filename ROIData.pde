//final static boolean PRINT_ROI_DATA_ALL_DBG = true; 
final static boolean PRINT_ROI_DATA_ALL_DBG = false;
final static boolean PRINT_ROI_DATA_ALL_ERR = true; 
//final static boolean PRINT_ROI_DATA_ALL_ERR = false;

//final static boolean PRINT_ROI_DATA_SETTINGS_DBG = true; 
final static boolean PRINT_ROI_DATA_SETTINGS_DBG = false;
//final static boolean PRINT_ROI_DATA_SETTINGS_ERR = true; 
final static boolean PRINT_ROI_DATA_SETTINGS_ERR = false;

//final static boolean PRINT_ROI_DATA_SETUP_DBG = true; 
final static boolean PRINT_ROI_DATA_SETUP_DBG = false;
//final static boolean PRINT_ROI_DATA_SETUP_ERR = true; 
final static boolean PRINT_ROI_DATA_SETUP_ERR = false;

//final static boolean PRINT_ROI_DATA_CONSTRUCTOR_DBG = true; 
final static boolean PRINT_ROI_DATA_CONSTRUCTOR_DBG = false;
//final static boolean PRINT_ROI_DATA_CONSTRUCTOR_ERR = true; 
final static boolean PRINT_ROI_DATA_CONSTRUCTOR_ERR = false;

//final static boolean PRINT_ROI_DATA_CLEAR_POINTS_DBG = true; 
final static boolean PRINT_ROI_DATA_CLEAR_POINTS_DBG = false;
//final static boolean PRINT_ROI_DATA_CLEAR_POINTS_ERR = true; 
final static boolean PRINT_ROI_DATA_CLEAR_POINTS_ERR = false;

//final static boolean PRINT_ROI_DATA_ADD_POINT_DBG = true; 
final static boolean PRINT_ROI_DATA_ADD_POINT_DBG = false;
//final static boolean PRINT_ROI_DATA_ADD_POINT_ERR = true; 
final static boolean PRINT_ROI_DATA_ADD_POINT_ERR = false;

//final static boolean PRINT_ROI_DATA_GROUPING_POINTS_DBG = true; 
final static boolean PRINT_ROI_DATA_GROUPING_POINTS_DBG = false;
//final static boolean PRINT_ROI_DATA_GROUPING_POINTS_ERR = true; 
final static boolean PRINT_ROI_DATA_GROUPING_POINTS_ERR = false;

//final static boolean PRINT_ROI_DATA_PRINT_POINTS_DBG = true; 
final static boolean PRINT_ROI_DATA_PRINT_POINTS_DBG = false;
//final static boolean PRINT_ROI_DATA_PRINT_POINTS_ERR = true; 
final static boolean PRINT_ROI_DATA_PRINT_POINTS_ERR = false;

//final static boolean PRINT_ROI_DATA_PARSE_DBG = true; 
final static boolean PRINT_ROI_DATA_PARSE_DBG = false;
//final static boolean PRINT_ROI_DATA_PARSE_ERR = true; 
final static boolean PRINT_ROI_DATA_PARSE_ERR = false;

//final static boolean PRINT_ROI_DATA_DRAW_DBG = true; 
final static boolean PRINT_ROI_DATA_DRAW_DBG = false;

static color C_ROI_DATA_ERR_TEXT = #000000; // Black
static color C_ROI_DATA_LINE = #0000FF; // Blue
static color C_ROI_DATA_POINT = #FF0000; // Red
static int W_ROI_DATA_LINE = 1;
static color C_ROI_DATA_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
static color C_ROI_DATA_RECT_STROKE = #000000; // Black
static int W_ROI_DATA_RECT_STROKE = 1;
static color C_ROI_DATA_RECT_TEXT = #404040; // Black + 0x40

static ROI_Data ROI_Data_handle = null;

void ROI_Data_settings() {
  if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():");
}

void ROI_Data_setup() {
  if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_SETUP_DBG) println("ROI_Data_setup():");

  ROI_Data_handle = new ROI_Data();
  if(ROI_Data_handle == null)
  {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ALL_ERR || PRINT_ROI_DATA_SETUP_ERR) println("ROI_Data_setup():ROI_Data_handle=null");
    return;
  }
}

// A ROI_Data class
class ROI_Data {
  LinkedList<ROI_Points_Data>[] list = new LinkedList[PS_INSTANCE_MAX];

  // Create the ROI_Data
  ROI_Data() {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CONSTRUCTOR_DBG) println("ROI_Data:constructor():");
    for (int i = 0; i < PS_INSTANCE_MAX; i ++)
    {
      list[i] = new LinkedList<ROI_Points_Data>();
    }
  }

  void clear_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_points("+instance+"):");
    int i = 0;
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_points("+instance+"):"+"list["+instance+"]:"+"points length="+list[instance].size());
    list[instance].clear();
  }

  void add_point(int instance, int region, int mi_x, int mi_y, int scr_x, int scr_y) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_POINT_DBG) println("ROI_Data:add_points("+instance+"):"+"region="+region+",mi_x="+mi_x+",mi_y="+mi_y+",scr_x="+scr_x+",scr_y="+scr_y);
    list[instance].add(new ROI_Points_Data(region, mi_x, mi_y, scr_x, scr_y));
  }

  void grouping_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):");
    int i = 0;
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"list["+instance+"]:"+"points length="+list[instance].size());
    for (ROI_Points_Data point:list[instance]) {
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"list["+instance+"]:"+"point["+i+++"]:"+"region="+point.region+",mi_x="+point.mi_x+",mi_y="+point.mi_y+",scr_x="+point.scr_x+",scr_y="+point.scr_y);
    }
  }

  void print_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_PRINT_POINTS_DBG) println("ROI_Data:print_points("+instance+"):");
    int i = 0;
    println("ROI_Data:print_points("+instance+"):"+"list["+instance+"]:"+"points length="+list[instance].size());
    for (ROI_Points_Data point:list[instance]) {
      println("ROI_Data:print_points("+instance+"):"+"list["+instance+"]:"+"point["+i+++"]:"+"region="+point.region+",mi_x="+point.mi_x+",mi_y="+point.mi_y+",scr_x="+point.scr_x+",scr_y="+point.scr_y);
    }
  }
}

class ROI_Points_Data {
  public int region;
  public int mi_x, mi_y;
  public int scr_x, scr_y;
  
  ROI_Points_Data(int region, int mi_x, int mi_y, int scr_x, int scr_y) {
    this.region = region;
    this.mi_x = mi_x;
    this.mi_y = mi_y;
    this.scr_x = scr_x;
    this.scr_y = scr_y;
  }
}
