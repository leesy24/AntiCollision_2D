//final static boolean PRINT_ALERT_REGION_ALL_DBG = true; 
final static boolean PRINT_ALERT_REGION_ALL_DBG = false;

//final static boolean PRINT_ALERT_REGION_SETTINGS_DBG = true; 
final static boolean PRINT_ALERT_REGION_SETTINGS_DBG = false;

//final static boolean PRINT_ALERT_REGION_UPDATE_DBG = true; 
final static boolean PRINT_ALERT_REGION_UPDATE_DBG = false;

//final static boolean PRINT_ALERT_REGION_DRAW_DBG = true; 
final static boolean PRINT_ALERT_REGION_DRAW_DBG = false;

//final static boolean PRINT_ALERT_REGION_POINT_IS_CONTAINS_DBG = true; 
final static boolean PRINT_ALERT_REGION_POINT_IS_CONTAINS_DBG = false;

// Define default binary buf filename and path 
final static String ALERT_REGION_FILE_NAME = "alert_region";
final static String ALERT_REGION_FILE_EXT = ".csv";
static String Alert_Region_file_full_name;

static color C_ALERT_REGION_LINE = #000000;
static int W_ALERT_REGION_LINE = 3;

// A Table object
Table Alert_Region_table = null;

Lines[] Alert_Region_data;

int[] Alert_Region_mi_x;
int[] Alert_Region_mi_y;
int[] Alert_Region_mi_width;
int[] Alert_Region_mi_height;

void Alert_Region_settings()
{
  Alert_Region_data = new Lines[PS_INSTANCE_MAX];
  Alert_Region_mi_x = new int[PS_INSTANCE_MAX];
  Alert_Region_mi_y = new int[PS_INSTANCE_MAX];
  Alert_Region_mi_width = new int[PS_INSTANCE_MAX];
  Alert_Region_mi_height = new int[PS_INSTANCE_MAX];

  for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Alert_Region_file_full_name = ALERT_REGION_FILE_NAME + "_" + instance + ALERT_REGION_FILE_EXT;

    // Load lines file(CSV type) into a Table object
    // "header" option indicates the file has a header row
    Alert_Region_table = loadTable(Alert_Region_file_full_name, "header");
    // Check loadTable failed.
    if(Alert_Region_table == null)
    {
      return;
    }

    //println("Alert_Region_table.getRowCount()=" + Alert_Region_table.getRowCount());
    Alert_Region_data[instance] = new Lines(Alert_Region_table.getRowCount());
    if(Alert_Region_data[instance] == null)
    {
      return;
    }
    //println("Alert_Region_data[instance].length=" + Alert_Region_data[instance].length);

    int i = 0;
    String X, Y, Weight, Color;
    int x_min = MAX_INT, x_max = MIN_INT, y_min = MAX_INT, y_max = MIN_INT;

    for(TableRow variable : Alert_Region_table.rows())
    {
      X = variable.getString("X");
      Y = variable.getString("Y");
      Weight = variable.getString("Weight");
      Color = variable.getString("Color");
      //println("X="+X+",Y="+Y+",Weight="+Weight+",Color="+Color);

      if(X == null || Y == null)
      {
        continue;
      }

      if( X.toUpperCase().equals("CUT")
          ||
          Y.toUpperCase().equals("CUT")
        )
      {
        Alert_Region_data[instance].x[i] = MIN_INT;
        Alert_Region_data[instance].y[i] = MIN_INT;
        //println("Alert_Region_data[instance].x[" + i + "]=" + "CUT" + ",Alert_Region_data[instance].y[" + i + "]=" + "CUT");
      }
      else
      {
        // You can access the fields via their column name (or index)
        Alert_Region_data[instance].x[i] = variable.getInt("X") * 100;
        Alert_Region_data[instance].y[i] = variable.getInt("Y") * 100;

        // Get min/max of x/y.
        x_min = min(x_min, Alert_Region_data[instance].x[i]);
        x_max = max(x_max, Alert_Region_data[instance].x[i]);
        y_min = min(y_min, Alert_Region_data[instance].y[i]);
        y_max = max(y_max, Alert_Region_data[instance].y[i]);

        if(Weight == null)
        {
          Alert_Region_data[instance].w[i] = W_ALERT_REGION_LINE;
        }
        else
        {
          Alert_Region_data[instance].w[i] = variable.getInt("Weight");
        }
        if(Color == null)
        {
          Alert_Region_data[instance].c[i] = C_ALERT_REGION_LINE;
        }
        else
        {
          Alert_Region_data[instance].c[i] = (int)Long.parseLong(variable.getString("Color"), 16);
        }
        if (PRINT_ALERT_REGION_ALL_DBG || PRINT_ALERT_REGION_SETTINGS_DBG) println("Alert_Region_settings():Alert_Region_data["+instance+"].:x[" + i + "]=" + Alert_Region_data[instance].x[i] + ",y[" + i + "]=" + Alert_Region_data[instance].y[i] + ",w[" + i + "]=" + Alert_Region_data[instance].w[i] + ",c[" + i + "]=" + Alert_Region_data[instance].c[i]);
      }
      i ++;
    }
    for(; i < Alert_Region_data[instance].length; i ++)
    {
      Alert_Region_data[instance].x[i] = MIN_INT;
      Alert_Region_data[instance].y[i] = MIN_INT;
    }
    Alert_Region_mi_x[instance] = x_min;
    Alert_Region_mi_y[instance] = y_min;
    Alert_Region_mi_width[instance] = x_max - x_min;
    Alert_Region_mi_height[instance] = y_max - y_min;
    if (PRINT_ALERT_REGION_ALL_DBG || PRINT_ALERT_REGION_SETTINGS_DBG) println("Alert_Region_settings():Alert_Region_mi_["+instance+"]:x=" + Alert_Region_mi_x[instance] + ",y=" + Alert_Region_mi_y[instance] + ",width=" + Alert_Region_mi_width[instance] + ",height=" + Alert_Region_mi_height[instance]);
  }
}

