import controlP5.*;

//final static boolean PRINT_UI_INTERFACES_ALL_DBG = true;
final static boolean PRINT_UI_INTERFACES_ALL_DBG = false;
final static boolean PRINT_UI_INTERFACES_ALL_ERR = true;
//final static boolean PRINT_UI_INTERFACES_ALL_ERR = false;

//final static boolean PRINT_UI_INTERFACES_SETUP_DBG = true;
final static boolean PRINT_UI_INTERFACES_SETUP_DBG = false;

//final static boolean PRINT_UI_INTERFACES_UPDATE_DBG = true;
final static boolean PRINT_UI_INTERFACES_UPDATE_DBG = false;

//final static boolean PRINT_UI_INTERFACES_RESET_DBG = true;
final static boolean PRINT_UI_INTERFACES_RESET_DBG = false;

//final static boolean PRINT_UI_INTERFACES_DRAW_DBG = true;
final static boolean PRINT_UI_INTERFACES_DRAW_DBG = false;

static color C_UI_INTERFACES_TEXT = #000000; // Black
static color C_UI_INTERFACES_FILL_NORMAL = #FFFFFF; // White
static color C_UI_INTERFACES_FILL_HIGHLIGHT = #C0C0C0; // White - 0x40
static color C_UI_INTERFACES_BORDER_ACTIVE = #FF0000; // Red
static color C_UI_INTERFACES_BORDER_NORMAL = #000000; // Black
static color C_UI_INTERFACES_CURSOR = #0000FF; // Blue

static boolean UI_Interfaces_enabled;
static boolean UI_Interfaces_is_special;

static ControlFont UI_Interfaces_cf = null;
static ControlP5[] UI_Interfaces_cp5 = new ControlP5[PS_INSTANCE_MAX];

static String[] UI_Interfaces_str_array = {"File", "UART", "UDP", "SN", "NA"};


static boolean[] UI_Interfaces_changed = new boolean[PS_INSTANCE_MAX];
static boolean UI_Interfaces_changed_any = false;
static int[] UI_Interfaces_x_base = new int[PS_INSTANCE_MAX];
static int[] UI_Interfaces_y_base = new int[PS_INSTANCE_MAX];
static boolean[] UI_Interfaces_align_right = new boolean[PS_INSTANCE_MAX];
UI_Interfaces_DDMenu_CallbackListener UI_Interfaces_ddmenu_callback_listener;
UI_Interfaces_TF_FileName_CallbackListener UI_Interfaces_tf_file_name_callback_listener;
UI_Interfaces_CP5_CallbackListener UI_Interfaces_cp5_callback_listener;

static enum UI_Interfaces_state_enum {
  IDLE,
  PASSWORD_REQ,
  WAIT_CONFIG_INPUT,
  DISPLAY_MESSAGE,
  RESET,
  MAX
}
static UI_Interfaces_state_enum UI_Interfaces_state;
static UI_Interfaces_state_enum UI_Interfaces_state_next;
static int UI_Interfaces_timeout_start;

void UI_Interfaces_setup()
{
  if (PRINT_UI_INTERFACES_ALL_DBG || PRINT_UI_INTERFACES_SETUP_DBG) println("UI_Interfaces_setup():Enter");

  boolean found_specific_PS_Interface = false;
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (PS_Interface[i] == PS_Interface_FILE)
    {
      found_specific_PS_Interface = true;
      break;
    }
  }
  int found_count = 0;
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (PS_Interface[i] == PS_Interface_NA)
    {
      found_count ++;
    }
  }
  if (found_count == PS_INSTANCE_MAX)
  {
    found_specific_PS_Interface = true;
  }

  if (found_specific_PS_Interface)
  {
    UI_Interfaces_enabled = true;
    UI_Interfaces_is_special = true;
  }
  else
  {
    UI_Interfaces_enabled = false;
    UI_Interfaces_is_special = false;
  }

  UI_Interfaces_changed_any = false;

  UI_Interfaces_state = UI_Interfaces_state_enum.IDLE;

  UI_Interfaces_ddmenu_callback_listener = new UI_Interfaces_DDMenu_CallbackListener();
  UI_Interfaces_tf_file_name_callback_listener = new UI_Interfaces_TF_FileName_CallbackListener();

  UI_Interfaces_cp5_callback_listener = new UI_Interfaces_CP5_CallbackListener();

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    //UI_Interfaces_changed[i] = true;
    UI_Interfaces_changed[i] = false;
    if (UI_Interfaces_cp5[i] != null)
    {
      UI_Interfaces_reset_instance(i);
    }
    UI_Interfaces_cp5[i] = null;
    switch (i)
    {
      case 0:
        UI_Interfaces_x_base[i] = TEXT_MARGIN;
        //UI_Interfaces_y_base[i] = TEXT_MARGIN + FONT_HEIGHT * 4 + TEXT_MARGIN;
        UI_Interfaces_y_base[i] = SCREEN_height - TEXT_MARGIN - (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN) * 4;
        UI_Interfaces_align_right[i] = false;
        break;
      case 1:
        UI_Interfaces_x_base[i] = SCREEN_width - TEXT_MARGIN;
        //UI_Interfaces_y_base[i] = TEXT_MARGIN + FONT_HEIGHT * 4 + TEXT_MARGIN;
        UI_Interfaces_y_base[i] = SCREEN_height - TEXT_MARGIN - (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN) * 4;
        UI_Interfaces_align_right[i] = true;
        break;
    }
  }
}

