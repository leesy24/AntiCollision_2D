//final static boolean PRINT_CONST_ALL_DBG = true;
final static boolean PRINT_CONST_ALL_DBG = false;

//final static boolean PRINT_CONST_SETUP_DBG = true;
final static boolean PRINT_CONST_SETUP_DBG = false;

// Define default binary buf filename and path 
final static String CONST_FILE_NAME = "const";
final static String CONST_FILE_EXT = ".csv";

static String CONST_file_full_name;

void Const_setup()
{
  if (PRINT_CONST_ALL_DBG || PRINT_CONST_SETUP_DBG) println("Const_setup():Enter");

  // A Table object
  Table table;

  CONST_file_full_name = CONST_FILE_NAME + CONST_FILE_EXT;

  // Load config file(CSV type) into a Table object
  // "header" option indicates the file has a header row
  table = loadTable(CONST_file_full_name, "header");
  // Check loadTable failed.
  if (table == null)
  {
    Const_create();
    return;
  }

  for (TableRow variable : table.rows())
  {
    // You can access the fields via their column name (or index)
    String name = variable.getString("Name");
    if (name.equals("SYSTEM_PASSWORD"))
      SYSTEM_PASSWORD = variable.getString("Value");
    else if(name.equals("SYSTEM_UI_TIMEOUT"))
      SYSTEM_UI_TIMEOUT = variable.getInt("Value");
    else if(name.equals("FRAME_RATE"))
      FRAME_RATE = variable.getInt("Value");
    else if (name.equals("PS_DATA_SAVE_ALWAYS_DURATION"))
      PS_DATA_SAVE_ALWAYS_DURATION = variable.getInt("Value");
    else if (name.equals("PS_DATA_SAVE_EVENTS_DURATION_DEFAULT"))
      PS_DATA_SAVE_EVENTS_DURATION_DEFAULT = variable.getInt("Value");
    else if (name.equals("PS_DATA_SAVE_EVENTS_DURATION_LIMIT"))
      PS_DATA_SAVE_EVENTS_DURATION_LIMIT = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_MARKER_MARGIN"))
      ROI_OBJECT_MARKER_MARGIN = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX"))
      ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DETECT_DIAMETER_MIN"))
      ROI_OBJECT_DETECT_DIAMETER_MIN = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DETECT_TIME_MIN"))
      ROI_OBJECT_DETECT_TIME_MIN = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DETECT_KEEP_TIME"))
      ROI_OBJECT_DETECT_KEEP_TIME = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN"))
      ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN = variable.getInt("Value");
    else if (name.equals("Relay_Module_UART_port_name"))
      Relay_Module_UART_port_name = variable.getString("Value");
    else if (name.equals("Relay_Module_UART_baud_rate"))
      Relay_Module_UART_baud_rate = variable.getInt("Value");
    else if (name.equals("Relay_Module_UART_parity"))
      Relay_Module_UART_parity = variable.getString("Value").charAt(0);
    else if (name.equals("Relay_Module_UART_data_bits"))
      Relay_Module_UART_data_bits = variable.getInt("Value");
    else if (name.equals("Relay_Module_UART_stop_bits"))
      Relay_Module_UART_stop_bits = variable.getFloat("Value"); 
    else if(name.equals("C_RELAY_MODULE_INDICATOR_OFF_FILL"))
      C_RELAY_MODULE_INDICATOR_OFF_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_RELAY_MODULE_INDICATOR_OFF_STROKE"))
      C_RELAY_MODULE_INDICATOR_OFF_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
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
    else if(name.equals("C_VERSION_DATE_TEXT"))
      C_VERSION_DATE_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_PS_DATA_ERR_TEXT"))
      C_PS_DATA_ERR_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_NUM_PAD_NORMAL"))
      C_UI_NUM_PAD_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_NUM_PAD_HIGHLIGHT"))
      C_UI_NUM_PAD_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_NUM_PAD_TEXT"))
      C_UI_NUM_PAD_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_NUM_PAD_BOX"))
      C_UI_NUM_PAD_BOX = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_UI_NUM_PAD_BOX"))
      W_UI_NUM_PAD_BOX = variable.getInt("Value");
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
    else if(name.equals("C_UI_MESSAGE_BOX_FILL"))
      C_UI_MESSAGE_BOX_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_MESSAGE_BOX_TEXT"))
      C_UI_MESSAGE_BOX_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_MESSAGE_BOX_RECT"))
      C_UI_MESSAGE_BOX_RECT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_UI_MESSAGE_BOX_RECT"))
      W_UI_MESSAGE_BOX_RECT = variable.getInt("Value");
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
    else if(name.equals("C_BG_IMAGE_LINE"))
      C_BG_IMAGE_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_BG_IMAGE_LINE"))
      W_BG_IMAGE_LINE = variable.getInt("Value");
  }
}

