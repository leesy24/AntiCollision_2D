//final static boolean PRINT_LINES_SETTINGS_DBG = true; 
final static boolean PRINT_LINES_SETTINGS_DBG = false;
//final static boolean PRINT_LINES_DRAW_DBG = true; 
final static boolean PRINT_LINES_DRAW_DBG = false;

// Define default binary buf filename and path 
final static String LINES_FILE_NAME = "lines";
final static String LINES_FILE_EXT = ".csv";
static String LINES_file_full_name;

static color C_LINES_LINE = #000000;
static int W_LINES_LINE = 3;

// A Table object
Table LINES_table = null;
class Lines {
  public int length;
  public int x[], y[], w[];
  public color c[];
  
  Lines (int n) {
    length = n;
    x = new int[n];
    y = new int[n];
    w = new int[n];
    c = new color[n];
  }
}
Lines[] LINES_data;

void lines_settings()
{
  LINES_data = new Lines[PS_INSTANCE_MAX];
  for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    LINES_file_full_name = LINES_FILE_NAME + "_" + instance + LINES_FILE_EXT;

    // Load lines file(CSV type) into a Table object
    // "header" option indicates the file has a header row
    LINES_table = loadTable(LINES_file_full_name, "header");
    // Check loadTable failed.
    if(LINES_table == null)
    {
      return;
    }

    //println("LINES_table.getRowCount()=" + LINES_table.getRowCount());
    LINES_data[instance] = new Lines(LINES_table.getRowCount());
    //println("LINES_data[instance].length=" + LINES_data[instance].length);

    int i = 0;
    String X, Y, Weight, Color;
    for(TableRow variable : LINES_table.rows())
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
        LINES_data[instance].x[i] = MIN_INT;
        LINES_data[instance].y[i] = MIN_INT;
        //println("LINES_data[instance].x[" + i + "]=" + "CUT" + ",LINES_data[instance].y[" + i + "]=" + "CUT");
      }
      else
      {
        // You can access the fields via their column name (or index)
        LINES_data[instance].x[i] = variable.getInt("X") * 100;
        LINES_data[instance].y[i] = variable.getInt("Y") * 100;
        if(Weight == null)
        {
          LINES_data[instance].w[i] = W_LINES_LINE;
        }
        else
        {
          LINES_data[instance].w[i] = variable.getInt("Weight");
        }
        if(Color == null)
        {
          LINES_data[instance].c[i] = C_LINES_LINE;
        }
        else
        {
          LINES_data[instance].c[i] = (int)Long.parseLong(variable.getString("Color"), 16);
        }
        if (PRINT_LINES_SETTINGS_DBG) println("LINES_data[instance].x[" + i + "]=" + LINES_data[instance].x[i] + ",LINES_data[instance].y[" + i + "]=" + LINES_data[instance].y[i] + ",LINES_data[instance].w[" + i + "]=" + LINES_data[instance].w[i] + ",LINES_data[instance].c[" + i + "]=" + LINES_data[instance].c[i]);
      }
      i ++;
    }
    for(; i < LINES_data[instance].length; i ++)
    {
      LINES_data[instance].x[i] = MIN_INT;
      LINES_data[instance].y[i] = MIN_INT;
    }
  }
}

void lines_draw()
{
  for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    if(LINES_data[instance] == null) return;

    int coor_x, coor_y;
    int x_curr, y_curr;
    int w_curr;
    color c_curr;
    int x_prev = MIN_INT, y_prev = MIN_INT;
    int w_prev = W_LINES_LINE;
    color c_prev = C_LINES_LINE;
    boolean drawed = false;
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

    for(int i = 0; i < LINES_data[instance].length; i ++)
    {
      coor_x = LINES_data[instance].x[i];
      coor_y = LINES_data[instance].y[i];
      w_curr = LINES_data[instance].w[i];
      c_curr = LINES_data[instance].c[i];
      if (PRINT_LINES_DRAW_DBG) println("LINES_data[instance][" + i + "],coor_x=" + coor_x + ",coor_y=" + coor_y + ",w_curr=" + w_curr + ",c_curr=" + c_curr);
      if( coor_x == MIN_INT 
          ||
          coor_y == MIN_INT
        )
      {
        if(!drawed && x_prev != MIN_INT && y_prev != MIN_INT)
        {
          fill(c_prev);
          // Sets the color and weight used to draw lines and borders around shapes.
          stroke(c_prev);
          strokeWeight(w_prev);
          point(x_prev + DRAW_OFFSET_X[instance], y_prev + DRAW_OFFSET_Y[instance]);
        }
        x_prev = MIN_INT;
        y_prev = MIN_INT;
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
      //println("coor_x=" + coor_x + ",coor_y=" + coor_y);
      //println("x_curr=" + x_curr + ",y_curr=" + y_curr + ",x_prev=" + x_prev + ",y_prev=" + y_prev);
      if(x_prev != MIN_INT && y_prev != MIN_INT)
      {
        fill(c_prev);
        // Sets the color and weight used to draw lines and borders around shapes.
        stroke(c_prev);
        strokeWeight(w_prev);
        line(x_prev + DRAW_OFFSET_X[instance], y_prev + DRAW_OFFSET_Y[instance], x_curr + DRAW_OFFSET_X[instance], y_curr + DRAW_OFFSET_Y[instance]);
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
      point(x_prev + DRAW_OFFSET_X[instance], y_prev + DRAW_OFFSET_Y[instance]);
    }
  }
}
