//final static boolean PRINT_CONST_ALL_DBG = true;
final static boolean PRINT_CONST_ALL_DBG = false;

// Define default binary buf filename and path 
final static String CONST_FILE_NAME = "const";
final static String CONST_FILE_EXT = ".csv";
static String CONST_file_full_name;

// A Table object
static Table CONST_table;


void Const_settings()
{
  if (PRINT_CONST_ALL_DBG) println("Const_settings():");

  CONST_file_full_name = CONST_FILE_NAME + CONST_FILE_EXT;

  // Load config file(CSV type) into a Table object
  // "header" option indicates the file has a header row
  CONST_table = loadTable(CONST_file_full_name, "header");
  // Check loadTable failed.
  if(CONST_table == null)
  {
    Const_create();
    return;
  }

  for (TableRow variable : CONST_table.rows())
  {
    // You can access the fields via their column name (or index)
    String name = variable.getString("Name");
    if(name.equals("FRAME_RATE"))
      FRAME_RATE = variable.getInt("Value");
    else if(name.equals("SCREEN_BORDER_WIDTH"))
      SCREEN_BORDER_WIDTH = variable.getInt("Value");
    else if(name.equals("SCREEN_TITLE_HEIGHT"))
      SCREEN_TITLE_HEIGHT = variable.getInt("Value");
    else if(name.equals("SCREEN_X_OFFSET"))
      SCREEN_X_OFFSET = variable.getInt("Value");
    else if(name.equals("SCREEN_Y_OFFSET"))
      SCREEN_Y_OFFSET = variable.getInt("Value");
    else if(name.equals("C_BG"))
      C_BG = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_PS_DATA_ERR_TEXT"))
      C_PS_DATA_ERR_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BUBBLE_INFO_RECT_FILL"))
      C_BUBBLE_INFO_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BUBBLE_INFO_RECT_STROKE"))
      C_BUBBLE_INFO_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BUBBLE_INFO_TEXT"))
      C_BUBBLE_INFO_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_BUTTONS_NORMAL"))
      C_UI_BUTTONS_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_BUTTONS_HIGHLIGHT"))
      C_UI_BUTTONS_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_BUTTONS_TEXT"))
      C_UI_BUTTONS_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_BUTTONS_BOX"))
      C_UI_BUTTONS_BOX = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_UI_BUTTONS_BOX"))
      W_UI_BUTTONS_BOX = variable.getInt("Value");
    else if(name.equals("C_PS_DATA_LINE"))
      C_PS_DATA_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_PS_DATA_POINT"))
      C_PS_DATA_POINT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_PS_DATA_LINE"))
      W_PS_DATA_LINE = variable.getInt("Value");
    else if(name.equals("C_PS_DATA_RECT_FILL"))
      C_PS_DATA_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_PS_DATA_RECT_STROKE"))
      C_PS_DATA_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_PS_DATA_RECT_STROKE"))
      W_PS_DATA_RECT_STROKE = variable.getInt("Value");
    else if(name.equals("C_PS_DATA_RECT_TEXT"))
      C_PS_DATA_RECT_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_GRID_LINE"))
      C_GRID_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_GRID_LINE"))
      W_GRID_LINE = variable.getInt("Value");
    else if(name.equals("C_GRID_TEXT"))
      C_GRID_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_TEXT"))
      C_UI_INTERFACES_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_FILL_NORMAL"))
      C_UI_INTERFACES_FILL_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_FILL_HIGHLIGHT"))
      C_UI_INTERFACES_FILL_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_BORDER_ACTIVE"))
      C_UI_INTERFACES_BORDER_ACTIVE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_BORDER_NORMAL"))
      C_UI_INTERFACES_BORDER_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_CURSOR"))
      C_UI_INTERFACES_CURSOR = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_REGION_FAULT_DEFAULT_LINE"))
      C_REGION_FAULT_DEFAULT_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_REGION_FAULT_DEFAULT_LINE"))
      W_REGION_FAULT_DEFAULT_LINE = variable.getInt("Value");
    else if(name.equals("C_REGION_ALERT_DEFAULT_LINE"))
      C_REGION_ALERT_DEFAULT_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_REGION_ALERT_DEFAULT_LINE"))
      W_REGION_ALERT_DEFAULT_LINE = variable.getInt("Value");
    else if(name.equals("C_REGION_MONITOR_DEFAULT_LINE"))
      C_REGION_MONITOR_DEFAULT_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_REGION_MONITOR_DEFAULT_LINE"))
      W_REGION_MONITOR_DEFAULT_LINE = variable.getInt("Value");
    else if(name.equals("C_REGION_FAULT_ROI_MARKER_FILL"))
      C_REGION_FAULT_ROI_MARKER_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_REGION_FAULT_ROI_MARKER_STROKE"))
      C_REGION_FAULT_ROI_MARKER_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_REGION_FAULT_ROI_MARKER_STROKE"))
      W_REGION_FAULT_ROI_MARKER_STROKE = variable.getInt("Value");
    else if(name.equals("C_REGION_ALERT_ROI_MARKER_FILL"))
      C_REGION_ALERT_ROI_MARKER_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_REGION_ALERT_ROI_MARKER_STROKE"))
      C_REGION_ALERT_ROI_MARKER_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_REGION_ALERT_ROI_MARKER_STROKE"))
      W_REGION_ALERT_ROI_MARKER_STROKE = variable.getInt("Value");
    else if(name.equals("C_REGION_MONITOR_ROI_MARKER_FILL"))
      C_REGION_MONITOR_ROI_MARKER_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_REGION_MONITOR_ROI_MARKER_STROKE"))
      C_REGION_MONITOR_ROI_MARKER_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_REGION_MONITOR_ROI_MARKER_STROKE"))
      W_REGION_MONITOR_ROI_MARKER_STROKE = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_MARKER_MARGIN"))
      ROI_OBJECT_MARKER_MARGIN = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DISTANCE_LIMIT"))
      ROI_OBJECT_DISTANCE_LIMIT = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_TIME_LIMIT"))
      ROI_OBJECT_TIME_LIMIT = variable.getInt("Value");
    else if(name.equals("C_BG_IMAGE_LINE"))
      C_BG_IMAGE_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_BG_IMAGE_LINE"))
      W_BG_IMAGE_LINE = variable.getInt("Value");
  }
}

