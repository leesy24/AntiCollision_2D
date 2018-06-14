// Define default binary buf filename and path 
final static String CONST_FILE_NAME = "const";
final static String CONST_FILE_EXT = ".csv";
static String CONST_file_full_name;

// A Table object
static Table CONST_table;


void const_settings()
{
  CONST_file_full_name = CONST_FILE_NAME + CONST_FILE_EXT;

  // Load config file(CSV type) into a Table object
  // "header" option indicates the file has a header row
  CONST_table = loadTable(CONST_file_full_name, "header");
  // Check loadTable failed.
  if(CONST_table == null)
  {
    const_create();
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
    else if(name.equals("C_DATA_ERR_TEXT"))
      C_DATA_ERR_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BUBBLEINFO_RECT_FILL"))
      C_BUBBLEINFO_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BUBBLEINFO_RECT_STROKE"))
      C_BUBBLEINFO_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BUBBLEINFO_TEXT"))
      C_BUBBLEINFO_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BTN_NORMAL"))
      C_BTN_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BTN_HIGHLIGHT"))
      C_BTN_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BTN_TEXT"))
      C_BTN_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_COLORBAR_RECT_FILL"))
      C_COLORBAR_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_COLORBAR_RECT_STROKE"))
      C_COLORBAR_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_COLORBAR_TEXT"))
      C_COLORBAR_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_DATA_LINE"))
      C_DATA_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_DATA_POINT"))
      C_DATA_POINT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_DATA_RECT_FILL"))
      C_DATA_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_DATA_RECT_STROKE"))
      C_DATA_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_DATA_RECT_TEXT"))
      C_DATA_RECT_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_GRID_LINE"))
      C_GRID_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_GRID_TEXT"))
      C_GRID_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_INTERFACE_TEXT"))
      C_INTERFACE_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_INTERFACE_FILL_NORMAL"))
      C_INTERFACE_FILL_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_INTERFACE_FILL_HIGHLIGHT"))
      C_INTERFACE_FILL_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_INTERFACE_BORDER_ACTIVE"))
      C_INTERFACE_BORDER_ACTIVE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_INTERFACE_BORDER_NORMAL"))
      C_INTERFACE_BORDER_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_INTERFACE_CURSOR"))
      C_INTERFACE_CURSOR = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_LINES_LINE"))
      C_LINES_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_LINES_LINE"))
      W_LINES_LINE = variable.getInt("Value");
  }
}

void const_create()
{
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
  variable.setString("Name", "C_DATA_ERR_TEXT");
  variable.setString("Value", String.format("%08X", C_DATA_ERR_TEXT));
  variable.setString("Comment", "Error text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BUBBLEINFO_RECT_FILL");
  variable.setString("Value", String.format("%08X", C_BUBBLEINFO_RECT_FILL));
  variable.setString("Comment", "Bubble info box fill color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BUBBLEINFO_RECT_STROKE");
  variable.setString("Value", String.format("%08X", C_BUBBLEINFO_RECT_STROKE));
  variable.setString("Comment", "Bubble info box border color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BUBBLEINFO_TEXT");
  variable.setString("Value", String.format("%08X", C_BUBBLEINFO_TEXT));
  variable.setString("Comment", "Bubble infor box text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BTN_NORMAL");
  variable.setString("Value", String.format("%08X", C_BTN_NORMAL));
  variable.setString("Comment", "Button normal background color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BTN_HIGHLIGHT");
  variable.setString("Value", String.format("%08X", C_BTN_HIGHLIGHT));
  variable.setString("Comment", "Button highlight background color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_BTN_TEXT");
  variable.setString("Value", String.format("%08X", C_BTN_TEXT));
  variable.setString("Comment", "Button text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_COLORBAR_RECT_FILL");
  variable.setString("Value", String.format("%08X", C_COLORBAR_RECT_FILL));
  variable.setString("Comment", "Color bar info box fill color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_COLORBAR_RECT_STROKE");
  variable.setString("Value", String.format("%08X", C_COLORBAR_RECT_STROKE));
  variable.setString("Comment", "Color bar info box border color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_COLORBAR_TEXT");
  variable.setString("Value", String.format("%08X", C_COLORBAR_TEXT));
  variable.setString("Comment", "Color bar info box text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_DATA_LINE");
  variable.setString("Value", String.format("%08X", C_DATA_LINE));
  variable.setString("Comment", "Scan points line default color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_DATA_POINT");
  variable.setString("Value", String.format("%08X", C_DATA_POINT));
  variable.setString("Comment", "Scan point default color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_DATA_RECT_FILL");
  variable.setString("Value", String.format("%08X", C_DATA_RECT_FILL));
  variable.setString("Comment", "Scan info box fill color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_DATA_RECT_STROKE");
  variable.setString("Value", String.format("%08X", C_DATA_RECT_STROKE));
  variable.setString("Comment", "Scan info box border color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_DATA_RECT_TEXT");
  variable.setString("Value", String.format("%08X", C_DATA_RECT_TEXT));
  variable.setString("Comment", "Scan info box text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_GRID_LINE");
  variable.setString("Value", String.format("%08X", C_GRID_LINE));
  variable.setString("Comment", "Grid line color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_GRID_TEXT");
  variable.setString("Value", String.format("%08X", C_GRID_TEXT));
  variable.setString("Comment", "Grid text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_INTERFACE_TEXT");
  variable.setString("Value", String.format("%08X", C_INTERFACE_TEXT));
  variable.setString("Comment", "Interface menu text color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_INTERFACE_FILL_NORMAL");
  variable.setString("Value", String.format("%08X", C_INTERFACE_FILL_NORMAL));
  variable.setString("Comment", "Interface menu fill color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_INTERFACE_FILL_HIGHLIGHT");
  variable.setString("Value", String.format("%08X", C_INTERFACE_FILL_HIGHLIGHT));
  variable.setString("Comment", "Interface menu hightlight color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_INTERFACE_BORDER_ACTIVE");
  variable.setString("Value", String.format("%08X", C_INTERFACE_BORDER_ACTIVE));
  variable.setString("Comment", "Interface menu border active color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_INTERFACE_BORDER_NORMAL");
  variable.setString("Value", String.format("%08X", C_INTERFACE_BORDER_NORMAL));
  variable.setString("Comment", "Interface menu border normal color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_INTERFACE_CURSOR");
  variable.setString("Value", String.format("%08X", C_INTERFACE_CURSOR));
  variable.setString("Comment", "Interface menu cursor color. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "C_LINES_LINE");
  variable.setString("Value", String.format("%08X", C_LINES_LINE));
  variable.setString("Comment", "Line color of background lines. Color data format is AARRGGBB");

  variable = CONST_table.addRow();
  variable.setString("Name", "W_LINES_LINE");
  variable.setInt("Value", W_LINES_LINE);
  variable.setString("Comment", "Line width of background lines.");

  saveTable(CONST_table, "data/" + CONST_file_full_name);
}