void Const_create()
{
  if (PRINT_CONST_ALL_DBG) println("Const_create():");

  // A Table object
  Table table;
  TableRow variable;

  table = new Table();
  table.addColumn("Name");
  table.addColumn("Value");
  table.addColumn("Comment");

  variable = table.addRow();
  variable.setString("Name", "SYSTEM_PASSWORD");
  variable.setString("Value", SYSTEM_PASSWORD);
  variable.setString("Comment", "4-Digits system password to configure settings");

  variable = table.addRow();
  variable.setString("Name", "SYSTEM_UI_TIMEOUT");
  variable.setInt("Value", SYSTEM_UI_TIMEOUT);
  variable.setString("Comment", "Timeout value for UI displaying in seconds");

  variable = table.addRow();
  variable.setString("Name", "FRAME_RATE");
  variable.setInt("Value", FRAME_RATE);
  variable.setString("Comment", "Frame rate per second of screen update in Hz. 20Hz=50msec 50Hz=20msec");

  variable = table.addRow();
  variable.setString("Name", "PS_DATA_SAVE_ALWAYS_DURATION");
  variable.setInt("Value", PS_DATA_SAVE_ALWAYS_DURATION);
  variable.setString("Comment", "Time duration of received PS data keep in milli-seconds to save on disk.");

  variable = table.addRow();
  variable.setString("Name", "PS_DATA_SAVE_EVENTS_DURATION_DEFAULT");
  variable.setInt("Value", PS_DATA_SAVE_EVENTS_DURATION_DEFAULT);
  variable.setString("Comment", "Default time duration of event PS data keep in milli-seconds to save on disk.");

  variable = table.addRow();
  variable.setString("Name", "PS_DATA_SAVE_EVENTS_DURATION_LIMIT");
  variable.setInt("Value", PS_DATA_SAVE_EVENTS_DURATION_LIMIT);
  variable.setString("Comment", "Limit time duration of event PS data keep in milli-seconds to save on disk.");

  variable = table.addRow();
  variable.setString("Name", "ROI_OBJECT_MARKER_MARGIN");
  variable.setInt("Value", ROI_OBJECT_MARKER_MARGIN);
  variable.setString("Comment", "Margin of objects ROI marker.");

  variable = table.addRow();
  variable.setString("Name", "ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX");
  variable.setInt("Value", ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX);
  variable.setString("Comment", "Maximum distance of points to detect one object ROI.(5000=50cm=0.5meter)");

  variable = table.addRow();
  variable.setString("Name", "ROI_OBJECT_DETECT_DIAMETER_MIN");
  variable.setInt("Value", ROI_OBJECT_DETECT_DIAMETER_MIN);
  variable.setString("Comment", "Minimum diameter of object to detect the object ROI.(2000=20cm=0.2meter)");

  variable = table.addRow();
  variable.setString("Name", "ROI_OBJECT_DETECT_TIME_MIN");
  variable.setInt("Value", ROI_OBJECT_DETECT_TIME_MIN);
  variable.setString("Comment", "Minimum time of object appearance to detect one object ROI.(unit is milli-seconds)");

  variable = table.addRow();
  variable.setString("Name", "ROI_OBJECT_DETECT_KEEP_TIME");
  variable.setInt("Value", ROI_OBJECT_DETECT_KEEP_TIME);
  variable.setString("Comment", "Keeping time for disappearance object to detect object ROI later.(unit is milli-seconds)");

  variable = table.addRow();
  variable.setString("Name", "ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN");
  variable.setInt("Value", ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN);
  variable.setString("Comment", "Minimum Diameter of object to no maker display.(20000=200cm=2meter)");

  variable = table.addRow();
  variable.setString("Name", "Relay_Module_UART_port_name");
  variable.setString("Value", Relay_Module_UART_port_name);
  variable.setString("Comment", "UART port name of Relay module.");

  variable = table.addRow();
  variable.setString("Name", "Relay_Module_UART_baud_rate");
  variable.setInt("Value", Relay_Module_UART_baud_rate);
  variable.setString("Comment", "UART baud rate of Relay module.");

  variable = table.addRow();
  variable.setString("Name", "Relay_Module_UART_parity");
  variable.setString("Value", Character.toString(Relay_Module_UART_parity));
  variable.setString("Comment", "UART parity of Relay module.");

  variable = table.addRow();
  variable.setString("Name", "Relay_Module_UART_data_bits");
  variable.setInt("Value", Relay_Module_UART_data_bits);
  variable.setString("Comment", "UART baud rate of Relay module.");

  variable = table.addRow();
  variable.setString("Name", "Relay_Module_UART_stop_bits");
  variable.setFloat("Value", Relay_Module_UART_stop_bits);
  variable.setString("Comment", "UART stop bits of Relay module.");

  variable = table.addRow();
  variable.setString("Name", "C_RELAY_MODULE_INDICATOR_OFF_FILL");
  variable.setString("Value", String.format("%08X", C_RELAY_MODULE_INDICATOR_OFF_FILL));
  variable.setString("Comment", "Color of fill of relay indicator box. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_RELAY_MODULE_INDICATOR_OFF_STROKE");
  variable.setString("Value", String.format("%08X", C_RELAY_MODULE_INDICATOR_OFF_STROKE));
  variable.setString("Comment", "Color of stroke of relay indicator box and text. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "SCREEN_BORDER_WIDTH");
  variable.setInt("Value", SCREEN_BORDER_WIDTH);
  variable.setString("Comment", "Border width of window of Windows. default = 8");

  variable = table.addRow();
  variable.setString("Name", "SCREEN_TITLE_HEIGHT");
  variable.setInt("Value", SCREEN_TITLE_HEIGHT);
  variable.setString("Comment", "Title height of window of Windows. default = 31");

  variable = table.addRow();
  variable.setString("Name", "SCREEN_X_OFFSET");
  variable.setInt("Value", SCREEN_X_OFFSET);
  variable.setString("Comment", "Adjuest X offset of window of Windows. default = 3");

  variable = table.addRow();
  variable.setString("Name", "SCREEN_Y_OFFSET");
  variable.setInt("Value", SCREEN_Y_OFFSET);
  variable.setString("Comment", "Adjuest Y offset of window of Windows. default = 5");

  variable = table.addRow();
  variable.setString("Name", "C_BG");
  variable.setString("Value", String.format("%08X", C_BG));
  variable.setString("Comment", "Background color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_VERSION_DATE_TEXT");
  variable.setString("Value", String.format("%08X", C_VERSION_DATE_TEXT));
  variable.setString("Comment", "Color of version and date text. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_PS_DATA_ERR_TEXT");
  variable.setString("Value", String.format("%08X", C_PS_DATA_ERR_TEXT));
  variable.setString("Comment", "Error text color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_NUM_PAD_NORMAL");
  variable.setString("Value", String.format("%08X", C_UI_NUM_PAD_NORMAL));
  variable.setString("Comment", "Color of normal button of number pad. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_NUM_PAD_HIGHLIGHT");
  variable.setString("Value", String.format("%08X", C_UI_NUM_PAD_HIGHLIGHT));
  variable.setString("Comment", "Color of highlighted button of number pad. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_NUM_PAD_TEXT");
  variable.setString("Value", String.format("%08X", C_UI_NUM_PAD_TEXT));
  variable.setString("Comment", "Color of text of number pad. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_NUM_PAD_BOX");
  variable.setString("Value", String.format("%08X", C_UI_NUM_PAD_BOX));
  variable.setString("Comment", "Color of button box of number pad. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "W_UI_NUM_PAD_BOX");
  variable.setInt("Value", W_UI_NUM_PAD_BOX);
  variable.setString("Comment", "Weight of border lines of number pad.");

  variable = table.addRow();
  variable.setString("Name", "C_BUBBLE_INFO_RECT_FILL");
  variable.setString("Value", String.format("%08X", C_BUBBLE_INFO_RECT_FILL));
  variable.setString("Comment", "Bubble info box fill color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_BUBBLE_INFO_RECT_STROKE");
  variable.setString("Value", String.format("%08X", C_BUBBLE_INFO_RECT_STROKE));
  variable.setString("Comment", "Bubble info box border color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_BUBBLE_INFO_TEXT");
  variable.setString("Value", String.format("%08X", C_BUBBLE_INFO_TEXT));
  variable.setString("Comment", "Bubble infor box text color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_BUTTONS_NORMAL");
  variable.setString("Value", String.format("%08X", C_UI_BUTTONS_NORMAL));
  variable.setString("Comment", "Button normal background color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_BUTTONS_HIGHLIGHT");
  variable.setString("Value", String.format("%08X", C_UI_BUTTONS_HIGHLIGHT));
  variable.setString("Comment", "Button highlight background color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_BUTTONS_TEXT");
  variable.setString("Value", String.format("%08X", C_UI_BUTTONS_TEXT));
  variable.setString("Comment", "Button text color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_BUTTONS_BOX");
  variable.setString("Value", String.format("%08X", C_UI_BUTTONS_BOX));
  variable.setString("Comment", "Button box color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "W_UI_BUTTONS_BOX");
  variable.setInt("Value", W_UI_BUTTONS_BOX);
  variable.setString("Comment", "Button box weight.");

  variable = table.addRow();
  variable.setString("Name", "C_PS_DATA_LINE");
  variable.setString("Value", String.format("%08X", C_PS_DATA_LINE));
  variable.setString("Comment", "Scan points line default color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_PS_DATA_POINT");
  variable.setString("Value", String.format("%08X", C_PS_DATA_POINT));
  variable.setString("Comment", "Scan point default color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "W_PS_DATA_LINE");
  variable.setInt("Value", W_PS_DATA_LINE);
  variable.setString("Comment", "Scan line and point default weight.");

  variable = table.addRow();
  variable.setString("Name", "C_PS_DATA_RECT_FILL");
  variable.setString("Value", String.format("%08X", C_PS_DATA_RECT_FILL));
  variable.setString("Comment", "Scan info box fill color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_PS_DATA_RECT_STROKE");
  variable.setString("Value", String.format("%08X", C_PS_DATA_RECT_STROKE));
  variable.setString("Comment", "Scan info box border color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "W_PS_DATA_RECT_STROKE");
  variable.setInt("Value", W_PS_DATA_RECT_STROKE);
  variable.setString("Comment", "Scan info box border line weight.");

  variable = table.addRow();
  variable.setString("Name", "C_PS_DATA_RECT_TEXT");
  variable.setString("Value", String.format("%08X", C_PS_DATA_RECT_TEXT));
  variable.setString("Comment", "Scan info box text color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_GRID_LINE");
  variable.setString("Value", String.format("%08X", C_GRID_LINE));
  variable.setString("Comment", "Grid line color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "W_GRID_LINE");
  variable.setInt("Value", W_GRID_LINE);
  variable.setString("Comment", "Grid line weight.");

  variable = table.addRow();
  variable.setString("Name", "C_GRID_TEXT");
  variable.setString("Value", String.format("%08X", C_GRID_TEXT));
  variable.setString("Comment", "Grid text color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_MESSAGE_BOX_FILL");
  variable.setString("Value", String.format("%08X", C_UI_MESSAGE_BOX_FILL));
  variable.setString("Comment", "Color of fill of message box. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_MESSAGE_BOX_TEXT");
  variable.setString("Value", String.format("%08X", C_UI_MESSAGE_BOX_TEXT));
  variable.setString("Comment", "Color of text of message box. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_MESSAGE_BOX_RECT");
  variable.setString("Value", String.format("%08X", C_UI_MESSAGE_BOX_RECT));
  variable.setString("Comment", "Color of rect of message box. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "W_UI_MESSAGE_BOX_RECT");
  variable.setInt("Value", W_UI_MESSAGE_BOX_RECT);
  variable.setString("Comment", "Weight of rect lines of message box.");

  variable = table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_TEXT");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_TEXT));
  variable.setString("Comment", "Interface menu text color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_FILL_NORMAL");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_FILL_NORMAL));
  variable.setString("Comment", "Interface menu fill color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_FILL_HIGHLIGHT");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_FILL_HIGHLIGHT));
  variable.setString("Comment", "Interface menu hightlight color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_BORDER_ACTIVE");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_BORDER_ACTIVE));
  variable.setString("Comment", "Interface menu border active color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_BORDER_NORMAL");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_BORDER_NORMAL));
  variable.setString("Comment", "Interface menu border normal color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_UI_INTERFACES_CURSOR");
  variable.setString("Value", String.format("%08X", C_UI_INTERFACES_CURSOR));
  variable.setString("Comment", "Interface menu cursor color. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "C_BG_IMAGE_LINE");
  variable.setString("Value", String.format("%08X", C_BG_IMAGE_LINE));
  variable.setString("Comment", "Line color of background image lines. Color data format is AARRGGBB");

  variable = table.addRow();
  variable.setString("Name", "W_BG_IMAGE_LINE");
  variable.setInt("Value", W_BG_IMAGE_LINE);
  variable.setString("Comment", "Line weight of background image lines.");

  saveTable(table, "data/" + CONST_file_full_name);
}
