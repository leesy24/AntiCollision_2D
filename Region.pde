//final static boolean PRINT_REGION_ALL_DBG = true; 
final static boolean PRINT_REGION_ALL_DBG = false;

//final static boolean PRINT_REGION_SETTINGS_DBG = true; 
final static boolean PRINT_REGION_SETTINGS_DBG = false;

//final static boolean PRINT_REGION_UPDATE_DBG = true; 
final static boolean PRINT_REGION_UPDATE_DBG = false;

//final static boolean PRINT_REGION_DRAW_DBG = true; 
final static boolean PRINT_REGION_DRAW_DBG = false;

//final static boolean PRINT_REGION_POINT_IS_CONTAINS_DBG = true; 
final static boolean PRINT_REGION_POINT_IS_CONTAINS_DBG = false;

// Define default binary buf filename and path 
final static String REGION_FAULT_FILE_NAME = "fault_region";
final static String REGION_FAULT_FILE_EXT = ".csv";

static color C_REGION_FAULT_DEFAULT_LINE = #000000;
static int W_REGION_FAULT_DEFAULT_LINE = 3;

final static String REGION_ALERT_FILE_NAME = "alert_region";
final static String REGION_ALERT_FILE_EXT = ".csv";

static color C_REGION_ALERT_DEFAULT_LINE = #000000;
static int W_REGION_ALERT_DEFAULT_LINE = 3;

Region Region_Fault_handle;
Region Region_Alert_handle;

final static int Region_Fault = 0;
final static int Region_Alert = 1;

final static String[] Region_name = {"Fault", "Alert"};


void Region_settings()
{
  Region_Fault_handle = new Region(REGION_FAULT_FILE_NAME, REGION_FAULT_FILE_EXT, C_REGION_FAULT_DEFAULT_LINE, W_REGION_FAULT_DEFAULT_LINE);
  Region_Alert_handle = new Region(REGION_ALERT_FILE_NAME, REGION_ALERT_FILE_EXT, C_REGION_ALERT_DEFAULT_LINE, W_REGION_ALERT_DEFAULT_LINE);
}

void Region_setup()
{
  Region_Fault_handle.setup();
  Region_Alert_handle.setup();
}

void Region_update()
{
  Region_Fault_handle.update();
  Region_Alert_handle.update();
}

void Region_draw()
{
  Region_Fault_handle.draw();
  Region_Alert_handle.draw();
}

class Region {
  Points_Data[] points_data = new Points_Data[PS_INSTANCE_MAX];
  int[] mi_x = new int[PS_INSTANCE_MAX];
  int[] mi_y = new int[PS_INSTANCE_MAX];
  int[] mi_width = new int[PS_INSTANCE_MAX];
  int[] mi_height = new int[PS_INSTANCE_MAX];

