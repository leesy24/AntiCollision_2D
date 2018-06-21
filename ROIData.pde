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

//final static boolean PRINT_ROI_DATA_DETECT_OBJECTS_DBG = true; 
final static boolean PRINT_ROI_DATA_DETECT_OBJECTS_DBG = false;
//final static boolean PRINT_ROI_DATA_DETECT_OBJECTS_ERR = true; 
final static boolean PRINT_ROI_DATA_DETECT_OBJECTS_ERR = false;

//final static boolean PRINT_ROI_DATA_ADD_OBJECT_DBG = true; 
final static boolean PRINT_ROI_DATA_ADD_OBJECT_DBG = false;
//final static boolean PRINT_ROI_DATA_ADD_OBJECT_ERR = true; 
final static boolean PRINT_ROI_DATA_ADD_OBJECT_ERR = false;

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
//final static boolean PRINT_ROI_DATA_DRAW_ERR = true; 
final static boolean PRINT_ROI_DATA_DRAW_ERR = false;

static color C_ROI_DATA_ERR_TEXT = #000000; // Black
static color C_ROI_DATA_LINE = #0000FF; // Blue
static color C_ROI_DATA_POINT = #FF0000; // Red
static int W_ROI_DATA_LINE = 1;
//static color C_ROI_DATA_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
static color C_ROI_DATA_RECT_FILL = 0x00000000; // Black transparent
//static color C_ROI_DATA_RECT_STROKE = #000000; // Black
static color C_ROI_DATA_RECT_STROKE = 0xFFFFFFFF; // White
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
  LinkedList<ROI_Point_Data>[] points = new LinkedList[PS_INSTANCE_MAX];
  LinkedList<ROI_Object_Data>[] objects = new LinkedList[PS_INSTANCE_MAX];

  // Create the ROI_Data
  ROI_Data() {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CONSTRUCTOR_DBG) println("ROI_Data:constructor():");
    for (int i = 0; i < PS_INSTANCE_MAX; i ++)
    {
      points[i] = new LinkedList<ROI_Point_Data>();
      objects[i] = new LinkedList<ROI_Object_Data>();
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
    points[instance].add(new ROI_Point_Data(region, mi_x, mi_y, scr_x, scr_y));
  }

  void detect_objects(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):Enter");
    if (points[instance].size() == 0) {
      if (PRINT_ROI_DATA_ALL_ERR || PRINT_ROI_DATA_DETECT_OBJECTS_ERR) println("ROI_Data:detect_objects("+instance+"):"+"points size=0 error!");
      return;
    }

    objects[instance].clear();

    do {
      LinkedList<ROI_Point_Data> points_group = new LinkedList<ROI_Point_Data>();
      ROI_Point_Data point_curr;
      ROI_Point_Data point_prev;

      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"points size="+points[instance].size());
      point_prev = points[instance].get(0);
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"point_prev["+0+"]:"+"region="+point_prev.region+",mi_x="+point_prev.mi_x+",mi_y="+point_prev.mi_y+",scr_x="+point_prev.scr_x+",scr_y="+point_prev.scr_y);
      points_group.add(point_prev);
      points[instance].remove(0);
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"points size="+points[instance].size());
      for (int i = 0; i < points[instance].size();) {
        int distance;
        point_curr = points[instance].get(i);
        if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"point_curr["+i+"]:"+"region="+point_curr.region+",mi_x="+point_curr.mi_x+",mi_y="+point_curr.mi_y+",scr_x="+point_curr.scr_x+",scr_y="+point_curr.scr_y);
        distance = get_points_distance(point_prev.mi_x, point_prev.mi_y, point_curr.mi_x, point_curr.mi_y);
        //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"distance="+distance);
        if (distance <= ROI_Data_distance_max) {
          points_group.add(point_curr);
          points[instance].remove(i);
          point_prev = point_curr;
        }
        else {
          i ++;
        }
      }
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"points_group size="+points_group.size());
      add_object(instance, points_group);
      points_group.clear();
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"points size="+points[instance].size());
    } while (points[instance].size() != 0);
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):Exit");
  }

  private void add_object(int instance, LinkedList<ROI_Point_Data> points_group) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECT_DBG) println("ROI_Data:add_object("+instance+"):Enter");

    int region_min;
    int mi_x_min, mi_y_min, mi_x_max, mi_y_max;
    int scr_x_min, scr_y_min, scr_x_max, scr_y_max;

    region_min = MAX_INT;
    mi_x_min = mi_y_min = scr_x_min = scr_y_min = MAX_INT;
    mi_x_max = mi_y_max = scr_x_max = scr_y_max = MIN_INT;

    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:add_object("+instance+"):"+"points_group size="+points_group.size());
    for (ROI_Point_Data point:points_group) {
      region_min = min(region_min, point.region);
      mi_x_min = min(mi_x_min, point.mi_x);
      mi_y_min = min(mi_y_min, point.mi_y);
      mi_x_max = max(mi_x_max, point.mi_x);
      mi_y_max = max(mi_y_max, point.mi_y);
      scr_x_min = min(scr_x_min, point.scr_x);
      scr_y_min = min(scr_y_min, point.scr_y);
      scr_x_max = max(scr_x_max, point.scr_x);
      scr_y_max = max(scr_y_max, point.scr_y);
    }
    objects[instance].add(
      new ROI_Object_Data(
        region_min,
        mi_x_min, mi_y_min,
        mi_x_max, mi_y_max,
        scr_x_min, scr_y_min,
        scr_x_max, scr_y_max));
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECT_DBG) println("ROI_Data:add_object("+instance+"):Exit");
  }

  void print_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_PRINT_POINTS_DBG) println("ROI_Data:print_points("+instance+"):");
    int i = 0;
    println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"points length="+points[instance].size());
    for (ROI_Point_Data point:points[instance]) {
      println("ROI_Data:print_points("+instance+"):"+"points["+instance+"]:"+"point["+i+++"]:"+"region="+point.region+",mi_x="+point.mi_x+",mi_y="+point.mi_y+",scr_x="+point.scr_x+",scr_y="+point.scr_y);
    }
  }

  void draw_objects(int instance) {
    for (ROI_Object_Data object:objects[instance]) {
      int x, y, w, h;

/**/
      x = object.scr_x_start - 10;
      y = object.scr_y_start - 10;
      w = object.scr_x_end - object.scr_x_start + 20;
      h = object.scr_y_end - object.scr_y_start + 20;
/**/
/*
      x = object.scr_x_start;
      y = object.scr_y_start;
      w = object.scr_x_end - object.scr_x_start;
      h = object.scr_y_end - object.scr_y_start;
*/      

      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_DBG) println("ROI_Data:draw_objects("+instance+"):"+"x="+x+",y="+y+",w="+w+",h="+h);

      fill(0, 0);
      // Sets the color and weight used to draw lines and borders around shapes.
      stroke(C_ROI_DATA_RECT_STROKE);
      strokeWeight(W_ROI_DATA_RECT_STROKE);
      rect(x, y, w, h);
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

class ROI_Point_Data {
  public int region;
  public int mi_x, mi_y;
  public int scr_x, scr_y;
  
  ROI_Point_Data(int region, int mi_x, int mi_y, int scr_x, int scr_y) {
    this.region = region;
    this.mi_x = mi_x;
    this.mi_y = mi_y;
    this.scr_x = scr_x;
    this.scr_y = scr_y;
  }
}

//final static boolean PRINT_ROI_OBJECT_DATA_ALL_DBG = true; 
final static boolean PRINT_ROI_OBJECT_DATA_ALL_DBG = false;
final static boolean PRINT_ROI_OBJECT_DATA_ALL_ERR = true; 
//final static boolean PRINT_ROI_OBJECT_DATA_ALL_ERR = false;

//final static boolean PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_DBG = true; 
final static boolean PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_DBG = false;
//final static boolean PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_ERR = true; 
final static boolean PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_ERR = false;

class ROI_Object_Data {
  public int region;
  public int mi_x_start, mi_y_start;
  public int mi_x_end, mi_y_end;
  public int scr_x_start, scr_y_start;
  public int scr_x_end, scr_y_end;
  
  ROI_Object_Data(int region, int mi_x_start, int mi_y_start, int mi_x_end, int mi_y_end, int scr_x_start, int scr_y_start, int scr_x_end, int scr_y_end) {
    if (PRINT_ROI_OBJECT_DATA_ALL_DBG || PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_DBG) println("ROI_Object_Data:constructor():"+"region="+region);
    if (PRINT_ROI_OBJECT_DATA_ALL_DBG || PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_DBG) println("ROI_Object_Data:constructor():"+"mi x="+mi_x_start+",y="+mi_y_start+",x="+mi_x_end+",y="+mi_y_end);
    if (PRINT_ROI_OBJECT_DATA_ALL_DBG || PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_DBG) println("ROI_Object_Data:constructor():"+"scr x="+scr_x_start+",y="+scr_y_start+",x="+scr_x_end+",y="+scr_y_end);

    this.region = region;
    this.mi_x_start = mi_x_start;
    this.mi_y_start = mi_y_start;
    this.mi_x_end = mi_x_end;
    this.mi_y_end = mi_y_end;
    this.scr_x_start = scr_x_start;
    this.scr_y_start = scr_y_start;
    this.scr_x_end = scr_x_end;
    this.scr_y_end = scr_y_end;
  }
}