void UI_Interfaces_update()
{
  if (PRINT_UI_INTERFACES_ALL_DBG || PRINT_UI_INTERFACES_UPDATE_DBG) println("UI_Interfaces_update():Enter");

  if (!UI_Interfaces_enabled)
  {
    UI_Interfaces_reset();
    return;
  }

  UI_Interfaces_changed_any = false;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    UI_Interfaces_update_instance(i);
  }
}

void UI_Interfaces_update_instance(int instance)
{
  if (PRINT_UI_INTERFACES_ALL_DBG || PRINT_UI_INTERFACES_UPDATE_DBG) println("UI_Interfaces_update_instance("+instance+"):Enter");

  if (!UI_Interfaces_enabled)
  {
    UI_Interfaces_reset_instance(instance);
    return;
  }

  UI_Interfaces_changed[instance] = false;

  int x, y;
  int w, h;
  String str;

  if(UI_Interfaces_cf == null) {
    UI_Interfaces_cf = new ControlFont(SCREEN_PFront,12);
  }

  if(UI_Interfaces_cp5[instance] == null) {
    UI_Interfaces_cp5[instance] = new ControlP5(this, UI_Interfaces_cf);
    UI_Interfaces_cp5[instance].setBackground(C_UI_INTERFACES_FILL_NORMAL);
  }
  else {
    UI_Interfaces_reset_instance(instance);
  }

  textSize(FONT_HEIGHT);
  w = 0;
  for(String s: UI_Interfaces_str_array) {
    w = int(max(w, textWidth(s)));
  }
  w += 20;
  if (UI_Interfaces_align_right[instance])
    x = UI_Interfaces_x_base[instance] - w;
  else
    x = UI_Interfaces_x_base[instance];
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  y = UI_Interfaces_y_base[instance];

  Textfield tf_ddborder;
  tf_ddborder = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_ddborder");
  tf_ddborder
    .setId(instance)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_INTERFACES_FILL_NORMAL)
    .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  /* add a ScrollableList, by default it behaves like a DropdownList */
  ScrollableList sl_ddmenu;
  sl_ddmenu = UI_Interfaces_cp5[instance].addScrollableList("UI_Interfaces_ddmenu"/*l.get(0).toString()*/);
  sl_ddmenu
    .setId(instance)
    .addCallback(UI_Interfaces_ddmenu_callback_listener)
    .setBackgroundColor( C_UI_INTERFACES_BORDER_ACTIVE /*color(255,0,255)*/ /*color( 255 , 128 )*/ )
    .setColorBackground( C_UI_INTERFACES_FILL_NORMAL /*color(255,255,0)*/ /*color(200)*/ )
    .setColorForeground( C_UI_INTERFACES_FILL_HIGHLIGHT /*color(0,255,255)*/ /*color(235)*/ )
    .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE /*color(255,0,0)*/ /*(color(255)*/ )
    .setColorValueLabel( C_UI_INTERFACES_TEXT /*color(0,255,0)*/ /*color(100)*/ )
    .setColorCaptionLabel( C_UI_INTERFACES_TEXT /*color(0,0,255)*/ /*color(50)*/ )
    .setPosition(x + 1, y + 1)
    .setSize(w - 2, h + (h + 1) * (UI_Interfaces_str_array.length - 1) - 2)
    .setBarHeight(h - 2)
    .setItemHeight(h + 1 - 2)
    //.setBarHeight(100)
    //.setItemHeight(100)
    .setOpen(false)
    .addItems(UI_Interfaces_str_array)
    .setCaptionLabel(UI_Interfaces_str_array[PS_Interface[instance]])
    .removeItem(UI_Interfaces_str_array[PS_Interface[instance]])
    .setDirection(Controller.HORIZONTAL)
    //.setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  //y += h;
  sl_ddmenu.getCaptionLabel()
      //.setFont(UI_Interfaces_cf)
      .setSize(FONT_HEIGHT)
      .toUpperCase(false)
      ;
  sl_ddmenu.getCaptionLabel()
      .getStyle()
        //.setPaddingTop(32/2 - 4)
        //.setPaddingTop((32 - 12 ) / 2)
        //.padding(10,10,10,10)
        .marginTop = int(float(FONT_HEIGHT)/2.0-float(FONT_HEIGHT)/6.0);
  sl_ddmenu.getValueLabel()
      //.setFont(UI_Interfaces_cf)
      .setSize(FONT_HEIGHT)
      .toUpperCase(false)
      ;
  sl_ddmenu.getValueLabel()
      .getStyle()
        //.setPaddingTop(32/2 - 4)
        //.setPaddingTop((32 - 12 ) / 2)
        //.padding(10,10,10,10)
        //.marginTop = 32/2-4;
        .marginTop = int(float(FONT_HEIGHT)/2.0-float(FONT_HEIGHT)/6.0) - 1;
  //sl_ddmenu.getValueLabel().getStyle().padding(4,4,3,3);
