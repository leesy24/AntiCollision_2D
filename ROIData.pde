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

//final static boolean PRINT_ROI_DATA_SET_TIME_STAMP_DBG = true;
final static boolean PRINT_ROI_DATA_SET_TIME_STAMP_DBG = false;
//final static boolean PRINT_ROI_DATA_SET_TIME_STAMP_ERR = true;
final static boolean PRINT_ROI_DATA_SET_TIME_STAMP_ERR = false;

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

//final static boolean PRINT_ROI_DATA_DRAW_OBJECTS_DBG = true;
final static boolean PRINT_ROI_DATA_DRAW_OBJECTS_DBG = false;
//final static boolean PRINT_ROI_DATA_DRAW_OBJECTS_ERR = true;
final static boolean PRINT_ROI_DATA_DRAW_OBJECTS_ERR = false;

//final static boolean PRINT_ROI_DATA_DRAW_OBJECT_INFO_DBG = true;
final static boolean PRINT_ROI_DATA_DRAW_OBJECT_INFO_DBG = false;
//final static boolean PRINT_ROI_DATA_DRAW_OBJECT_INFO_ERR = true;
final static boolean PRINT_ROI_DATA_DRAW_OBJECT_INFO_ERR = false;

//final static boolean PRINT_ROI_DATA_GET_OBJECT_INDEX_OVER_XY_DBG = true;
final static boolean PRINT_ROI_DATA_GET_OBJECT_INDEX_OVER_XY_DBG = false;
//final static boolean PRINT_ROI_DATA_GET_OBJECT_INDEX_OVER_XY_ERR = true;
final static boolean PRINT_ROI_DATA_GET_OBJECT_INDEX_OVER_XY_ERR = false;

//final static boolean PRINT_ROI_DATA_CHECK_OBJECTS_OVERLAPPED_DBG = true;
final static boolean PRINT_ROI_DATA_CHECK_OBJECTS_OVERLAPPED_DBG = false;
//final static boolean PRINT_ROI_DATA_CHECK_OBJECTS_OVERLAPPED_ERR = true;
final static boolean PRINT_ROI_DATA_CHECK_OBJECTS_OVERLAPPED_ERR = false;

//final static boolean PRINT_ROI_DATA_ADD_OBJECTS_DBG = true;
final static boolean PRINT_ROI_DATA_ADD_OBJECTS_DBG = false;
//final static boolean PRINT_ROI_DATA_ADD_OBJECTS_ERR = true;
final static boolean PRINT_ROI_DATA_ADD_OBJECTS_ERR = false;

//final static boolean PRINT_ROI_DATA_ADD_OBJECT_DBG = true;
final static boolean PRINT_ROI_DATA_ADD_OBJECT_DBG = false;
//final static boolean PRINT_ROI_DATA_ADD_OBJECT_ERR = true;
final static boolean PRINT_ROI_DATA_ADD_OBJECT_ERR = false;

//final static boolean PRINT_ROI_DATA_PRINT_POINTS_DBG = true;
final static boolean PRINT_ROI_DATA_PRINT_POINTS_DBG = false;
//final static boolean PRINT_ROI_DATA_PRINT_POINTS_ERR = true;
final static boolean PRINT_ROI_DATA_PRINT_POINTS_ERR = false;

static color C_ROI_FAULT_MARKER_FILL = 0x40FF0000; // Red transparent
static color C_ROI_FAULT_MARKER_STROKE = 0xFFFF0000; // Red
static int W_ROI_FAULT_MARKER_STROKE = 5;

static color C_ROI_ALERT_MARKER_FILL = 0x40FFFF00; // Yellow transparent
static color C_ROI_ALERT_MARKER_STROKE = 0xFFFFFF00; // Yellow
static int W_ROI_ALERT_MARKER_STROKE = 5;

static int ROI_OBJECT_MARKER_MARGIN = 10;

//static int ROI_OBJECT_DISTANCE_LIMIT = 10000; // = 1 meter
static int ROI_OBJECT_DISTANCE_LIMIT = 5000; // = 50 cm= 0.5 meter

static int ROI_OBJECT_TIME_LIMIT = 500; // unit is milli-second(ms)

static int ROI_OBJECT_DRAW_INFO_TIMEOUT = 10000; // 10 seconds

static ROI_Data ROI_Data_handle = null;

