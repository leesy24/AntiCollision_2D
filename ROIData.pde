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

final static boolean PRINT_ROI_DATA_GROUPING_POINTS_DBG = true; 
//final static boolean PRINT_ROI_DATA_GROUPING_POINTS_DBG = false;
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
//static int ROI_Data_distance_max = 10000; // = 1 meter
static int ROI_Data_distance_max = 5000; // = 0.5 meter = 50 cm

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
  LinkedList<ROI_Points_Data>[] points = new LinkedList[PS_INSTANCE_MAX];

  // Create the ROI_Data
  ROI_Data() {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CONSTRUCTOR_DBG) println("ROI_Data:constructor():");
    for (int i = 0; i < PS_INSTANCE_MAX; i ++)
    {
      points[i] = new LinkedList<ROI_Points_Data>();
    }
  }

  void clear_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_points("+instance+"):");
    int i = 0;
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_points("+instance+"):"+"points["+instance+"]:"+"points length="+points[instance].size());
    points[instance].clear();
  }

  void add_point(int instance, int region, int mi_x, int mi_y, int scr_x, int scr_y) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_POINT_DBG) println("ROI_Data:add_points("+instance+"):"+"region="+region+",mi_x="+mi_x+",mi_y="+mi_y+",scr_x="+scr_x+",scr_y="+scr_y);
    points[instance].add(new ROI_Points_Data(region, mi_x, mi_y, scr_x, scr_y));
  }

  void grouping_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):");
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"points length="+points[instance].size());
    if (points[instance].size() == 0) {
      if (PRINT_ROI_DATA_ALL_ERR || PRINT_ROI_DATA_GROUPING_POINTS_ERR) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"points length=0 error!");
      return;
    }
    int distance_max = 0;
    int cnt = 0;
    int i = 0;
    ROI_Points_Data point_base;
    for (; i < points[instance].size() - 1; i ++) {
      point_base = points[instance].get(i);
      //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"point_base["+i+"]:"+"region="+point_base.region+",mi_x="+point_base.mi_x+",mi_y="+point_base.mi_y+",scr_x="+point_base.scr_x+",scr_y="+point_base.scr_y);
      distance_max = 0;
      int max_j = i;
      ROI_Points_Data point_prev = point_base;
      for (int j = i + 1; j < points[instance].size(); j ++, cnt ++) {
        ROI_Points_Data point_target;
        int distance_base = 0;
        int distance_prev = 0;
        point_target = points[instance].get(j);
        //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"point_target["+j+"]:"+"region="+point_target.region+",mi_x="+point_target.mi_x+",mi_y="+point_target.mi_y+",scr_x="+point_target.scr_x+",scr_y="+point_target.scr_y);
        distance_prev = get_points_distance(point_prev.mi_x, point_prev.mi_y, point_target.mi_x, point_target.mi_y);
        //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"i="+i+",cnt="+cnt+",distance_prev="+distance_prev);
        if (distance_prev > ROI_Data_distance_max) {
          break;
        }
        distance_base = get_points_distance(point_base.mi_x, point_base.mi_y, point_target.mi_x, point_target.mi_y);
        if (distance_base > distance_max) {
          distance_max = distance_base;
          max_j = j;
        }
        point_prev = point_target;
      }
      if (cnt != 0) {
        if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"i="+i+",cnt="+cnt+",distance_max="+distance_max+",max_j="+max_j);
        if (max_j != i) i = max_j;
        cnt = 0;
      }
      else {
        distance_max = get_point_rotate_distance(point_base.mi_x, point_base.mi_y, PS_Data_handle.scan_angle_step[instance]);
        if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"i="+i+",cnt="+cnt+",distance_max="+distance_max);
      }
    }
    if (cnt == 0 && i < points[instance].size()) {
      point_base = points[instance].get(i);
      //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"point_base["+i+"]:"+"region="+point_base.region+",mi_x="+point_base.mi_x+",mi_y="+point_base.mi_y+",scr_x="+point_base.scr_x+",scr_y="+point_base.scr_y);
      distance_max = get_point_rotate_distance(point_base.mi_x, point_base.mi_y, PS_Data_handle.scan_angle_step[instance]);
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GROUPING_POINTS_DBG) println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"i="+i+",cnt="+cnt+",distance_max="+distance_max);
    }
  }

  void print_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_PRINT_POINTS_DBG) println("ROI_Data:print_points("+instance+"):");
    int i = 0;
    println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"points length="+points[instance].size());
    for (ROI_Points_Data point:points[instance]) {
      println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"point["+i+++"]:"+"region="+point.region+",mi_x="+point.mi_x+",mi_y="+point.mi_y+",scr_x="+point.scr_x+",scr_y="+point.scr_y);
    }
  }

  private int get_points_distance(int point_a_x, int point_a_y, int point_b_x, int point_b_y) {
    int distance = int(sqrt(sq(point_a_x - point_b_x) + sq(point_a_y - point_b_y)));
    //println("ROI_Data:get_points_distance():"+"distance="+distance);
    return distance;
  }

  private int get_point_rotate_distance(int point_x, int point_y, float deg) {
    int point_rot_x, point_rot_y;
    float radians = radians(deg);
    point_rot_x = int(point_x * cos(radians) - point_y * sin(radians));
    point_rot_y = int(point_x * sin(radians) + point_y * cos(radians));
    //println("ROI_Data:get_points_distance():"+"distance="+distance);
    return get_points_distance(point_x, point_y, point_rot_x, point_rot_y);
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
