import controlP5.*;

//final static boolean PRINT_UI_SYSTEM_CONFIG_ALL_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_ALL_DBG = false;
final static boolean PRINT_UI_SYSTEM_CONFIG_ALL_ERR = true;
//final static boolean PRINT_UI_SYSTEM_CONFIG_ALL_ERR = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_SETUP_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_SETUP_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_UPDATE_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_UPDATE_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_RESET_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_RESET_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_DRAW_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_DRAW_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG = false;
//final static boolean PRINT_UI_SYSTEM_CONFIG_LISTENER_ERR = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_LISTENER_ERR = false;

static color C_UI_SYSTEM_CONFIG_TEXT = #000000; // Black
static color C_UI_SYSTEM_CONFIG_FILL_NORMAL = #FFFFFF; // White
static color C_UI_SYSTEM_CONFIG_FILL_HIGHLIGHT = #C0C0C0; // White - 0x40
static color C_UI_SYSTEM_CONFIG_BORDER_ACTIVE = #FF0000; // Red
static color C_UI_SYSTEM_CONFIG_BORDER_NORMAL = #000000; // Black
static color C_UI_SYSTEM_CONFIG_CURSOR = #0000FF; // Blue

static boolean UI_System_Config_enabled;

static ControlFont UI_System_Config_cf = null;
static ControlP5 UI_System_Config_cp5_global = null;

static boolean UI_System_Config_changed_any = false;
static int UI_System_Config_x_base;
static int UI_System_Config_y_base;
UI_System_Config_BT_ControlListener UI_System_Config_bt_control_listener;
//UI_System_Config_TF_ControlListener UI_System_Config_tf_control_listener;
static enum UI_System_Config_tf_enum {
  SYSTEM_PASSWORD,
  FRAME_RATE,
  PS_DATA_SAVE_ALWAYS_DURATION,
  PS_DATA_SAVE_EVENTS_DURATION_DEFAULT,
  PS_DATA_SAVE_EVENTS_DURATION_LIMIT,
  Relay_Module_UART_port_name,
  ROI_OBJECT_DETECT_DISTANCE_MIN,
  ROI_OBJECT_DETECT_TIME_MIN,
  ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN,
  ROI_OBJECT_MARKER_MARGIN,
  MAX
}

static enum UI_System_Config_state_enum {
  IDLE,
  PASSWORD_REQ,
  WAIT_CONFIG_INPUT,
  DISPLAY_MESSAGE,
  RESET,
  MAX
}
static UI_System_Config_state_enum UI_System_Config_state;
static UI_System_Config_state_enum UI_System_Config_state_next;

void UI_System_Config_setup()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_SETUP_DBG) println("UI_System_Config_setup():Enter");

  //UI_System_Config_enabled = true;
  UI_System_Config_enabled = false;

  UI_System_Config_changed_any = false;

  UI_System_Config_state = UI_System_Config_state_enum.IDLE;

  if (UI_System_Config_cp5_global != null)
  {
    UI_System_Config_reset();
  }
  UI_System_Config_cp5_global = null;

  UI_System_Config_x_base = TEXT_MARGIN;
  UI_System_Config_y_base = TEXT_MARGIN;

}