  Region(String file_name, String file_ext, color defult_line_color, int default_line_weight) {
    for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++) {
      String file_full_name;
      Table table;

      file_full_name = file_name + "_" + instance + file_ext;

      // Load lines file(CSV type) into a Table object
      // "header" option indicates the file has a header row
      table = loadTable(file_full_name, "header");
      // Check loadTable failed.
      if(table == null) {
        return;
      }

      //println("table.getRowCount()=" + table.getRowCount());
      points_data[instance] = new Points_Data(table.getRowCount());
      if(points_data[instance] == null) {
        return;
      }
      //println("points_data[instance].length=" + points_data[instance].length);

      int i = 0;
      String X, Y, Weight, Color;
      int x_min = MAX_INT, x_max = MIN_INT, y_min = MAX_INT, y_max = MIN_INT;

      for (TableRow variable:table.rows()) {
        X = variable.getString("X");
        Y = variable.getString("Y");
        Weight = variable.getString("Weight");
        Color = variable.getString("Color");
        //println("X="+X+",Y="+Y+",Weight="+Weight+",Color="+Color);

        if (X == null || Y == null) {
          continue;
        }

        if (X.toUpperCase().equals("CUT")
            ||
            Y.toUpperCase().equals("CUT")) {
          points_data[instance].x[i] = MIN_INT;
          points_data[instance].y[i] = MIN_INT;
          //println("points_data[instance].x[" + i + "]=" + "CUT" + ",points_data[instance].y[" + i + "]=" + "CUT");
        }
        else {
          // You can access the fields via their column name (or index)
          points_data[instance].x[i] = variable.getInt("X") * 100;
          points_data[instance].y[i] = variable.getInt("Y") * 100;

          // Get min/max of x/y.
          x_min = min(x_min, points_data[instance].x[i]);
          x_max = max(x_max, points_data[instance].x[i]);
          y_min = min(y_min, points_data[instance].y[i]);
          y_max = max(y_max, points_data[instance].y[i]);

          if (Weight == null) {
            points_data[instance].w[i] = defult_line_color;
          }
          else {
            points_data[instance].w[i] = variable.getInt("Weight");
          }
          if (Color == null) {
            points_data[instance].c[i] = defult_line_color;
          }
          else {
            points_data[instance].c[i] = (int)Long.parseLong(variable.getString("Color"), 16);
          }
          if (PRINT_REGION_ALL_DBG || PRINT_REGION_SETTINGS_DBG) println("Region:settings():points_data["+instance+"].:x[" + i + "]=" + points_data[instance].x[i] + ",y[" + i + "]=" + points_data[instance].y[i] + ",w[" + i + "]=" + points_data[instance].w[i] + ",c[" + i + "]=" + points_data[instance].c[i]);
        }
        i ++;
      }
      for (; i < points_data[instance].length; i ++) {
        points_data[instance].x[i] = MIN_INT;
        points_data[instance].y[i] = MIN_INT;
      }
      mi_x[instance] = x_min;
      mi_y[instance] = y_min;
      mi_width[instance] = x_max - x_min;
      mi_height[instance] = y_max - y_min;
      if (PRINT_REGION_ALL_DBG || PRINT_REGION_SETTINGS_DBG) println("Region:settings():mi_["+instance+"]:x=" + mi_x[instance] + ",y=" + mi_y[instance] + ",width=" + mi_width[instance] + ",height=" + mi_height[instance]);
    }
  }

  void setup()
  {
    update();
  }

  void update()
  {
    for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++) {
      update_instance(instance);
    }
  }

  void update_instance(int instance)
  {
    if (points_data[instance] == null) return;

    int coor_x, coor_y;
    int x_curr, y_curr;
    final int offset_x =
      (ROTATE_FACTOR[instance] == 315)
      ?
      (TEXT_MARGIN + FONT_HEIGHT / 2)
      :
      (
        (ROTATE_FACTOR[instance] == 135)
        ?
        (SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT / 2))
        :
        (SCREEN_width / 2)
      );
    final int offset_y =
      (ROTATE_FACTOR[instance] == 45)
      ?
      (TEXT_MARGIN + FONT_HEIGHT / 2)
      :
      (
        (ROTATE_FACTOR[instance] == 225)
        ?
        (SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT / 2))
        :
        (SCREEN_height / 2)
      );

    for (int i = 0; i < points_data[instance].length; i ++) {
      coor_x = points_data[instance].x[i];
      coor_y = points_data[instance].y[i];
      if (PRINT_REGION_UPDATE_DBG) println("update("+instance+"):points_data[" + i + "],coor_x=" + coor_x + ",coor_y=" + coor_y);
      if (coor_x == MIN_INT || coor_y == MIN_INT) {
        // Save coordinate data for drawing line on screen. 
        points_data[instance].scr_x[i] = MIN_INT;
        points_data[instance].scr_y[i] = MIN_INT;
        continue;
      }

      if (ROTATE_FACTOR[instance] == 315) {
        x_curr = int(coor_y / ZOOM_FACTOR[instance]);
        y_curr = int(coor_x / ZOOM_FACTOR[instance]);
        x_curr += offset_x;
        if (MIRROR_ENABLE[instance])
          y_curr += offset_y;
        else
          y_curr = offset_y - y_curr;
      }
      else if (ROTATE_FACTOR[instance] == 45) {
        x_curr = int(coor_x / ZOOM_FACTOR[instance]);
        y_curr = int(coor_y / ZOOM_FACTOR[instance]);
        if (MIRROR_ENABLE[instance])
          x_curr = offset_x - x_curr;
        else
          x_curr += offset_x;
        y_curr += offset_y;
      }
      else if (ROTATE_FACTOR[instance] == 135) {
        x_curr = int(coor_y / ZOOM_FACTOR[instance]);
        y_curr = int(coor_x / ZOOM_FACTOR[instance]);
        x_curr = offset_x - x_curr; 
        if (MIRROR_ENABLE[instance])
          y_curr = offset_y - y_curr;
        else
          y_curr += offset_y;
      }
      else /*if(ROTATE_FACTOR[instance] == 225)*/ {
        x_curr = int(coor_x / ZOOM_FACTOR[instance]);
        y_curr = int(coor_y / ZOOM_FACTOR[instance]);
        if (MIRROR_ENABLE[instance])
          x_curr += offset_x;
        else
          x_curr = offset_x - x_curr;
        y_curr = offset_y - y_curr;
      }
      x_curr += DRAW_OFFSET_X[instance];
      y_curr += DRAW_OFFSET_Y[instance];

      // Save coordinate data for drawing line on screen. 
      points_data[instance].scr_x[i] = x_curr;
      points_data[instance].scr_y[i] = y_curr;
    }
  }

  void draw()
  {
    for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++) {
      draw_instance(instance);
    }
  }

  void draw_instance(int instance)
  {
    if (points_data[instance] == null) return;

    int x_curr, y_curr;
    int w_curr;
    color c_curr;
    int x_prev = MIN_INT, y_prev = MIN_INT;
    int w_prev = W_REGION_FAULT_DEFAULT_LINE;
    color c_prev = C_REGION_FAULT_DEFAULT_LINE;
    boolean drawed = false;

    for (int i = 0; i < points_data[instance].length; i ++) {
      x_curr = points_data[instance].scr_x[i];
      y_curr = points_data[instance].scr_y[i];
      w_curr = points_data[instance].w[i];
      c_curr = points_data[instance].c[i];
      if (PRINT_REGION_DRAW_DBG) println("Region:draw_instance("+instance+"):points_data[" + i + "],x_curr=" + x_curr + ",y_curr=" + y_curr + ",w_curr=" + w_curr + ",c_curr=" + c_curr);
      if (x_curr == MIN_INT || y_curr == MIN_INT) {
        if (!drawed && x_prev != MIN_INT && y_prev != MIN_INT) {
          fill(c_prev);
          // Sets the color and weight used to draw lines and borders around shapes.
          stroke(c_prev);
          strokeWeight(w_prev);
          point(x_prev, y_prev);
        }
        x_prev = MIN_INT;
        y_prev = MIN_INT;
        continue;
      }

      //println("coor_x=" + coor_x + ",coor_y=" + coor_y);
      //println("x_curr=" + x_curr + ",y_curr=" + y_curr + ",x_prev=" + x_prev + ",y_prev=" + y_prev);
      if (x_prev != MIN_INT && y_prev != MIN_INT) {
        fill(c_prev);
        // Sets the color and weight used to draw lines and borders around shapes.
        stroke(c_prev);
        strokeWeight(w_prev);
        line(x_prev, y_prev, x_curr, y_curr);
        drawed = true;
      }
      else {
        drawed = false;
      }
      // Save data for drawing line between previous and current points. 
      x_prev = x_curr;
      y_prev = y_curr;
      w_prev = w_curr;
      c_prev = c_curr;
    }

    if (!drawed && x_prev != MIN_INT && y_prev != MIN_INT) {
      fill(c_prev);
      // Sets the color and weight used to draw lines and borders around shapes.
      stroke(c_prev);
      strokeWeight(w_prev);
      point(x_prev, y_prev);
    }
  }

  boolean point_is_over(int instance, int point_mi_x, int point_mi_y)
  {
    if (points_data[instance] == null) return true;

    boolean ret = false;

    if (PRINT_REGION_ALL_DBG || PRINT_REGION_POINT_IS_CONTAINS_DBG) println("point_is_over("+instance+"):point_mi_x=" + point_mi_x + ",point_mi_y=" + point_mi_y);

    if (is_point_over_rect(
          point_mi_x, point_mi_y,
          mi_x[instance], mi_y[instance], mi_width[instance], mi_height[instance])) {
      ret = true;
    }

    if (PRINT_REGION_ALL_DBG || PRINT_REGION_POINT_IS_CONTAINS_DBG) println("point_is_over("+instance+"):return=" + ret);

    return ret;
  }
}