/*
  CColor c = new CColor();
  c.setBackground(C_UI_INTERFACES_BORDER_ACTIVE);
  //c.setForeground(C_UI_INTERFACES_BORDER_ACTIVE);
  sl_ddmenu.getItem(PS_Interface[instance]).put("color", c);
*/

/*
  str = "Interface:";
  w = int(textWidth(str));
  x -= w + TEXT_MARGIN;
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  Textlabel tl_ddlabel;
  tl_ddlabel = UI_Interfaces_cp5[instance].addTextlabel("UI_Interfaces_ddlabel");
  tl_ddlabel.setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_INTERFACES_TEXT)
    .setHeight(h)
    ;
  tl_ddlabel.get()
      .setSize(FONT_HEIGHT)
      ;
*/

  y += h + TEXT_MARGIN;

  Textfield tf_param1, tf_param2, tf_param3;
  if(PS_Interface[instance] == PS_Interface_FILE) {
    y += (h + TEXT_MARGIN) * 2;
    str = FILE_name[instance];
    w = int(textWidth(str) + TEXT_MARGIN*2);
    if (UI_Interfaces_align_right[instance])
      x = UI_Interfaces_x_base[instance] - w - 1;
    else
      x = UI_Interfaces_x_base[instance] + 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_param1 = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_filename");
    tf_param1
      .setId(instance)
      .addCallback(UI_Interfaces_tf_file_name_callback_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_INTERFACES_FILL_NORMAL )
      .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
      .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_INTERFACES_TEXT )
      .setColorCursor( C_UI_INTERFACES_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_param1.getValueLabel()
        //.setFont(UI_Interfaces_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param1.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param1.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/
  }
  else if(PS_Interface[instance] == PS_Interface_UART) {
    str = UART_port_name;
    w = int(textWidth(str) + TEXT_MARGIN*2);
    if (UI_Interfaces_align_right[instance])
      x = UI_Interfaces_x_base[instance] - w - 1;
    else
      x = UI_Interfaces_x_base[instance] + 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_param1 = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_UARTport");
    tf_param1
      .setId(instance)
      .addCallback(UI_Interfaces_cp5_callback_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_INTERFACES_FILL_NORMAL )
      .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
      .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_INTERFACES_TEXT )
      .setColorCursor( C_UI_INTERFACES_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    tf_param1.getValueLabel()
        //.setFont(UI_Interfaces_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param1.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param1.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/
    y += h + TEXT_MARGIN;
    str = Integer.toString(UART_baud_rate);
    w = int(textWidth(str) + TEXT_MARGIN*2);
    if (UI_Interfaces_align_right[instance])
      x = UI_Interfaces_x_base[instance] - w - 1;
    else
      x = UI_Interfaces_x_base[instance] + 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_param2 = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_UARTbaud");
    tf_param2
      .setId(instance)
      .addCallback(UI_Interfaces_cp5_callback_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_INTERFACES_FILL_NORMAL )
      .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
      .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_INTERFACES_TEXT )
      .setColorCursor( C_UI_INTERFACES_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_param2.getValueLabel()
        //.setFont(UI_Interfaces_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param2.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param2.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/

    y += h + TEXT_MARGIN;
    str = Integer.toString(UART_data_bits) + UART_parity;
    if(int(UART_stop_bits*10.0)%10 == 0)
      str += int(UART_stop_bits);
    else
      str += UART_stop_bits;
    w = int(textWidth(str) + TEXT_MARGIN*2);
    if (UI_Interfaces_align_right[instance])
      x = UI_Interfaces_x_base[instance] - w - 1;
    else
      x = UI_Interfaces_x_base[instance] + 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_param3 = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_UARTdps");
    tf_param3
      .setId(instance)
      .addCallback(UI_Interfaces_cp5_callback_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_INTERFACES_FILL_NORMAL )
      .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
      .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_INTERFACES_TEXT )
      .setColorCursor( C_UI_INTERFACES_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_param3.getValueLabel()
        //.setFont(UI_Interfaces_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param3.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param3.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/
  }
  else if(PS_Interface[instance] == PS_Interface_UDP) {
    str = UDP_remote_ip[instance];
    w = int(textWidth(str) + TEXT_MARGIN*2);
    if (UI_Interfaces_align_right[instance])
      x = UI_Interfaces_x_base[instance] - w - 1;
    else
      x = UI_Interfaces_x_base[instance] + 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_param1 = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_UDPremoteip");
    tf_param1
      .setId(instance)
      .addCallback(UI_Interfaces_cp5_callback_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_INTERFACES_FILL_NORMAL )
      .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
      .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_INTERFACES_TEXT )
      .setColorCursor( C_UI_INTERFACES_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //Textfield.cursorWidth = 10;
    //controlP5.Textfield.cursorWidth = 10;
    //println("tf.getText() = ", tf.getText());
    tf_param1.getValueLabel()
        //.setFont(UI_Interfaces_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param1.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param1.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/

    y += h + TEXT_MARGIN;
    str = Integer.toString(UDP_remote_port[instance]);
    w = int(textWidth(str) + TEXT_MARGIN*2);
    if (UI_Interfaces_align_right[instance])
      x = UI_Interfaces_x_base[instance] - w - 1;
    else
      x = UI_Interfaces_x_base[instance] + 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_param2 = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_UDPremoteport");
    tf_param2
      .setId(instance)
      .addCallback(UI_Interfaces_cp5_callback_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_INTERFACES_FILL_NORMAL )
      .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
      .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_INTERFACES_TEXT )
      .setColorCursor( C_UI_INTERFACES_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_param2.getValueLabel()
        //.setFont(UI_Interfaces_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param2.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param2.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/

    y += h + TEXT_MARGIN;
    str = Integer.toString(UDP_local_port[instance]);
    w = int(textWidth(str) + TEXT_MARGIN*2);
    if (UI_Interfaces_align_right[instance])
      x = UI_Interfaces_x_base[instance] - w - 1;
    else
      x = UI_Interfaces_x_base[instance] + 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_param3 = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_UDPlocalport");
    tf_param3
      .setId(instance)
      .addCallback(UI_Interfaces_cp5_callback_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_INTERFACES_FILL_NORMAL )
      .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
      .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_INTERFACES_TEXT )
      .setColorCursor( C_UI_INTERFACES_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_param3.getValueLabel()
        //.setFont(UI_Interfaces_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param3.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param3.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/
  }
  else if(PS_Interface[instance] == PS_Interface_SN) {
    str = Integer.toString(SN_serial_number[instance]);
    w = int(textWidth(str) + TEXT_MARGIN*2);
    if (UI_Interfaces_align_right[instance])
      x = UI_Interfaces_x_base[instance] - w - 1;
    else
      x = UI_Interfaces_x_base[instance] + 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_param1 = UI_Interfaces_cp5[instance].addTextfield("UI_Interfaces_SNserialnumber");
    tf_param1
      .setId(instance)
      .addCallback(UI_Interfaces_cp5_callback_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_INTERFACES_FILL_NORMAL )
      .setColorForeground( C_UI_INTERFACES_BORDER_NORMAL )
      .setColorActive( C_UI_INTERFACES_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_INTERFACES_TEXT )
      .setColorCursor( C_UI_INTERFACES_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //Textfield.cursorWidth = 10;
    //controlP5.Textfield.cursorWidth = 10;
    //println("tf.getText() = ", tf.getText());
    tf_param1.getValueLabel()
        //.setFont(UI_Interfaces_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param1.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param1.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/

  }
  else {// if (PS_Interface[instance] == PS_Interface_NA) {
    // Nothing to do.
  }

  tf_ddborder.bringToFront();
  sl_ddmenu.bringToFront();
  //println(sl_ddmenu.getBackgroundColor());
  //printArray(PFont.list());
}