void UI_System_Config_update()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_UPDATE_DBG) println("UI_System_Config_update():Enter");

  if (!UI_System_Config_enabled)
  {
    UI_System_Config_reset();
    return;
  }

  UI_System_Config_changed_any = false;

  if(UI_System_Config_cf == null) {
    UI_System_Config_cf = new ControlFont(SCREEN_PFront,FONT_HEIGHT);
  }

  UI_System_Config_bt_control_listener = new UI_System_Config_BT_ControlListener();
  //UI_System_Config_tf_control_listener = new UI_System_Config_TF_ControlListener();

  int x, y;
  int w, h;
  String str;

  if(UI_System_Config_cp5_global == null) {
    UI_System_Config_cp5_global = new ControlP5(this, UI_System_Config_cf);
    UI_System_Config_cp5_global.setBackground(C_UI_SYSTEM_CONFIG_FILL_NORMAL);
  }
  else {
    UI_System_Config_reset();
  }

  Textlabel tl_handle;
  Textfield tf_handle;
  Button bt_handle;

  // Outline border
  w = SCREEN_width - TEXT_MARGIN * 2;
  x = UI_System_Config_x_base;
  h = SCREEN_height - TEXT_MARGIN * 2;
  y = UI_System_Config_y_base;
  Textfield tf_outline_border;
  tf_outline_border = UI_System_Config_cp5_global.addTextfield("UI_System_Config_outline_border");
  tf_outline_border
    .setId(-1)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_SYSTEM_CONFIG_FILL_NORMAL)
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  // Title
  textSize(FONT_HEIGHT);
  str = "System Config";
  w = int(textWidth(str));
  x = UI_System_Config_x_base + (SCREEN_width - TEXT_MARGIN * 2) / 2 - w / 2;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y += TEXT_MARGIN;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_title_label");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  int w_max;

  w_max = MIN_INT;

  x = UI_System_Config_x_base + FONT_HEIGHT;
  y = UI_System_Config_y_base + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;

  // SYSTEM_PASSWORD
  //y += h + TEXT_MARGIN;
  str = "SYSTEM_PASSWORD(4-digits)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_SYSTEM_PASSWORD");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // FRAME_RATE
  y += h + TEXT_MARGIN;
  str = "FRAME_RATE(Hz)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_FRAME_RATE");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // PS_DATA_SAVE_ALWAYS_DURATION
  y += h + TEXT_MARGIN;
  str = "PS_DATA_SAVE_ALWAYS_DURATION(sec.)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_PS_DATA_SAVE_ALWAYS_DURATION");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // PS_DATA_SAVE_EVENTS_DURATION_DEFAULT
  y += h + TEXT_MARGIN;
  str = "PS_DATA_SAVE_EVENTS_DURATION_DEFAULT(sec.)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_PS_DATA_SAVE_EVENTS_DURATION_DEFAULT");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // PS_DATA_SAVE_EVENTS_DURATION_LIMIT
  y += h + TEXT_MARGIN;
  str = "PS_DATA_SAVE_EVENTS_DURATION_LIMIT(sec.)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_PS_DATA_SAVE_EVENTS_DURATION_LIMIT");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // Relay_Module_UART_port_name
  y += h + TEXT_MARGIN;
  str = "Relay_Module_UART_port_name";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_Relay_Module_UART_port_name");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_DETECT_DISTANCE_MIN
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_DETECT_DISTANCE_MIN(m)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_DETECT_DISTANCE_MIN");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_DETECT_TIME_MIN
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_DETECT_TIME_MIN(sec.)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_DETECT_TIME_MIN");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN(m)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_MARKER_MARGIN
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_MARKER_MARGIN(pixel)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_MARKER_MARGIN");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  x += w_max + FONT_HEIGHT;
  y = UI_System_Config_y_base + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
  //y = UI_System_Config_y_base + FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN;

  w_max = MIN_INT;

  // SYSTEM_PASSWORD input
  //y += h + TEXT_MARGIN;
  str = SYSTEM_PASSWORD;
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_SYSTEM_PASSWORD_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.SYSTEM_PASSWORD.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // FRAME_RATE input
  y += h + TEXT_MARGIN;
  str = String.valueOf(FRAME_RATE);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_FRAME_RATE_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.FRAME_RATE.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // PS_DATA_SAVE_ALWAYS_DURATION input
  y += h + TEXT_MARGIN;
  str = String.valueOf(PS_DATA_SAVE_ALWAYS_DURATION / 1000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_PS_DATA_SAVE_ALWAYS_DURATION_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.PS_DATA_SAVE_ALWAYS_DURATION.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // PS_DATA_SAVE_EVENTS_DURATION_DEFAULT input
  y += h + TEXT_MARGIN;
  str = String.valueOf(PS_DATA_SAVE_EVENTS_DURATION_DEFAULT / 1000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_PS_DATA_SAVE_EVENTS_DURATION_DEFAULT_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.PS_DATA_SAVE_EVENTS_DURATION_DEFAULT.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // PS_DATA_SAVE_EVENTS_DURATION_LIMIT input
  y += h + TEXT_MARGIN;
  str = String.valueOf(PS_DATA_SAVE_EVENTS_DURATION_LIMIT / 1000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_PS_DATA_SAVE_EVENTS_DURATION_LIMIT_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.PS_DATA_SAVE_EVENTS_DURATION_LIMIT.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // Relay_Module_UART_port_name input
  y += h + TEXT_MARGIN;
  str = Relay_Module_UART_port_name;
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_Relay_Module_UART_port_name_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.Relay_Module_UART_port_name.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_DETECT_DISTANCE_MIN input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_DETECT_DISTANCE_MIN / 10000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_DETECT_DISTANCE_MIN_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_DETECT_DISTANCE_MIN.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_DETECT_TIME_MIN input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_DETECT_TIME_MIN / 1000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_DETECT_TIME_MIN_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_DETECT_TIME_MIN.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN / 10000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_MARKER_MARGIN input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_MARKER_MARGIN);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_MARKER_MARGIN_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_MARKER_MARGIN.ordinal())
    //.addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // Button outline border
  w = (FONT_HEIGHT * 7 + TEXT_MARGIN * 2) * 2 + FONT_HEIGHT * 2 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 - w / 2;
  h = FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1 - TEXT_MARGIN;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_buttons_border");
  tf_handle
    .setId(-1)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_SYSTEM_CONFIG_FILL_NORMAL)
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  str = "OK";
  w = FONT_HEIGHT * 7 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 - w - FONT_HEIGHT;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1;
  bt_handle = UI_System_Config_cp5_global.addButton(str);
  bt_handle.setId(0)
    .addListener(UI_System_Config_bt_control_listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_HIGHLIGHT ) // Button fill color, when mouse is not over.
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL ) // Button fill color, when mouse over.
    .setColorActive(C_UI_SYSTEM_CONFIG_BORDER_ACTIVE) // Button fill color, when mouse pressed.
    .setColorLabel( C_UI_SYSTEM_CONFIG_FILL_NORMAL ) // Button text color
    ;
