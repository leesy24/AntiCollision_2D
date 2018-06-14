// Define default binary buf filename and path 
final static String LINES_FILE_NAME = "lines";
final static String LINES_FILE_EXT = ".csv";
static String LINES_file_full_name;

static color C_LINES_LINE = #000000;
static int W_LINES_LINE = 3;

// A Table object
static Table LINES_table = null;
int[][] LINES_points;

void lines_settings()
{
  // This is for argument passed number of config file.
  /*
  if(CONFIG_instance_number != null) {
    LINES_file_full_name = LINES_FILE_NAME + "_" + CONFIG_instance_number + LINES_FILE_EXT;
  }
  else {
    LINES_file_full_name = LINES_FILE_NAME + LINES_FILE_EXT;
  }
  */
  LINES_file_full_name = LINES_FILE_NAME + LINES_FILE_EXT;

  // Load lines file(CSV type) into a Table object
  // "header" option indicates the file has a header row
  LINES_table = loadTable(LINES_file_full_name, "header");
  // Check loadTable failed.
  if(LINES_table == null)
  {
    // This is for argument passed number of config file.
	/*
    if(CONFIG_instance_number == null)
    {
      return;
    }
	*/

    // Load default lines file.
    LINES_file_full_name = LINES_FILE_NAME + LINES_FILE_EXT;
    LINES_table = loadTable(LINES_file_full_name, "header");
    // Check loadTable failed.
    if(LINES_table == null)
    {
      return;
    }
  }

  //println("LINES_table.getRowCount()=" + LINES_table.getRowCount());
  LINES_points = new int[LINES_table.getRowCount()][3];
  //println("LINES_points.length=" + LINES_points.length);

  int i = 0;
  String X, Y, Weight;
  for(TableRow variable : LINES_table.rows())
  {
    X = variable.getString("X");
    Y = variable.getString("Y");
	Weight = variable.getString("Weight");
    //println("X="+X+",Y="+Y);

    if(X == null || Y == null)
    {
      continue;
    }

    if( X.toUpperCase().equals("CUT")
        ||
        Y.toUpperCase().equals("CUT")
      )
    {
      LINES_points[i][0] = MIN_INT;
      LINES_points[i][1] = MIN_INT;
      //println("LINES_points[" + i + "].x=" + "CUT" + ",LINES_points[" + i + "].y=" + "CUT");
    }
    else
    {
      // You can access the fields via their column name (or index)
      LINES_points[i][0] = variable.getInt("X") * 100;
      LINES_points[i][1] = variable.getInt("Y") * 100;
      //println("LINES_points[" + i + "].x=" + LINES_points[i][0] + ",LINES_points[" + i + "].y=" + LINES_points[i][1]);
      if(Weight == null)
      {
        LINES_points[i][2] = W_LINES_LINE;
      }
	  else
      {
        LINES_points[i][2] = variable.getInt("Weight");
      }
    }
    i ++;
  }
  for(; i < LINES_points.length; i ++)
  {
    LINES_points[i][0] = MIN_INT;
    LINES_points[i][1] = MIN_INT;
  }
}

void lines_draw()
{
  if(LINES_points == null) return;

  int point_0, point_1;
  int x_curr, y_curr;
  int x_prev = MIN_INT, y_prev = MIN_INT;
  int weight;
  boolean drawed = false;
  final int offset_x =
    (ROTATE_FACTOR == 315)
    ?
    (TEXT_MARGIN + FONT_HEIGHT / 2)
    :
    (
      (ROTATE_FACTOR == 135)
      ?
      (SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT / 2))
      :
      (SCREEN_width / 2)
    );
  final int offset_y =
    (ROTATE_FACTOR == 45)
    ?
    (TEXT_MARGIN + FONT_HEIGHT / 2)
    :
    (
      (ROTATE_FACTOR == 225)
      ?
      (SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT / 2))
      :
      (SCREEN_height / 2)
    );

  fill(C_LINES_LINE);
  stroke(C_LINES_LINE);
  //strokeWeight(W_LINES_LINE);
  weight = W_LINES_LINE;
  for(int i = 0; i < LINES_points.length; i ++)
  {
    point_0 = LINES_points[i][0];
    point_1 = LINES_points[i][1];
    weight = LINES_points[i][2];
    if( point_0 == MIN_INT 
        ||
        point_1 == MIN_INT
      )
    {
      if(!drawed && x_prev != MIN_INT && y_prev != MIN_INT)
      {
        //fill(#FF0000);
        //stroke(#FF0000);
        strokeWeight(weight);
        point(x_prev + GRID_OFFSET_X, y_prev + GRID_OFFSET_Y);
      }
      x_prev = MIN_INT;
      y_prev = MIN_INT;
      continue;
    }

    if(ROTATE_FACTOR == 315)
    {
      x_curr = int(point_1 / ZOOM_FACTOR);
      y_curr = int(point_0 / ZOOM_FACTOR);
      x_curr += offset_x;
      if (MIRROR_ENABLE)
        y_curr += offset_y;
      else
        y_curr = offset_y - y_curr;
    }
    else if(ROTATE_FACTOR == 45)
    {
      x_curr = int(point_0 / ZOOM_FACTOR);
      y_curr = int(point_1 / ZOOM_FACTOR);
      if (MIRROR_ENABLE)
        x_curr = offset_x - x_curr;
      else
        x_curr += offset_x;
      y_curr += offset_y;
    }
    else if(ROTATE_FACTOR == 135)
    {
      x_curr = int(point_1 / ZOOM_FACTOR);
      y_curr = int(point_0 / ZOOM_FACTOR);
      x_curr = offset_x - x_curr; 
      if (MIRROR_ENABLE)
        y_curr = offset_y - y_curr;
      else
        y_curr += offset_y;
    }
    else /*if(ROTATE_FACTOR == 225)*/
    {
      x_curr = int(point_0 / ZOOM_FACTOR);
      y_curr = int(point_1 / ZOOM_FACTOR);
      if (MIRROR_ENABLE)
        x_curr += offset_x;
      else
        x_curr = offset_x - x_curr;
      y_curr = offset_y - y_curr;
    }
    //println("point_0=" + point_0 + ",point_1=" + point_1);
    //println("x_curr=" + x_curr + ",y_curr=" + y_curr + ",x_prev=" + x_prev + ",y_prev=" + y_prev);
    if(x_prev != MIN_INT && y_prev != MIN_INT)
    {
      //fill(C_LINES_LINE);
      //stroke(C_LINES_LINE);
      strokeWeight(weight);
      line(x_prev + GRID_OFFSET_X, y_prev + GRID_OFFSET_Y, x_curr + GRID_OFFSET_X, y_curr + GRID_OFFSET_Y);
      drawed = true;
    }
    else
    {
      drawed = false;
    }
    // Save data for drawing line between previous and current points. 
    x_prev = x_curr;
    y_prev = y_curr;
  }

  if(!drawed && x_prev != MIN_INT && y_prev != MIN_INT)
  {
    //fill(#FF0000);
    //stroke(#FF0000);
    strokeWeight(weight);
    point(x_prev + GRID_OFFSET_X, y_prev + GRID_OFFSET_Y);
  }
}