void UI_Interfaces_reset()
{
  if (PRINT_UI_INTERFACES_ALL_DBG || PRINT_UI_INTERFACES_RESET_DBG) println("UI_Interfaces_reset():Enter");

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    UI_Interfaces_reset_instance(i);
    UI_Interfaces_cp5[i] = null;
  }
}

void UI_Interfaces_reset_instance(int instance)
{
  if (PRINT_UI_INTERFACES_ALL_DBG || PRINT_UI_INTERFACES_RESET_DBG) println("UI_Interfaces_reset_instance"+instance+"):Enter");

  if(UI_Interfaces_cp5[instance] == null) {
    return;
  }

  List<ControllerInterface<?>> cp5_list = UI_Interfaces_cp5[instance].getAll();

  for (ControllerInterface controller:cp5_list)
  {
    //println("name:"+controller.getName());
    UI_Interfaces_cp5[instance].remove(controller.getName());
  }

  UI_Interfaces_cp5[instance].setGraphics(this,0,0);
}

void UI_Interfaces_draw()
{
  if (PRINT_UI_INTERFACES_ALL_DBG || PRINT_UI_INTERFACES_DRAW_DBG) println("UI_Interfaces_draw():Enter");

  //println("UI_Interfaces_state=", UI_Interfaces_state);
  switch (UI_Interfaces_state)
  {
    case IDLE:
      if (!UI_Interfaces_enabled)
      {
        break;
      }

      /**/
      // Disable other config UI if enabled.
      if (UI_System_Config_enabled)
      {
        UI_System_Config_enabled = false;
        break;
      }
      if (UI_Regions_Config_enabled)
      {
        UI_Regions_Config_enabled = false;
        break;
      }
      /**/

      // Check password not required.
      if (SYSTEM_PASSWORD_disabled
          ||
          UI_Interfaces_is_special)
      {
        UI_Interfaces_state = UI_Interfaces_state_enum.WAIT_CONFIG_INPUT;
        UI_Interfaces_update();
        UI_Interfaces_changed_any = false;
        UI_Interfaces_timeout_start = millis();
        break;
      }

      UI_Num_Pad_setup("Input system password");
      UI_Interfaces_state = UI_Interfaces_state_enum.PASSWORD_REQ;
      UI_Interfaces_timeout_start = millis();
      break;
    case PASSWORD_REQ:
      if (!UI_Interfaces_enabled)
      {
        //UI_Interfaces_reset();
        UI_Interfaces_state = UI_Interfaces_state_enum.IDLE;
        break;
      }

      /*
      // Disable this config UI if other config UI enabled.
      if (UI_System_Config_enabled)
      {
        UI_Interfaces_enabled = false;
        UI_Interfaces_state = UI_Interfaces_state_enum.IDLE;
        break;
      }
      */

      if (get_millis_diff(UI_Interfaces_timeout_start) > SYSTEM_UI_TIMEOUT * 1000)
      {
        UI_Interfaces_enabled = false;
        UI_Interfaces_state = UI_Interfaces_state_enum.IDLE;
        break;
      }

      UI_Num_Pad_handle.draw();
      if (!UI_Num_Pad_handle.input_done())
      {
        break;
      }

      if (UI_Num_Pad_handle.input_string == null)
      {
        //UI_Interfaces_reset();
        UI_Interfaces_enabled = false;
        UI_Interfaces_state = UI_Interfaces_state_enum.IDLE;
        break;
      }

      // Input done, check password.
      if (!UI_Num_Pad_handle.input_string.equals(SYSTEM_PASSWORD))
      {
        // Password fail...
        UI_Message_Box_setup("Error !", "Wrong password input!\nYou can NOT access special functions.", 5000);
        UI_Interfaces_state = UI_Interfaces_state_enum.DISPLAY_MESSAGE;
        UI_Interfaces_state_next = UI_Interfaces_state_enum.IDLE;
        UI_Interfaces_enabled = false;
        break;
      }
      UI_Interfaces_state = UI_Interfaces_state_enum.WAIT_CONFIG_INPUT;
      UI_Interfaces_update();
      UI_Interfaces_changed_any = false;
      UI_Interfaces_timeout_start = millis();
      break;
    case WAIT_CONFIG_INPUT:
      if (!UI_Interfaces_enabled)
      {
        UI_Interfaces_reset();
        UI_Interfaces_state = UI_Interfaces_state_enum.IDLE;
        break;
      }

      if (!UI_Interfaces_is_special
          &&
          get_millis_diff(UI_Interfaces_timeout_start) > SYSTEM_UI_TIMEOUT * 1000)
      {
        UI_Interfaces_reset();
        UI_Interfaces_enabled = false;
        UI_Interfaces_state = UI_Interfaces_state_enum.IDLE;
        break;
      }

      break;
    case DISPLAY_MESSAGE:
      if (UI_Message_Box_handle.draw())
      {
        break;
      }
      UI_Interfaces_state = UI_Interfaces_state_next;
      break;
    case RESET:
      // To restart program set frameCount to -1, this wiil call setup() of main.
      frameCount = -1;
      break;
  }
}