//  bt_handle.get()
//    .setSize(FONT_HEIGHT)
//    ;

  str = "Cancel";
  w = FONT_HEIGHT * 7 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 + FONT_HEIGHT;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1;
  bt_handle = UI_System_Config_cp5_global.addButton(str);
  bt_handle.setId(1)
    .addListener(UI_System_Config_bt_control_listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_HIGHLIGHT ) // Button fill color, when mouse is not over.
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL ) // Button fill color, when mouse over.
    .setColorActive(C_UI_SYSTEM_CONFIG_BORDER_ACTIVE) // Button fill color, when mouse pressed.
    .setColorLabel( C_UI_SYSTEM_CONFIG_FILL_NORMAL ) // Button text color
    ;
//  bt_handle.get()
//    .setSize(FONT_HEIGHT)
//    ;

}

void UI_System_Config_reset()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_RESET_DBG) println("UI_System_Config_reset():Enter");

  if(UI_System_Config_cp5_global == null) {
    return;
  }

  List<ControllerInterface<?>> cp5_list = UI_System_Config_cp5_global.getAll();

  for (ControllerInterface controller:cp5_list)
  {
    //println("name:"+controller.getName());
    UI_System_Config_cp5_global.remove(controller.getName());
  }

  UI_System_Config_cp5_global.setGraphics(this,0,0);

  UI_System_Config_cp5_global = null;
}