void Const_create()
{
  if (PRINT_CONST_ALL_DBG) println("Const_create():");

  TableRow variable;

  CONST_table = new Table();
  CONST_table.addColumn("Name");
  CONST_table.addColumn("Value");
  CONST_table.addColumn("Comment");

  variable = CONST_table.addRow();
  variable.setString("Name", "FRAME_RATE");
  variable.setInt("Value", FRAME_RATE);
  variable.setString("Comment", "Frame rate per second of screen update in Hz. 20Hz = 50msec");

  variable = CONST_table.addRow();
  variable.setString("Name", "SCREEN_BORDER_WIDTH");
  variable.setInt("Value", SCREEN_BORDER_WIDTH);
  variable.setString("Comment", "Border width of window of Windows. default = 8");

  variable = CONST_table.addRow();
  variable.setString("Name", "SCREEN_TITLE_HEIGHT");
  variable.setInt("Value", SCREEN_TITLE_HEIGHT);
  variable.setString("Comment", "Title height of window of Windows. default = 31");

  variable = CONST_table.addRow();
  variable.setString("Name", "SCREEN_X_OFFSET");
  variable.setInt("Value", SCREEN_X_OFFSET);
  variable.setString("Comment", "Adjuest X offset of window of Windows. default = 3");

  variable = CONST_table.addRow();
  variable.setString("Name", "SCREEN_Y_OFFSET");
  variable.setInt("Value", SCREEN_Y_OFFSET);
  variable.setString("Comment", "Adjuest Y offset of window of Windows. default = 5");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BG");
  variable.setString("Value", String.format("%08X", C_BG));
  variable.setString("Comment", "Background color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_PS_DATA_ERR_TEXT");
  variable.setString("Value", String.format("%08X", C_PS_DATA_ERR_TEXT));
  variable.setString("Comment", "Error text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BUBBLE_INFO_RECT_FILL");
  variable.setString("Value", String.format("%08X", C_BUBBLE_INFO_RECT_FILL));
  variable.setString("Comment", "Bubble info box fill color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BUBBLE_INFO_RECT_STROKE");
  variable.setString("Value", String.format("%08X", C_BUBBLE_INFO_RECT_STROKE));
  variable.setString("Comment", "Bubble info box border color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BUBBLE_INFO_TEXT");
  variable.setString("Value", String.format("%08X", C_BUBBLE_INFO_TEXT));
  variable.setString("Comment", "Bubble infor box text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_BUTTONS_NORMAL");
  variable.setString("Value", String.format("%08X", C_UI_BUTTONS_NORMAL));
  variable.setString("Comment", "Button normal background color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_BUTTONS_HIGHLIGHT");
  variable.setString("Value", String.format("%08X", C_UI_BUTTONS_HIGHLIGHT));
  variable.setString("Comment", "Button highlight background color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_BUTTONS_TEXT");
  variable.setString("Value", String.format("%08X", C_UI_BUTTONS_TEXT));
  variable.setString("Comment", "Button text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_BUTTONS_BOX");
  variable.setString("Value", String.format("%08X", C_UI_BUTTONS_BOX));
  variable.setString("Comment", "Button box color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_UI_BUTTONS_BOX");
  variable.setInt("Value", W_UI_BUTTONS_BOX);
  variable.setString("Comment", "Button box weight.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_PS_DATA_LINE");
  variable.setString("Value", String.format("%08X", C_PS_DATA_LINE));
  variable.setString("Comment", "Scan points line default color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_PS_DATA_POINT");
  variable.setString("Value", String.format("%08X", C_PS_DATA_POINT));
  variable.setString("Comment", "Scan point default color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_PS_DATA_LINE");
  variable.setInt("Value", W_PS_DATA_LINE);
  variable.setString("Comment", "Scan line and point default weight.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_PS_DATA_RECT_FILL");
  variable.setString("Value", String.format("%08X", C_PS_DATA_RECT_FILL));
  variable.setString("Comment", "Scan info box fill color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_PS_DATA_RECT_STROKE");
  variable.setString("Value", String.format("%08X", C_PS_DATA_RECT_STROKE));
  variable.setString("Comment", "Scan info box border color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_PS_DATA_RECT_STROKE");
  variable.setInt("Value", W_PS_DATA_RECT_STROKE);
  variable.setString("Comment", "Scan info box border line weight.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_PS_DATA_RECT_TEXT");
  variable.setString("Value", String.format("%08X", C_PS_DATA_RECT_TEXT));
  variable.setString("Comment", "Scan info box text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_GRID_LINE");
  variable.setString("Value", String.format("%08X", C_GRID_LINE));
  variable.setString("Comment", "Grid line color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_GRID_LINE");
  variable.setInt("Value", W_GRID_LINE);
  variable.setString("Comment", "Grid line weight.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_GRID_TEXT");
  variable.setString("Value", String.format("%08X", C_GRID_TEXT));
  variable.setString("Comment", "Grid text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_TEXT");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_TEXT));
  variable.setString("Comment", "Interface menu text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_FILL_NORMAL");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_FILL_NORMAL));
  variable.setString("Comment", "Interface menu fill color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_FILL_HIGHLIGHT");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_FILL_HIGHLIGHT));
  variable.setString("Comment", "Interface menu hightlight color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_BORDER_ACTIVE");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_BORDER_ACTIVE));
  variable.setString("Comment", "Interface menu border active color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_BORDER_NORMAL");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_BORDER_NORMAL));
  variable.setString("Comment", "Interface menu border normal color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_CURSOR");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_CURSOR));
  variable.setString("Comment", "Interface menu cursor color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_FAULT_DEFAULT_LINE");
  variable.setString("Value", String.format("%08X", C_REGION_FAULT_DEFAULT_LINE));
  variable.setString("Comment", "Line color of fault region lines. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_REGION_FAULT_DEFAULT_LINE");
  variable.setInt("Value", W_REGION_FAULT_DEFAULT_LINE);
  variable.setString("Comment", "Line weight of fault region lines.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_ALERT_DEFAULT_LINE");
  variable.setString("Value", String.format("%08X", C_REGION_ALERT_DEFAULT_LINE));
  variable.setString("Comment", "Line color of alert region lines. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_REGION_ALERT_DEFAULT_LINE");
  variable.setInt("Value", W_REGION_ALERT_DEFAULT_LINE);
  variable.setString("Comment", "Line weight of alert region lines.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_MONITOR_DEFAULT_LINE");
  variable.setString("Value", String.format("%08X", C_REGION_MONITOR_DEFAULT_LINE));
  variable.setString("Comment", "Line color of monitor region lines. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_REGION_MONITOR_DEFAULT_LINE");
  variable.setInt("Value", W_REGION_MONITOR_DEFAULT_LINE);
  variable.setString("Comment", "Line weight of monitor region lines.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_FAULT_ROI_MARKER_FILL");
  variable.setString("Value", String.format("%08X", C_REGION_FAULT_ROI_MARKER_FILL));
  variable.setString("Comment", "Fill color of fault object ROI marker. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_FAULT_ROI_MARKER_STROKE");
  variable.setString("Value", String.format("%08X", C_REGION_FAULT_ROI_MARKER_STROKE));
  variable.setString("Comment", "Border color of fault object ROI marker. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_REGION_FAULT_ROI_MARKER_STROKE");
  variable.setInt("Value", W_REGION_FAULT_ROI_MARKER_STROKE);
  variable.setString("Comment", "Border weight of fault object ROI marker.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_ALERT_ROI_MARKER_FILL");
  variable.setString("Value", String.format("%08X", C_REGION_ALERT_ROI_MARKER_FILL));
  variable.setString("Comment", "Fill color of alert object ROI marker. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_ALERT_ROI_MARKER_STROKE");
  variable.setString("Value", String.format("%08X", C_REGION_ALERT_ROI_MARKER_STROKE));
  variable.setString("Comment", "Border color of alert object ROI marker. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_REGION_ALERT_ROI_MARKER_STROKE");
  variable.setInt("Value", W_REGION_ALERT_ROI_MARKER_STROKE);
  variable.setString("Comment", "Border weight of alert object ROI marker.");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_MONITOR_ROI_MARKER_FILL");
  variable.setString("Value", String.format("%08X", C_REGION_MONITOR_ROI_MARKER_FILL));
  variable.setString("Comment", "Fill color of monitor object ROI marker. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_REGION_MONITOR_ROI_MARKER_STROKE");
  variable.setString("Value", String.format("%08X", C_REGION_MONITOR_ROI_MARKER_STROKE));
  variable.setString("Comment", "Border color of monitor object ROI marker. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_REGION_MONITOR_ROI_MARKER_STROKE");
  variable.setInt("Value", W_REGION_MONITOR_ROI_MARKER_STROKE);
  variable.setString("Comment", "Border weight of monitor object ROI marker.");

  variable = CONST_table.addRow();
  variable.setString("Name", "ROI_OBJECT_MARKER_MARGIN");
  variable.setInt("Value", ROI_OBJECT_MARKER_MARGIN);
  variable.setString("Comment", "Margin of objects ROI marker.");

  variable = CONST_table.addRow();
  variable.setString("Name", "ROI_OBJECT_DISTANCE_LIMIT");
  variable.setInt("Value", ROI_OBJECT_DISTANCE_LIMIT);
  variable.setString("Comment", "Distance limit of object to decide one object ROI.(5000=50cm=0.5 meter)");

  variable = CONST_table.addRow();
  variable.setString("Name", "ROI_OBJECT_TIME_LIMIT");
  variable.setInt("Value", ROI_OBJECT_TIME_LIMIT);
  variable.setString("Comment", "Time limit of object to decide one object ROI.(unit is milli-seconds)");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BG_IMAGE_LINE");
  variable.setString("Value", String.format("%08X", C_BG_IMAGE_LINE));
  variable.setString("Comment", "Line color of background image lines. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_BG_IMAGE_LINE");
  variable.setInt("Value", W_BG_IMAGE_LINE);
  variable.setString("Comment", "Line weight of background image lines.");

  saveTable(CONST_table, "data/" + CONST_file_full_name);
}