/*
private void UI_Interfaces_key_pressed()
{
  println("UI_Interfaces_key_pressed():keyPressed " + int(key) + " " + keyCode);
  if (!(key == CONTROL && keyCode == 'v' || keyCode == 'V'))
  {
    return;
  }

  // Ctrl+V key pressed, copy clipboard text to tf of filename.
  // Find instance of tf for this.
  int instance;
  Textfield tf = null;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    tf = (Textfield)(UI_Interfaces_cp5[instance].get(Textfield.class, "UI_Interfaces_filename"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_key_pressed():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_key_pressed():instance="+instance+":id="+tf.getId()+",isFocus="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance == PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_key_pressed():Can't found instance.");
    return;
  }

  String cb_str = get_clipboard_string();
  if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_key_pressed():instance="+instance+":cb_str="+cb_str);
  if (cb_str == null)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_key_pressed():instance="+instance+":cb_str=null");
    return;
  }
  tf.setText(tf.getText()+cb_str);
}
*/

private void UI_Interfaces_tf_file_name_mouse_pressed_right(int instance)
{
  Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get(Textfield.class, "UI_Interfaces_filename"));
  if (tf == null)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_tf_file_name_mouse_pressed_right("+instance+"):tf==null");
    return;
  }
  if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_tf_file_name_mouse_pressed_right("+instance+"):id="+tf.getId()+",isFocus="+tf.isFocus());
  if (tf.getId() != instance
      ||
      !tf.isFocus())
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_tf_file_name_mouse_pressed_right("+instance+"):id="+tf.getId()+",isFocus="+tf.isFocus());
    return;
  }

  String cb_str = get_clipboard_string();
  if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_tf_file_name_mouse_pressed_right("+instance+"):cb_str="+cb_str);
  if (cb_str == null)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_tf_file_name_mouse_pressed_right("+instance+"):cb_str=null");
    return;
  }
  tf.setText(tf.getText()+cb_str);
}