void UI_System_Config_draw()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_DRAW_DBG) println("UI_System_Config_draw():Enter");

  //println("UI_System_Config_state=", UI_System_Config_state);
  switch (UI_System_Config_state)
  {
    case IDLE:
      if (!UI_System_Config_enabled)
      {
        break;
      }

      // Check password not required.
      if (SYSTEM_PASSWORD.equals(""))
      {
        UI_System_Config_state = UI_System_Config_state_enum.WAIT_CONFIG_INPUT;
        UI_System_Config_update();
        break;
      }

      UI_Num_Pad_setup("Input\nSYSTEM\npassword");
      UI_System_Config_state = UI_System_Config_state_enum.PASSWORD_REQ;
      break;
    case PASSWORD_REQ:
      if (!UI_System_Config_enabled)
      {
        //UI_System_Config_reset();
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        break;
      }

      UI_Num_Pad_handle.draw();
      if (!UI_Num_Pad_handle.input_done())
      {
        break;
      }

      if (UI_Num_Pad_handle.input_string == null)
      {
        //UI_System_Config_reset();
        UI_System_Config_enabled = false;
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        break;
      }

      // Input done, check password.
      if (!UI_Num_Pad_handle.input_string.equals(SYSTEM_PASSWORD))
      {
        // Password fail...
        UI_Message_Box_setup("Error !", "Wrong password input!\nYou can NOT access special functions.", 5000);
        UI_System_Config_state = UI_System_Config_state_enum.DISPLAY_MESSAGE;
        UI_System_Config_state_next = UI_System_Config_state_enum.IDLE;
        UI_System_Config_enabled = false;
        break;
      }
      UI_System_Config_state = UI_System_Config_state_enum.WAIT_CONFIG_INPUT;
      UI_System_Config_update();
      break;
    case WAIT_CONFIG_INPUT:
      if (!UI_System_Config_enabled)
      {
        UI_System_Config_reset();
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        break;
      }
      if (UI_System_Config_changed_any)
      {
        UI_System_Config_reset();
        // Update done! Indicate updated.
        UI_Message_Box_setup("Update done !", "New configuration will applied right now.", 3000);
        UI_System_Config_state = UI_System_Config_state_enum.DISPLAY_MESSAGE;
        UI_System_Config_state_next = UI_System_Config_state_enum.RESET;
        break;
      }
      break;
    case DISPLAY_MESSAGE:
      if (UI_Message_Box_handle.draw())
      {
        break;
      }
      UI_System_Config_state = UI_System_Config_state_next;
      break;
    case RESET:
      // To restart program set frameCount to -1, this wiil call setup() of main.
      frameCount = -1;
      break;
  }
}


/*
class UI_System_Config_TF_ControlListener implements ControlListener {
  int col;
  public void controlEvent(ControlEvent theEvent) {
    Textfield tf_handle;
    println("UI_System_Config_TF_ControlListener:controlEvent():Enter");
    tf_handle = (Textfield)theEvent.getController();
    println("UI_System_Config_TF_ControlListener:controlEvent():getId="+tf_handle.getId());
    println("UI_System_Config_TF_ControlListener:controlEvent():getValue="+tf_handle.getValue());
    println("UI_System_Config_TF_ControlListener:controlEvent():getText="+tf_handle.getText());
  }
}
*/