void Alert_Region_setup()
{
  Alert_Region_update();
}

void Alert_Region_update()
{
  for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    if(Alert_Region_data[instance] == null) return;

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

    for (int i = 0; i < Alert_Region_data[instance].length; i ++)
    {
      coor_x = Alert_Region_data[instance].x[i];
      coor_y = Alert_Region_data[instance].y[i];
      if (PRINT_ALERT_REGION_UPDATE_DBG) println("Alert_Region_update():Alert_Region_data[instance][" + i + "],coor_x=" + coor_x + ",coor_y=" + coor_y);
      if (coor_x == MIN_INT || coor_y == MIN_INT)
      {
        // Save coordinate data for drawing line on screen. 
        Alert_Region_data[instance].scr_x[i] = MIN_INT;
        Alert_Region_data[instance].scr_y[i] = MIN_INT;
        continue;
      }

      if(ROTATE_FACTOR[instance] == 315)
      {
        x_curr = int(coor_y / ZOOM_FACTOR[instance]);
        y_curr = int(coor_x / ZOOM_FACTOR[instance]);
        x_curr += offset_x;
        if (MIRROR_ENABLE[instance])
          y_curr += offset_y;
        else
          y_curr = offset_y - y_curr;
      }
      else if(ROTATE_FACTOR[instance] == 45)
      {
        x_curr = int(coor_x / ZOOM_FACTOR[instance]);
        y_curr = int(coor_y / ZOOM_FACTOR[instance]);
        if (MIRROR_ENABLE[instance])
          x_curr = offset_x - x_curr;
        else
          x_curr += offset_x;
        y_curr += offset_y;
      }
      else if(ROTATE_FACTOR[instance] == 135)
      {
        x_curr = int(coor_y / ZOOM_FACTOR[instance]);
        y_curr = int(coor_x / ZOOM_FACTOR[instance]);
        x_curr = offset_x - x_curr; 
        if (MIRROR_ENABLE[instance])
          y_curr = offset_y - y_curr;
        else
          y_curr += offset_y;
      }
      else /*if(ROTATE_FACTOR[instance] == 225)*/
      {
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
      Alert_Region_data[instance].scr_x[i] = x_curr;
      Alert_Region_data[instance].scr_y[i] = y_curr;
    }
  }
}