void UI_Interfaces_ddmenu_mouse_released(int instance)
{
  if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_ddmenu_mouse_released("+instance+"):ENTER");

  ScrollableList sl_ddmenu = UI_Interfaces_cp5[instance].get(ScrollableList.class, "UI_Interfaces_ddmenu");
  if (sl_ddmenu == null)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_ddmenu_mouse_released("+instance+"):sl_ddmenu=null");
  }

  if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_ddmenu_mouse_released("+instance+"):sl_ddmenu.isOpen()="+sl_ddmenu.isOpen());

  Textfield tf_ddborder;
  int x, y, w, h;
  int c;

  textSize(FONT_HEIGHT);
  w = 0;
  for(String s: UI_Interfaces_str_array) {
    w = int(max(w, textWidth(s)));
  }
  w += 20;
  if (UI_Interfaces_align_right[instance])
    x = UI_Interfaces_x_base[instance] - w;
  else
    x = UI_Interfaces_x_base[instance];
  if(sl_ddmenu.isOpen()) {
    h = FONT_HEIGHT + TEXT_MARGIN*2 + (FONT_HEIGHT + TEXT_MARGIN*2 + 1 - 2) * (UI_Interfaces_str_array.length - 1);
    c = C_UI_INTERFACES_BORDER_ACTIVE;
  }
  else {
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    c = C_UI_INTERFACES_BORDER_NORMAL;
  }
  y = UI_Interfaces_y_base[instance];
  tf_ddborder = (Textfield)UI_Interfaces_cp5[instance].get(Textfield.class, "UI_Interfaces_ddborder");
  if (tf_ddborder == null)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_ddmenu_mouse_released("+instance+"):tf_ddborder=null");
    return;
  }
  tf_ddborder
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorForeground( c )
    ;
  sl_ddmenu
    .setItems(UI_Interfaces_str_array)
    .removeItem(UI_Interfaces_str_array[PS_Interface[instance]])
    ;
}

void UI_Interfaces_ddmenu_mouse_leave(int instance)
{
  if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_ddmenu_mouse_leave("+instance+"):ENTER");

  ScrollableList sl_ddmenu = UI_Interfaces_cp5[instance].get(ScrollableList.class, "UI_Interfaces_ddmenu");
  if (sl_ddmenu == null)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_ddmenu_mouse_leave("+instance+"):sl_ddmenu=null");
  }

  if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_ddmenu_mouse_leave("+instance+"):sl_ddmenu.isOpen()="+sl_ddmenu.isOpen());

  if (!sl_ddmenu.isOpen())
  {
    // Already closed. So, nothing to do.
    return;
  }

  Textfield tf_ddborder;
  int x, y, w, h;
  int c;

  w = 0;
  for(String s: UI_Interfaces_str_array) {
    w = int(max(w, textWidth(s)));
  }
  w += 20;
  if (UI_Interfaces_align_right[instance])
    x = UI_Interfaces_x_base[instance] - w;
  else
    x = UI_Interfaces_x_base[instance];
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  c = C_UI_INTERFACES_BORDER_NORMAL;
  y = UI_Interfaces_y_base[instance];
  tf_ddborder = (Textfield)UI_Interfaces_cp5[instance].get(Textfield.class, "UI_Interfaces_ddborder");
  if (tf_ddborder == null)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_ddmenu_mouse_leave("+instance+"):tf_ddborder=null");
    return;
  }
  tf_ddborder
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorForeground( c )
    ;
  sl_ddmenu.close();
}

void UI_Interfaces_mouse_released(int instance)
{
  Textfield tf_param;
  String str;

  if(PS_Interface[instance] == PS_Interface_FILE) {
    tf_param = (Textfield)UI_Interfaces_cp5[instance].get("UI_Interfaces_filename");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = FILE_name[instance];
      tf_param.setText(str);
    }
  }
  else if(PS_Interface[instance] == PS_Interface_UART) {
    tf_param = (Textfield)UI_Interfaces_cp5[instance].get("UI_Interfaces_UARTport");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = UART_port_name;
      tf_param.setText(str);
    }
    tf_param = (Textfield)UI_Interfaces_cp5[instance].get("UI_Interfaces_UARTbaud");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = Integer.toString(UART_baud_rate);
      tf_param.setText(str);
    }
    tf_param = (Textfield)UI_Interfaces_cp5[instance].get("UI_Interfaces_UARTdps");
     if( tf_param != null && tf_param.isFocus() == false) {
     str = Integer.toString(UART_data_bits) + UART_parity;
      if(int(UART_stop_bits*10.0)%10 == 0)
        str += int(UART_stop_bits);
      else
        str += UART_stop_bits;
      tf_param.setText(str);
    }
  }
  else if(PS_Interface[instance] == PS_Interface_UDP) {
    tf_param = (Textfield)UI_Interfaces_cp5[instance].get("UI_Interfaces_UDPremoteip");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = UDP_remote_ip[instance];
      tf_param.setText(str);
    }
    tf_param = (Textfield)UI_Interfaces_cp5[instance].get("UI_Interfaces_UDPremoteport");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = Integer.toString(UDP_remote_port[instance]);
      tf_param.setText(str);
    }
    tf_param = (Textfield)UI_Interfaces_cp5[instance].get("UI_Interfaces_UDPlocalport");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = Integer.toString(UDP_local_port[instance]);
      tf_param.setText(str);
    }
  }
  else if(PS_Interface[instance] == PS_Interface_SN) {
    tf_param = (Textfield)UI_Interfaces_cp5[instance].get("UI_Interfaces_SNserialnumber");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = Integer.toString(SN_serial_number[instance]);
      tf_param.setText(str);
    }
  }
  else { // if(PS_Interface[instance] == PS_Interface_NA) {
    // Nothing to do.
  }
}

/*
void controlEvent(ControlEvent theEvent)
{
  String ControllerName = theEvent.getController().getName();
  println("got a control event from controller with name "+","+ControllerName);

  if (ControllerName.equals("UI_Interfaces_ddmenu") == true) {
    println("this event was triggered by Controller UI_Interfaces_ddmenu");
  }
  
}
*/