class UI_System_Config_BT_ControlListener implements ControlListener {
  int col;
  public void controlEvent(ControlEvent theEvent) {
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Enter");

    Button bt_handle = (Button)theEvent.getController();
    int button_index = bt_handle.getId();

    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():button_index="+button_index);

    if (button_index != 0) // Button is not OK.
    {
      UI_System_Config_enabled = false;
      return;
    }

    List<Textfield> cp5_tf_list = UI_System_Config_cp5_global.getAll(Textfield.class);
    //println(cp5_tf_list);

    boolean updated = false;

    for (Textfield tf_handle:cp5_tf_list) {
      //println("Id="+tf_handle.getId()+":Text="+tf_handle.getText());
      if (tf_handle.getId() == -1) continue;
      UI_System_Config_tf_enum tf_enum = UI_System_Config_tf_enum.values()[tf_handle.getId()];
      //println("tf_enum="+tf_enum);

      String str;
      int val;

      str = tf_handle.getText();
      switch (tf_enum) {
        case SYSTEM_PASSWORD:
          if (!SYSTEM_PASSWORD.equals(str)) {
            SYSTEM_PASSWORD = str;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated SYSTEM_PASSWORD="+SYSTEM_PASSWORD+",tf_enum="+tf_enum);
          }
          break;
        case FRAME_RATE:
          try {
            val = Integer.parseInt(str.trim());
          }
          catch (NumberFormatException e) {
            val = FRAME_RATE;
          }
          if (FRAME_RATE != val) {
            FRAME_RATE = val;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated FRAME_RATE="+FRAME_RATE+",tf_enum="+tf_enum);
          }
          break;
        case PS_DATA_SAVE_ALWAYS_DURATION:
          try {
            val = int(Float.parseFloat(str.trim()) * 1000.0);
          }
          catch (NumberFormatException e) {
            val = PS_DATA_SAVE_ALWAYS_DURATION;
          }
          if (PS_DATA_SAVE_ALWAYS_DURATION != val) {
            PS_DATA_SAVE_ALWAYS_DURATION = val;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated PS_DATA_SAVE_ALWAYS_DURATION="+PS_DATA_SAVE_ALWAYS_DURATION+",tf_enum="+tf_enum);
          }
          break;
        case PS_DATA_SAVE_EVENTS_DURATION_DEFAULT:
          try {
            val = int(Float.parseFloat(str.trim()) * 1000.0);
          }
          catch (NumberFormatException e) {
            val = PS_DATA_SAVE_EVENTS_DURATION_DEFAULT;
          }
          if (PS_DATA_SAVE_EVENTS_DURATION_DEFAULT != val) {
            PS_DATA_SAVE_EVENTS_DURATION_DEFAULT = val;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated PS_DATA_SAVE_EVENTS_DURATION_DEFAULT="+PS_DATA_SAVE_EVENTS_DURATION_DEFAULT+",tf_enum="+tf_enum);
          }
          break;
        case PS_DATA_SAVE_EVENTS_DURATION_LIMIT:
          try {
            val = int(Float.parseFloat(str.trim()) * 1000.0);
          }
          catch (NumberFormatException e) {
            val = PS_DATA_SAVE_EVENTS_DURATION_LIMIT;
          }
          if (PS_DATA_SAVE_EVENTS_DURATION_LIMIT != val) {
            PS_DATA_SAVE_EVENTS_DURATION_LIMIT = val;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated PS_DATA_SAVE_EVENTS_DURATION_LIMIT="+PS_DATA_SAVE_EVENTS_DURATION_LIMIT+",tf_enum="+tf_enum);
          }
          break;
        case Relay_Module_UART_port_name:
          if (!Relay_Module_UART_port_name.equals(str)) {
            Relay_Module_UART_port_name = str;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated Relay_Module_UART_port_name="+Relay_Module_UART_port_name+",tf_enum="+tf_enum);
          }
          break;
        case ROI_OBJECT_DETECT_DISTANCE_MIN:
          try {
            val = int(Float.parseFloat(str.trim()) * 10000.0);
          }
          catch (NumberFormatException e) {
            val = ROI_OBJECT_DETECT_DISTANCE_MIN;
          }
          if (ROI_OBJECT_DETECT_DISTANCE_MIN != val) {
            ROI_OBJECT_DETECT_DISTANCE_MIN = val;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_DETECT_DISTANCE_MIN="+ROI_OBJECT_DETECT_DISTANCE_MIN+",tf_enum="+tf_enum);
          }
          break;
        case ROI_OBJECT_DETECT_TIME_MIN:
          try {
            val = int(Float.parseFloat(str.trim()) * 1000.0);
          }
          catch (NumberFormatException e) {
            val = ROI_OBJECT_DETECT_TIME_MIN;
          }
          if (ROI_OBJECT_DETECT_TIME_MIN != val) {
            ROI_OBJECT_DETECT_TIME_MIN = val;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_DETECT_TIME_MIN="+ROI_OBJECT_DETECT_TIME_MIN+",tf_enum="+tf_enum);
          }
          break;
        case ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN:
          try {
            val = int(Float.parseFloat(str.trim()) * 10000.0);
          }
          catch (NumberFormatException e) {
            val = ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN;
          }
          if (ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN != val) {
            ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN = val;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN="+ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN+",tf_enum="+tf_enum);
          }
          break;
        case ROI_OBJECT_MARKER_MARGIN:
          try {
            val = Integer.parseInt(str.trim());
          }
          catch (NumberFormatException e) {
            val = ROI_OBJECT_MARKER_MARGIN;
          }
          if (ROI_OBJECT_MARKER_MARGIN != val) {
            ROI_OBJECT_MARKER_MARGIN = val;
            updated = true;
            if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_MARKER_MARGIN="+ROI_OBJECT_MARKER_MARGIN+",tf_enum="+tf_enum);
          }
          break;
        default:
          if (PRINT_UI_SYSTEM_CONFIG_ALL_ERR || PRINT_UI_SYSTEM_CONFIG_LISTENER_ERR) println("UI_System_Config_BT_ControlListener:controlEvent():tf_enum="+tf_enum+" error!");
          break;
      } // End of switch (tf_enum)
    } // End of for (Textfield tf_handle:cp5_tf_list)
    if (updated) {
      Const_create();
      if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated");
      UI_System_Config_changed_any = true;
    }
    else {
      UI_System_Config_enabled = false;
    }
  }

}