void Alert_Region_draw()
{
  for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    if(Alert_Region_data[instance] == null) return;

    int x_curr, y_curr;
    int w_curr;
    color c_curr;
    int x_prev = MIN_INT, y_prev = MIN_INT;
    int w_prev = W_ALERT_REGION_LINE;
    color c_prev = C_ALERT_REGION_LINE;
    boolean drawed = false;

    for(int i = 0; i < Alert_Region_data[instance].length; i ++)
    {
      x_curr = Alert_Region_data[instance].scr_x[i];
      y_curr = Alert_Region_data[instance].scr_y[i];
      w_curr = Alert_Region_data[instance].w[i];
      c_curr = Alert_Region_data[instance].c[i];
      if (PRINT_ALERT_REGION_DRAW_DBG) println("Alert_Region_draw():Alert_Region_data[instance][" + i + "],x_curr=" + x_curr + ",y_curr=" + y_curr + ",w_curr=" + w_curr + ",c_curr=" + c_curr);
      if (x_curr == MIN_INT || y_curr == MIN_INT)
      {
        if(!drawed && x_prev != MIN_INT && y_prev != MIN_INT)
        {
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
      if(x_prev != MIN_INT && y_prev != MIN_INT)
      {
        fill(c_prev);
        // Sets the color and weight used to draw lines and borders around shapes.
        stroke(c_prev);
        strokeWeight(w_prev);
        line(x_prev, y_prev, x_curr, y_curr);
        drawed = true;
      }
      else
      {
        drawed = false;
      }
      // Save data for drawing line between previous and current points. 
      x_prev = x_curr;
      y_prev = y_curr;
      w_prev = w_curr;
      c_prev = c_curr;
    }

    if(!drawed && x_prev != MIN_INT && y_prev != MIN_INT)
    {
      fill(c_prev);
      // Sets the color and weight used to draw lines and borders around shapes.
      stroke(c_prev);
      strokeWeight(w_prev);
      point(x_prev, y_prev);
    }
  }
}

boolean Alert_Region_point_is_contains(int instance, int point_cm_x, int point_cm_y)
{
  if(Alert_Region_data[instance] == null) return true;

  if (PRINT_ALERT_REGION_ALL_DBG || PRINT_ALERT_REGION_POINT_IS_CONTAINS_DBG) println("Alert_Region_point_is_contains("+instance+"):point_cm_x=" + point_cm_x + ",point_cm_y=" + point_cm_y);

  if (
      point_cm_x >= Alert_Region_mi_x[instance]
      &&
      point_cm_x <= Alert_Region_mi_x[instance] + Alert_Region_mi_width[instance]
      &&
      point_cm_y >= Alert_Region_mi_y[instance]
      &&
      point_cm_y <= Alert_Region_mi_y[instance] + Alert_Region_mi_height[instance]
      )
  {
    if (PRINT_ALERT_REGION_ALL_DBG || PRINT_ALERT_REGION_POINT_IS_CONTAINS_DBG) println("Alert_Region_point_is_contains("+instance+"):return=" + true);
    return true;
  }
  else
  {
    if (PRINT_ALERT_REGION_ALL_DBG || PRINT_ALERT_REGION_POINT_IS_CONTAINS_DBG) println("Alert_Region_point_is_contains("+instance+"):return=" + false);
    return false;
  }
}