static boolean[] ROI_Data_draw_info_enabled;
static int[] ROI_Data_draw_info_timer;
static int[] ROI_Data_draw_info_x;
static int[] ROI_Data_draw_info_y;
static boolean[] ROI_Data_mouse_over;
static int[] ROI_Data_mouse_over_object_index;
static boolean[] ROI_Data_mouse_pressed;

void ROI_Data_settings() {
  if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():Enter");

  ROI_Data_draw_info_enabled = new boolean[PS_INSTANCE_MAX];
  if (ROI_Data_draw_info_enabled == null)
  {
    if (PRINT_PS_DATA_ALL_ERR || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():ROI_Data_draw_info_enabled=null");
    return;
  }
  ROI_Data_draw_info_timer = new int[PS_INSTANCE_MAX];
  if (ROI_Data_draw_info_timer == null)
  {
    if (PRINT_PS_DATA_ALL_ERR || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():ROI_Data_draw_info_timer=null");
    return;
  }
  ROI_Data_draw_info_x = new int[PS_INSTANCE_MAX];
  if (ROI_Data_draw_info_x == null)
  {
    if (PRINT_PS_DATA_ALL_ERR || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():ROI_Data_draw_info_x=null");
    return;
  }
  ROI_Data_draw_info_y = new int[PS_INSTANCE_MAX];
  if (ROI_Data_draw_info_y == null)
  {
    if (PRINT_PS_DATA_ALL_ERR || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():ROI_Data_draw_info_y=null");
    return;
  }
  ROI_Data_mouse_over = new boolean[PS_INSTANCE_MAX];
  if (PS_Image == null)
  {
    if (PRINT_ROI_DATA_ALL_ERR || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():ROI_Data_mouse_over=null");
    return;
  }
  ROI_Data_mouse_over_object_index = new int[PS_INSTANCE_MAX];
  if (PS_Image == null)
  {
    if (PRINT_ROI_DATA_ALL_ERR || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():ROI_Data_mouse_over_object_index=null");
    return;
  }
  ROI_Data_mouse_pressed = new boolean[PS_INSTANCE_MAX];
  if (PS_Image == null)
  {
    if (PRINT_ROI_DATA_ALL_ERR || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():ROI_Data_mouse_pressed=null");
    return;
  }

  for (int i = 0; i < PS_INSTANCE_MAX; i++)
  {
    ROI_Data_draw_info_enabled[i] = false;
    ROI_Data_draw_info_timer[i] = millis();
    ROI_Data_mouse_over[i] = false;
    ROI_Data_mouse_over_object_index[i] = -1;
    ROI_Data_mouse_pressed[i] = false;
  }

  if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_SETTINGS_DBG) println("ROI_Data_settings():Exit");
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

void ROI_Data_mouse_pressed()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    ROI_Data_mouse_pressed[i] = false;
    if (ROI_Data_mouse_over[i])
    {
      ROI_Data_mouse_pressed[i] = true;
      ROI_Data_draw_info_x[i] = mouseX;
      ROI_Data_draw_info_y[i] = mouseY;
      ROI_Data_draw_info_enabled[i] = !ROI_Data_draw_info_enabled[i];
      if (ROI_Data_draw_info_enabled[i])
        ROI_Data_draw_info_timer[i] = millis();
    }
    else
    {
      int j;
      for (j = 0; j < PS_INSTANCE_MAX; j ++)
      {
        if (ROI_Data_mouse_over[j]) break;
      }
      if (j == PS_INSTANCE_MAX)
      {
        ROI_Data_draw_info_enabled[i] = false;
      }
    }
  }
}

void ROI_Data_mouse_released()
{
}

void ROI_Data_mouse_moved()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    int object_index;

    object_index = ROI_Data_handle.get_object_index_over_xy(i, mouseX, mouseY);
    if (object_index >= 0)
    {
      ROI_Data_mouse_over[i] = true;
      ROI_Data_mouse_over_object_index[i] = object_index;
      if (ROI_Data_draw_info_enabled[i])
        ROI_Data_draw_info_timer[i] = millis();
    }
    else
    {
      ROI_Data_mouse_over[i] = false;
    }
  }
}

void ROI_Data_mouse_dragged()
{
  ROI_Data_mouse_moved();
}

// A ROI_Data class
class ROI_Data {
  LinkedList<ROI_Point_Data>[] points_array = new LinkedList[PS_INSTANCE_MAX];
  LinkedList<ROI_Object_Data>[] objects_array = new LinkedList[PS_INSTANCE_MAX];
  int[] time_stamp_curr = new int[PS_INSTANCE_MAX];
  //long[] time_stamp_curr = new long[PS_INSTANCE_MAX];

  // Create the ROI_Data
  ROI_Data() {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CONSTRUCTOR_DBG) println("ROI_Data:constructor():Enter");
    for (int i = 0; i < PS_INSTANCE_MAX; i ++)
    {
      points_array[i] = new LinkedList<ROI_Point_Data>();
      objects_array[i] = new LinkedList<ROI_Object_Data>();
    }
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CONSTRUCTOR_DBG) println("ROI_Data:constructor():Exit");
  }

  void set_time_stamp(int instance, int time_stamp) {
  //void set_time_stamp(int instance, long time_stamp) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_SET_TIME_STAMP_DBG) println("ROI_Data:set_time_stamp("+instance+"):");
    int i = 0;
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_SET_TIME_STAMP_DBG) println("ROI_Data:set_time_stamp("+instance+"):"+"time_stamp="+time_stamp);
    time_stamp_curr[instance] = time_stamp;
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_SET_TIME_STAMP_DBG) println("ROI_Data:set_time_stamp("+instance+"):Exit");
  }

  void clear_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_points("+instance+"):Enter");
    int i = 0;
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_points("+instance+"):"+"points length="+points_array[instance].size());
    points_array[instance].clear();
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_points("+instance+"):Exit");
  }

  void clear_objects(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_objects("+instance+"):Enter");
    int i = 0;
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_objects("+instance+"):"+"objects length="+objects_array[instance].size());
    objects_array[instance].clear();
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CLEAR_POINTS_DBG) println("ROI_Data:clear_objects("+instance+"):Exit");
  }

  void add_point(int instance, int region, int mi_x, int mi_y, int scr_x, int scr_y) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_POINT_DBG) println("ROI_Data:add_points("+instance+"):Enter");
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_POINT_DBG) println("ROI_Data:add_points("+instance+"):"+"region="+region+",mi_x="+mi_x+",mi_y="+mi_y+",scr_x="+scr_x+",scr_y="+scr_y);
    points_array[instance].add(new ROI_Point_Data(region, mi_x, mi_y, scr_x, scr_y));
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_POINT_DBG) println("ROI_Data:add_points("+instance+"):Exit");
  }

  void detect_objects(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):Enter");
    if (points_array[instance].size() == 0) {
      if (PRINT_ROI_DATA_ALL_ERR || PRINT_ROI_DATA_ADD_OBJECTS_ERR) println("ROI_Data:detect_objects("+instance+"):"+"points size=0 error!");
      return;
    }

    LinkedList<ROI_Object_Data> objects = new LinkedList<ROI_Object_Data>();

    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"objects_array["+instance+"]="+objects_array[instance]);
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"objects="+objects);

    get_objects(objects, points_array[instance]);

    for (ROI_Object_Data object_new:objects) {
      //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects():"+"object_new["+objects.indexOf(object_new)+"]:"+"scr_x_start="+object_new.scr_x_start+",scr_y_start="+object_new.scr_y_start+",scr_x_end="+object_new.scr_x_end+",scr_y_end="+object_new.scr_y_end);
      object_new.time_stamp_start = object_new.time_stamp_last = time_stamp_curr[instance];
      for (ROI_Object_Data object_prev:objects_array[instance]) {
        //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects():"+"object_prev["+objects_array[instance].indexOf(object_prev)+"]:"+"scr_x_start="+object_prev.scr_x_start+",scr_y_start="+object_prev.scr_y_start+",scr_x_end="+object_prev.scr_x_end+",scr_y_end="+object_prev.scr_y_end);
        if (check_objects_overlapped(object_new, object_prev, ROI_OBJECT_MARKER_MARGIN)) {
          //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects():"+"object_prev["+objects_array[instance].indexOf(object_prev)+"]:"+"overlapped");
          object_new.time_stamp_start = object_prev.time_stamp_start;
        }
      }
    }

    boolean found;
    for (ROI_Object_Data object_prev:objects_array[instance]) {
      found = false;
      for (ROI_Object_Data object_new:objects) {
        if (check_objects_overlapped(object_prev, object_new, ROI_OBJECT_MARKER_MARGIN)) {
          found = true;
          break;
        }
      }
      if (!found) {
        int time_duration = object_prev.time_stamp_last - object_prev.time_stamp_start;
        //int time_duration = int(object_prev.time_stamp_last - object_prev.time_stamp_start);
        //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):"+"time_duration="+time_duration);
        //println("ROI_Data:detect_objects("+instance+"):"+"time_duration="+time_duration);
        if (time_duration >= ROI_OBJECT_TIME_LIMIT) {
        //if (object_prev.time_stamp_last - object_prev.time_stamp_start >= ROI_OBJECT_TIME_LIMIT*2L) {
          if (time_duration > ROI_OBJECT_TIME_LIMIT * W_ROI_FAULT_MARKER_STROKE) {
            object_prev.time_stamp_start = object_prev.time_stamp_last - ROI_OBJECT_TIME_LIMIT * W_ROI_FAULT_MARKER_STROKE;
          }
          else {
            object_prev.time_stamp_start -= object_prev.time_stamp_last - time_stamp_curr[instance];
          }
          objects.add(object_prev);
        }
      }
    }

    objects_array[instance] = objects;

    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DETECT_OBJECTS_DBG) println("ROI_Data:detect_objects("+instance+"):Exit");
  }

  /*
  void print_points(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_PRINT_POINTS_DBG) println("ROI_Data:print_points("+instance+"):");
    int i = 0;
    println("ROI_Data:print_points("+instance+"):"+"points length="+points_array[instance].size());
    for (ROI_Point_Data point:points_array[instance]) {
      println("ROI_Data:print_points("+instance+"):"+"point["+i+++"]:"+"region="+point.region+",mi_x="+point.mi_x+",mi_y="+point.mi_y+",scr_x="+point.scr_x+",scr_y="+point.scr_y);
    }
  }
  */

  void draw_objects(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECTS_DBG) println("ROI_Data:draw_objects("+instance+"):Enter");
    for (ROI_Object_Data object:objects_array[instance]) {
      //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECTS_DBG) println("ROI_Data:draw_objects("+instance+"):"+"x="+object.scr_x_start+",y="+object.scr_y_start+",w="+object.scr_width+",h="+object.scr_height);
      //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECTS_DBG) println("ROI_Data:draw_objects("+instance+"):"+"x_c="+object.scr_x_center+",y_c="+object.scr_y_center+",d="+object.scr_diameter);
      //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECTS_DBG) println("ROI_Data:draw_objects("+instance+"):"+"time_stamp_start="+object.time_stamp_start+",time_stamp_last="+object.time_stamp_last);

      int time_duration = object.time_stamp_last - object.time_stamp_start;
      //int time_duration = int(object.time_stamp_last - object.time_stamp_start);
      int weight;

      //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECTS_DBG) println("ROI_Data:draw_objects("+instance+"):"+"time_duration="+time_duration);
      //println("ROI_Data:draw_objects("+instance+"):"+"time_duration="+time_duration);

      if (time_duration < ROI_OBJECT_TIME_LIMIT) {
        if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECTS_DBG) println("ROI_Data:draw_objects("+instance+"):"+"time_duration="+time_duration);
        continue;
      }
      weight = 1 * time_duration / ROI_OBJECT_TIME_LIMIT;
      if (object.region == 0) { // Fault region
        weight = min(weight, W_ROI_FAULT_MARKER_STROKE);
        fill(C_ROI_FAULT_MARKER_FILL);
        // Sets the color and weight used to draw lines and borders around shapes.
        stroke(C_ROI_FAULT_MARKER_STROKE);
        strokeWeight(weight);
      }
      else { // Alert region
        weight = min(weight, W_ROI_FAULT_MARKER_STROKE);
        fill(C_ROI_ALERT_MARKER_FILL);
        // Sets the color and weight used to draw lines and borders around shapes.
        stroke(C_ROI_ALERT_MARKER_STROKE);
        strokeWeight(weight);
      }
      /*
      rect( object.scr_x_start - ROI_OBJECT_MARKER_MARGIN,
            object.scr_y_start - ROI_OBJECT_MARKER_MARGIN,
            object.scr_width + ROI_OBJECT_MARKER_MARGIN*2,
            object.scr_height + ROI_OBJECT_MARKER_MARGIN*2);
      */
      ellipse(object.scr_x_center,
              object.scr_y_center,
              object.scr_diameter + ROI_OBJECT_MARKER_MARGIN*2,
              object.scr_diameter + ROI_OBJECT_MARKER_MARGIN*2);
    }
    //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECTS_DBG) println("ROI_Data:draw_objects("+instance+"):Exit");
  }

  void draw_object_info(int instance) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECT_INFO_DBG) println("ROI_Data:draw_object_info("+instance+"):Enter");

    if(!ROI_Data_draw_info_enabled[instance]) return;

    if(objects_array[instance].size() <= ROI_Data_mouse_over_object_index[instance]) return;

    if((millis() - ROI_Data_draw_info_timer[instance]) >= ROI_OBJECT_DRAW_INFO_TIMEOUT)
    {
      ROI_Data_draw_info_enabled[instance] = false;
    }

    ROI_Object_Data object;

    object = objects_array[instance].get(ROI_Data_mouse_over_object_index[instance]);

    if( ROI_Data_draw_info_x[instance] < object.scr_x_start - ROI_OBJECT_MARKER_MARGIN
        ||
        ROI_Data_draw_info_x[instance] > object.scr_x_end + ROI_OBJECT_MARKER_MARGIN
        || 
        ROI_Data_draw_info_y[instance] < object.scr_y_start - ROI_OBJECT_MARKER_MARGIN
        ||
        ROI_Data_draw_info_y[instance] > object.scr_y_end + ROI_OBJECT_MARKER_MARGIN
      ) {
      return;
    }

    ROI_Data_draw_info_x[instance] = object.scr_x_center;
    ROI_Data_draw_info_y[instance] = object.scr_y_center;

    LinkedList<String> strings = new LinkedList<String>();

    strings.add("Region:" + object.region);
    strings.add("Time dur.:" + ((object.time_stamp_last - object.time_stamp_start)/1000.0) + "s");
    strings.add("Coord. X:" + ((object.mi_x_center/10)/1000.0) + "m");
    strings.add("Coord. Y:" + ((object.mi_y_center/10)/1000.0) + "m");

    // Get max string width
    textSize(FONT_HEIGHT);
    int witdh_max = 0;
    for (String string:strings)
    {
      witdh_max = max(witdh_max, int(textWidth(string)));    
    }

    int rect_w, rect_h;
    int rect_x, rect_y;
    int rect_tl = 5, rect_tr = 5, rect_br = 5, rect_bl = 5;
    if (ROTATE_FACTOR[instance] == 315) {
      if (MIRROR_ENABLE[instance]) { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = object.scr_x_center;
        rect_y = object.scr_y_center;
        rect_tl = 0;
      }
      else { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = object.scr_x_center;
        rect_y = object.scr_y_center - rect_h - 1;
        rect_bl = 0;
      }
    }
    else if (ROTATE_FACTOR[instance] == 45) {
      if (MIRROR_ENABLE[instance]) { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = object.scr_x_center - rect_w - 1;
        rect_y = object.scr_y_center;
        rect_tr = 0;
      }
      else { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = object.scr_x_center;
        rect_y = object.scr_y_center;
        rect_tl = 0;
      }
    }
    else if (ROTATE_FACTOR[instance] == 135) {
      if (MIRROR_ENABLE[instance]) { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = object.scr_x_center - rect_w - 1;
        rect_y = object.scr_y_center - rect_h - 1;
        rect_br = 0;
      }
      else { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = object.scr_x_center - rect_w - 1;
        rect_y = object.scr_y_center;
        rect_tr = 0;
      }
    }
    else /*if (ROTATE_FACTOR[instance] == 225)*/ {
      if (MIRROR_ENABLE[instance]) { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = object.scr_x_center;
        rect_y = object.scr_y_center - rect_h - 1;
        rect_bl = 0;
      }
      else { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = object.scr_x_center - rect_w - 1;
        rect_y = object.scr_y_center - rect_h - 1;
        rect_br = 0;
      }
    }

    // Draw rect
    fill(C_PS_DATA_RECT_FILL);
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(C_PS_DATA_RECT_STROKE);
    strokeWeight(W_PS_DATA_RECT_STROKE);
    rect(rect_x, rect_y, rect_w, rect_h, rect_tl, rect_tr, rect_br, rect_bl);

    // Sets the color used to draw lines and borders around shapes.
    fill(C_PS_DATA_RECT_TEXT);
    stroke(C_PS_DATA_RECT_TEXT);
    textAlign(LEFT, BASELINE);
    final int str_x = rect_x + TEXT_MARGIN;
    final int str_y = rect_y + TEXT_MARGIN - 1;
    int cnt = 0;
    for( String string:strings)
    {
      text(string, str_x, str_y + FONT_HEIGHT * (1 + cnt++));
    }

    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_DRAW_OBJECT_INFO_DBG) println("ROI_Data:draw_object_info("+instance+"):Enter");
  }

  int get_object_index_over_xy(int instance, int x, int y) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GET_OBJECT_INDEX_OVER_XY_DBG) println("ROI_Data:get_object_index_over_xy():Enter");

    int i;

    for (i = objects_array[instance].size() - 1; i >= 0 ; i --) {
      ROI_Object_Data object;
      object = objects_array[instance].get(i);
      if( x >= object.scr_x_start - ROI_OBJECT_MARKER_MARGIN
          &&
          x <= object.scr_x_end + ROI_OBJECT_MARKER_MARGIN
          && 
          y >= object.scr_y_start - ROI_OBJECT_MARKER_MARGIN
          &&
          y <= object.scr_y_end + ROI_OBJECT_MARKER_MARGIN
        ) {
        break;
      }
    }

    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GET_OBJECT_INDEX_OVER_XY_DBG) println("ROI_Data:get_object_index_over_xy():index="+i);

    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_GET_OBJECT_INDEX_OVER_XY_DBG) println("ROI_Data:get_object_index_over_xy():Exit");

    return i;
  }

  private boolean check_objects_overlapped(ROI_Object_Data object_a, ROI_Object_Data object_b, int margin) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CHECK_OBJECTS_OVERLAPPED_DBG) println("ROI_Data:check_objects_overlapped():Enter");
    boolean ret = false;

    if( object_a.scr_x_start >= object_b.scr_x_start - margin
        &&
        object_a.scr_x_start <= object_b.scr_x_end + margin
        && 
        object_a.scr_y_start >= object_b.scr_y_start - margin
        &&
        object_a.scr_y_start <= object_b.scr_y_end + margin
      ) {
      ret = true;
    }
    if( object_a.scr_x_end >= object_b.scr_x_start - margin
        &&
        object_a.scr_x_end <= object_b.scr_x_end + margin
        && 
        object_a.scr_y_end >= object_b.scr_y_start - margin
        &&
        object_a.scr_y_end <= object_b.scr_y_end + margin
      ) {
      ret = true;
    }
    if( object_b.scr_x_start >= object_a.scr_x_start - margin
        &&
        object_b.scr_x_start <= object_a.scr_x_end + margin
        && 
        object_b.scr_y_start >= object_a.scr_y_start - margin
        &&
        object_b.scr_y_start <= object_a.scr_y_end + margin
      ) {
      ret = true;
    }
    if( object_b.scr_x_end >= object_a.scr_x_start - margin
        &&
        object_b.scr_x_end <= object_a.scr_x_end + margin
        && 
        object_b.scr_y_end >= object_a.scr_y_start - margin
        &&
        object_b.scr_y_end <= object_a.scr_y_end + margin
      ) {
      ret = true;
    }

    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_CHECK_OBJECTS_OVERLAPPED_DBG) println("ROI_Data:check_objects_overlapped():Exit");

    return ret;
  }

  private void get_objects(LinkedList<ROI_Object_Data> objects, LinkedList<ROI_Point_Data> points) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:get_objects():Enter");
    if (points.size() == 0) {
      if (PRINT_ROI_DATA_ALL_ERR || PRINT_ROI_DATA_ADD_OBJECTS_ERR) println("ROI_Data:get_objects():"+"points size=0 error!");
      return;
    }

    do {
      LinkedList<ROI_Point_Data> points_group = new LinkedList<ROI_Point_Data>();
      ROI_Point_Data point_curr;
      ROI_Point_Data point_prev;

      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:get_objects():"+"points size="+points.size());
      point_prev = points.get(0);
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:get_objects():"+"point_prev["+0+"]:"+"region="+point_prev.region+",mi_x="+point_prev.mi_x+",mi_y="+point_prev.mi_y+",scr_x="+point_prev.scr_x+",scr_y="+point_prev.scr_y);
      points_group.add(point_prev);
      points.remove(0);
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:get_objects():"+"points size="+points.size());
      for (int i = 0; i < points.size();) {
        int distance;
        point_curr = points.get(i);
        if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:get_objects():"+"point_curr["+i+"]:"+"region="+point_curr.region+",mi_x="+point_curr.mi_x+",mi_y="+point_curr.mi_y+",scr_x="+point_curr.scr_x+",scr_y="+point_curr.scr_y);
        distance = get_points_distance(point_prev.mi_x, point_prev.mi_y, point_curr.mi_x, point_curr.mi_y);
        //if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:detect_objects():"+"distance="+distance);
        if (distance <= ROI_OBJECT_DISTANCE_LIMIT) {
          points_group.add(point_curr);
          points.remove(i);
          point_prev = point_curr;
        }
        else {
          i ++;
        }
      }
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:get_objects():"+"points_group size="+points_group.size());
      add_object(objects, points_group);
      points_group.clear();
      if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:get_objects():"+"points size="+points.size());
    } while (points.size() != 0);
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECTS_DBG) println("ROI_Data:get_objects():Exit");
  }

  private void add_object(LinkedList<ROI_Object_Data> objects, LinkedList<ROI_Point_Data> points_group) {
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECT_DBG) println("ROI_Data:add_object():Enter");

    int region_min;
    int mi_x_min, mi_y_min, mi_x_max, mi_y_max;
    int scr_x_min, scr_y_min, scr_x_max, scr_y_max;

    region_min = MAX_INT;
    mi_x_min = mi_y_min = scr_x_min = scr_y_min = MAX_INT;
    mi_x_max = mi_y_max = scr_x_max = scr_y_max = MIN_INT;

    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECT_DBG) println("ROI_Data:add_object():"+"points_group size="+points_group.size());
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
    objects.add(
      new ROI_Object_Data(
        region_min,
        mi_x_min, mi_y_min,
        mi_x_max, mi_y_max,
        scr_x_min, scr_y_min,
        scr_x_max, scr_y_max));
    if (PRINT_ROI_DATA_ALL_DBG || PRINT_ROI_DATA_ADD_OBJECT_DBG) println("ROI_Data:add_object():Exit");
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
  public int mi_x_center, mi_y_center;
  public int scr_x_start, scr_y_start;
  public int scr_x_end, scr_y_end;
  public int scr_width, scr_height;
  public int scr_x_center, scr_y_center;
  public int scr_diameter;
  public int time_stamp_start;
  public int time_stamp_last;
  //public long time_stamp_start;
  //public long time_stamp_last;
  
  ROI_Object_Data(int region, int mi_x_start, int mi_y_start, int mi_x_end, int mi_y_end, int scr_x_start, int scr_y_start, int scr_x_end, int scr_y_end) {
    if (PRINT_ROI_OBJECT_DATA_ALL_DBG || PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_DBG) println("ROI_Object_Data:constructor():"+"region="+region);
    if (PRINT_ROI_OBJECT_DATA_ALL_DBG || PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_DBG) println("ROI_Object_Data:constructor():"+"mi x="+mi_x_start+",y="+mi_y_start+",x="+mi_x_end+",y="+mi_y_end);
    if (PRINT_ROI_OBJECT_DATA_ALL_DBG || PRINT_ROI_OBJECT_DATA_CONSTRUCTOR_DBG) println("ROI_Object_Data:constructor():"+"scr x="+scr_x_start+",y="+scr_y_start+",x="+scr_x_end+",y="+scr_y_end);

    this.region = region;
    this.mi_x_start = mi_x_start;
    this.mi_y_start = mi_y_start;
    this.mi_x_end = mi_x_end;
    this.mi_y_end = mi_y_end;
    this.mi_x_center = mi_x_start + (mi_x_end - mi_x_start) / 2;
    this.mi_y_center = mi_y_start + (mi_y_end - mi_y_start) / 2;
    this.scr_x_start = scr_x_start;
    this.scr_y_start = scr_y_start;
    this.scr_x_end = scr_x_end;
    this.scr_y_end = scr_y_end;
    this.scr_width = scr_x_end - scr_x_start;
    this.scr_height = scr_y_end - scr_y_start;
    this.scr_x_center = scr_x_start + this.scr_width / 2;
    this.scr_y_center = scr_y_start + this.scr_height / 2;
    this.scr_diameter = int(sqrt(sq(scr_x_end - scr_x_start) + sq(scr_y_end - scr_y_start)));
  }
}