void UI_Interfaces_ddmenu(int n)
{
  if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_ddmenu("+n+"):ENTER");
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    ScrollableList sl_ddmenu = (ScrollableList)(UI_Interfaces_cp5[instance].get("UI_Interfaces_ddmenu"));
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_ddmenu("+n+"):instance="+instance+":id="+sl_ddmenu.getId()+",isOpen="+sl_ddmenu.isOpen());
    if (sl_ddmenu.getId() == instance
        &&
        sl_ddmenu.isOpen())
    {
      break;
    }
  }
  if (instance == PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_ddmenu():Can't found instance.");
    return;
  }

  if( n >= PS_Interface[instance] ) n ++;

  if( PS_Interface[instance] != n ) {
    PS_Interface[instance] = n;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

void UI_Interfaces_filename(String theText)
{
  // Find instance of tf for this.
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get("UI_Interfaces_filename"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_filename():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_filename():instance="+instance+":id="+tf.getId()+",isFocus="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance >= PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_filename():Can't found instance.");
    return;
  }

  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(!theText.equals(FILE_name[instance])) {
    FILE_name[instance] = theText;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

void UI_Interfaces_UARTport(String theText)
{
  // Find instance of tf for this.
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get("UI_Interfaces_UARTport"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UARTport():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UARTport():instance="+instance+":id="+tf.getId()+",isFocus="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance >= PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_UARTport():Can't found instance.");
    return;
  }

  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(theText.equals(UART_port_name) != true) {
    UART_port_name = theText;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

void UI_Interfaces_UARTbaud(String theText)
{
  // Find instance of tf for this.
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get("UI_Interfaces_UARTbaud"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UARTbaud():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UARTbaud():instance="+instance+":id="+tf.getId()+",isFocus="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance >= PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_UARTbaud():Can't found instance.");
    return;
  }

  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int baud_rate = Integer.parseInt(theText);
  if(baud_rate != UART_baud_rate) {
    UART_baud_rate = baud_rate;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

void UI_Interfaces_UARTdps(String theText)
{
  // Find instance of tf for this.
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get("UI_Interfaces_UARTdps"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UARTdps():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UARTdps():instance="+instance+":id="+tf.getId()+",isOpen="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance >= PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_UARTdps():Can't found instance.");
    return;
  }

  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int data_bits = Character.getNumericValue(theText.charAt(0));
  char parity = theText.charAt(1);
  float stop_bits = Float.valueOf(theText.substring(2));
  if( data_bits != UART_data_bits ||
      parity != UART_parity ||
      stop_bits != UART_stop_bits) {
    UART_data_bits = data_bits;
    UART_parity = parity;
    UART_stop_bits = stop_bits;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

void UI_Interfaces_UDPremoteip(String theText)
{
  // Find instance of tf for this.
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get("UI_Interfaces_UDPremoteip"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UDPremoteip():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UDPremoteip():instance="+instance+":id="+tf.getId()+",isOpen="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance >= PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_UDPremoteip():Can't found instance.");
    return;
  }

  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(!theText.equals(UDP_remote_ip[instance])) {
    UDP_remote_ip[instance] = theText;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

void UI_Interfaces_UDPremoteport(String theText)
{
  // Find instance of tf for this.
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get("UI_Interfaces_UDPremoteport"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UDPremoteport():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UDPremoteport():instance="+instance+":id="+tf.getId()+",isOpen="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance >= PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_UDPremoteport():Can't found instance.");
    return;
  }

  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int remote_port = Integer.parseInt(theText);
  if(remote_port != UDP_remote_port[instance]) {
    UDP_remote_port[instance] = remote_port;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

void UI_Interfaces_UDPlocalport(String theText)
{
  // Find instance of tf for this.
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get("UI_Interfaces_UDPlocalport"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UDPlocalport():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_UDPlocalport():instance="+instance+":id="+tf.getId()+",isFocus="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance >= PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_UDPlocalport():Can't found instance.");
    return;
  }

  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int local_port = Integer.parseInt(theText);
  if(local_port != UDP_local_port[instance]) {
    UDP_local_port[instance] = local_port;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

void UI_Interfaces_SNserialnumber(String theText)
{
  // Find instance of tf for this.
  int instance;
  for (instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    Textfield tf = (Textfield)(UI_Interfaces_cp5[instance].get("UI_Interfaces_SNserialnumber"));
    if (tf == null)
    {
      if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_SNserialnumber():tf=null");
      continue;
    }
    if (PRINT_UI_INTERFACES_ALL_DBG) println("UI_Interfaces_SNserialnumber():instance="+instance+":id="+tf.getId()+",isOpen="+tf.isFocus());
    if (tf.getId() == instance
        &&
        tf.isFocus())
    {
      break;
    }
  }
  if (instance >= PS_INSTANCE_MAX)
  {
    if (PRINT_UI_INTERFACES_ALL_ERR) println("UI_Interfaces_SNserialnumber():Can't found instance.");
    return;
  }

  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int serial_number = Integer.parseInt(theText);
  if(serial_number != SN_serial_number[instance]) {
    SN_serial_number[instance] = serial_number;
    Config_save();
    UI_Interfaces_changed[instance] = true;
    UI_Interfaces_changed_any = true;
  }
}

class UI_Interfaces_DDMenu_CallbackListener implements CallbackListener {
  public void controlEvent(CallbackEvent theEvent) {
    UI_Interfaces_timeout_start = millis();
/*
    switch(theEvent.getAction()) {
      case(ControlP5.ACTION_ENTER): 
        println("UI_Interfaces_DDMenu_CallbackListener:controlEvent():Action:ENTER");
        break;
      case(ControlP5.ACTION_LEAVE): 
        println("UI_Interfaces_DDMenu_CallbackListener:controlEvent():Action:LEAVE");
        break;
      case(ControlP5.ACTION_PRESSED): 
        println("UI_Interfaces_DDMenu_CallbackListener:controlEvent():Action:PRESSED");
        break;
      case(ControlP5.ACTION_RELEASED): 
        println("UI_Interfaces_DDMenu_CallbackListener:controlEvent():Action:RELEASED");
        break;
      case(ControlP5.ACTION_RELEASEDOUTSIDE): 
        println("UI_Interfaces_DDMenu_CallbackListener:controlEvent():Action:RELEASED OUTSIDE");
        break;
      case(ControlP5.ACTION_BROADCAST): 
        println("UI_Interfaces_DDMenu_CallbackListener:controlEvent():Action:BROADCAST");
        break;
      default:
        println("UI_Interfaces_DDMenu_CallbackListener:controlEvent():Action:"+theEvent.getAction());
        break;
    }
*/
    if (theEvent.getAction() == ControlP5.ACTION_RELEASED) {
      //ScrollableList sl_ddmenu = (ScrollableList)theEvent.getController();;
      UI_Interfaces_ddmenu_mouse_released(theEvent.getController().getId());
    }
    if (theEvent.getAction() == ControlP5.ACTION_LEAVE) {
      //ScrollableList sl_ddmenu = (ScrollableList)theEvent.getController();;
      UI_Interfaces_ddmenu_mouse_leave(theEvent.getController().getId());
    }
  }
}

/*
// Custom key input handler for the filename
final CustomKeyEvent nin = new CustomKeyEvent();

public class CustomKeyEvent {
  public void keyEvent(KeyEvent theKeyEvent) {
    println("UI_Interfaces_TF_FileName_CallbackListener:keyEvent():theKeyEvent action=" + theKeyEvent.getAction() + ",key code=" + theKeyEvent.getKeyCode() + ",key=" + theKeyEvent.getKey());
    // only process key event if input is active 
    if (k.getAction()==KeyEvent.PRESS && active) {
      if (k.getKey()=='\n') { // confirm input with enter
        submit();
        return;
      } else if(k.getKeyCode()==BACKSPACE) { 
        text = text.isEmpty() ? "":text.substring(0, text.length()-1);
        //text = ""; // clear all text with backspace
      }
      else if(k.getKey()<255) {
        // check if the input is a valid (decimal) number
        final String regex = "\\d+([.]\\d{0,2})?";
        String s = text + k.getKey();
        if ( java.util.regex.Pattern.matches(regex, s ) ) {
          text += k.getKey();
        }
      }
      n.getValueLabel().setText(this.text);
    }
  }
}
*/

class UI_Interfaces_TF_FileName_CallbackListener implements CallbackListener {
  public void controlEvent(CallbackEvent theEvent) {
    UI_Interfaces_timeout_start = millis();
/*
    switch(theEvent.getAction()) {
      case(ControlP5.ACTION_ENTER): 
        println("UI_Interfaces_TF_FileName_CallbackListener:controlEvent():Action:ENTER");
        break;
      case(ControlP5.ACTION_LEAVE): 
        println("UI_Interfaces_TF_FileName_CallbackListener:controlEvent():Action:LEAVE");
        break;
      case(ControlP5.ACTION_PRESSED): 
        println("UI_Interfaces_TF_FileName_CallbackListener:controlEvent():Action:PRESSED");
        break;
      case(ControlP5.ACTION_RELEASED): 
        println("UI_Interfaces_TF_FileName_CallbackListener:controlEvent():Action:RELEASED");
        break;
      case(ControlP5.ACTION_RELEASEDOUTSIDE): 
        println("UI_Interfaces_TF_FileName_CallbackListener:controlEvent():Action:RELEASED OUTSIDE");
        break;
      case(ControlP5.ACTION_BROADCAST): 
        println("UI_Interfaces_TF_FileName_CallbackListener:controlEvent():Action:BROADCAST");
        break;
      default:
        println("UI_Interfaces_TF_FileName_CallbackListener:controlEvent():Action:"+theEvent.getAction());
        break;
    }
*/
    if (theEvent.getAction() == ControlP5.ACTION_PRESSED && mouseButton == RIGHT) {
      //ScrollableList sl_ddmenu = (ScrollableList)theEvent.getController();;
      UI_Interfaces_tf_file_name_mouse_pressed_right(theEvent.getController().getId());
    }
  }
}

class UI_Interfaces_CP5_CallbackListener implements CallbackListener {
  public void controlEvent(CallbackEvent theEvent) {
    UI_Interfaces_timeout_start = millis();
  }
}
