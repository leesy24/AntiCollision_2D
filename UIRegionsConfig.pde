import controlP5.*;

//final static boolean PRINT_UI_REGIONS_CONFIG_ALL_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_ALL_DBG = false;
final static boolean PRINT_UI_REGIONS_CONFIG_ALL_ERR = true;
//final static boolean PRINT_UI_REGIONS_CONFIG_ALL_ERR = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_SETUP_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_SETUP_DBG = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_UPDATE_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_UPDATE_DBG = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_RESET_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_RESET_DBG = false;

static color C_UI_REGIONS_CONFIG_TEXT = #000000; // Black
static color C_UI_REGIONS_CONFIG_FILL_NORMAL = #FFFFFF; // White
static color C_UI_REGIONS_CONFIG_FILL_HIGHLIGHT = #C0C0C0; // White - 0x40
static color C_UI_REGIONS_CONFIG_BORDER_ACTIVE = #FF0000; // Red
static color C_UI_REGIONS_CONFIG_BORDER_NORMAL = #000000; // Black
static color C_UI_REGIONS_CONFIG_CURSOR = #0000FF; // Blue

static boolean UI_Regions_Config_enabled;

static ControlFont UI_Regions_Config_cf = null;
static ControlP5 UI_Regions_Config_cp5_global = null;
static ControlP5[] UI_Regions_Config_cp5_local = new ControlP5[PS_INSTANCE_MAX];

static boolean[] UI_Regions_Config_changed = new boolean[PS_INSTANCE_MAX];
static boolean UI_Regions_Config_changed_any = false;
static int[] UI_Regions_Config_x_base = new int[PS_INSTANCE_MAX];
static int[] UI_Regions_Config_y_base = new int[PS_INSTANCE_MAX];
UI_Regions_Config_BT_ControlListener UI_Regions_Config_bt_control_listener;
//UI_Regions_Config_TF_ControlListener UI_Regions_Config_tf_control_listener;

void UI_Regions_Config_setup()
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_SETUP_DBG) println("UI_Regions_Config_setup():Enter");

  //UI_Regions_Config_enabled = true;
  UI_Regions_Config_enabled = false;

  UI_Regions_Config_changed_any = false;

  if (UI_Regions_Config_cp5_global != null)
  {
    UI_Regions_Config_reset();
  }
  UI_Regions_Config_cp5_global = null;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    //UI_Regions_Config_changed[i] = true;
    UI_Regions_Config_changed[i] = false;
    if (UI_Regions_Config_cp5_local[i] != null)
    {
      UI_Regions_Config_reset_instance(i);
    }
    UI_Regions_Config_cp5_local[i] = null;
    switch (i)
    {
      case 0:
        UI_Regions_Config_x_base[i] = TEXT_MARGIN;
        UI_Regions_Config_y_base[i] = TEXT_MARGIN;
        break;
      case 1:
        UI_Regions_Config_x_base[i] = SCREEN_width / 2;
        UI_Regions_Config_y_base[i] = TEXT_MARGIN;
        break;
    }
  }
  if (UI_Regions_Config_enabled)
  {
    UI_Regions_Config_update();
  }
}

void UI_Regions_Config_update()
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_UPDATE_DBG) println("UI_Regions_Config_update():Enter");

  if (!UI_Regions_Config_enabled)
  {
    UI_Regions_Config_reset();
    return;
  }

  UI_Regions_Config_changed_any = false;

  UI_Regions_Config_bt_control_listener = new UI_Regions_Config_BT_ControlListener();
  //UI_Regions_Config_tf_control_listener = new UI_Regions_Config_TF_ControlListener();

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    UI_Regions_Config_update_instance(i);
  }

  int x, y;
  int w, h;
  String str;

  if(UI_Regions_Config_cp5_global == null) {
    UI_Regions_Config_cp5_global = new ControlP5(this, UI_Regions_Config_cf);
    UI_Regions_Config_cp5_global.setBackground(C_UI_REGIONS_CONFIG_FILL_NORMAL);
  }
  else {
    UI_Regions_Config_reset();
  }

  Textfield tf_handle;
  Button bt_handle;

  // Outline border
  w = (FONT_HEIGHT * 7 + TEXT_MARGIN * 2) * 2 + FONT_HEIGHT * 2 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 - w / 2;
  h = FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1 - TEXT_MARGIN;
  tf_handle = UI_Regions_Config_cp5_global.addTextfield("UI_Regions_Config_buttons_border");
  tf_handle
    .setId(-1)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_REGIONS_CONFIG_FILL_NORMAL)
    .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  str = "OK";
  w = FONT_HEIGHT * 7 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 - w - FONT_HEIGHT;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1;
  bt_handle = UI_Regions_Config_cp5_global.addButton(str);
  bt_handle.setId(0)
    .addListener(UI_Regions_Config_bt_control_listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setColorBackground( C_UI_REGIONS_CONFIG_FILL_HIGHLIGHT ) // Button fill color, when mouse is not over.
    .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL ) // Button fill color, when mouse over.
    .setColorActive(C_UI_REGIONS_CONFIG_BORDER_ACTIVE) // Button fill color, when mouse pressed.
    .setColorLabel( C_UI_REGIONS_CONFIG_FILL_NORMAL ) // Button text color
    ;
//  bt_handle.get()
//    .setSize(FONT_HEIGHT)
//    ;

  str = "Cancel";
  w = FONT_HEIGHT * 7 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 + FONT_HEIGHT;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1;
  bt_handle = UI_Regions_Config_cp5_global.addButton(str);
  bt_handle.setId(1)
    .addListener(UI_Regions_Config_bt_control_listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setColorBackground( C_UI_REGIONS_CONFIG_FILL_HIGHLIGHT ) // Button fill color, when mouse is not over.
    .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL ) // Button fill color, when mouse over.
    .setColorActive(C_UI_REGIONS_CONFIG_BORDER_ACTIVE) // Button fill color, when mouse pressed.
    .setColorLabel( C_UI_REGIONS_CONFIG_FILL_NORMAL ) // Button text color
    ;
//  bt_handle.get()
//    .setSize(FONT_HEIGHT)
//    ;
}

void UI_Regions_Config_update_instance(int instance)
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_UPDATE_DBG) println("UI_Regions_Config_update_instance("+instance+"):Enter");

  if (!UI_Regions_Config_enabled)
  {
    UI_Regions_Config_reset_instance(instance);
    return;
  }

  UI_Regions_Config_changed[instance] = false;

  int x, y;
  int w, h;
  String str;

  if(UI_Regions_Config_cf == null) {
    UI_Regions_Config_cf = new ControlFont(SCREEN_PFront,FONT_HEIGHT);
  }

  if(UI_Regions_Config_cp5_local[instance] == null) {
    UI_Regions_Config_cp5_local[instance] = new ControlP5(this, UI_Regions_Config_cf);
    UI_Regions_Config_cp5_local[instance].setBackground(C_UI_REGIONS_CONFIG_FILL_NORMAL);
  }
  else {
    UI_Regions_Config_reset_instance(instance);
  }

  Textlabel tl_handle;
  Textfield tf_handle;
  Button bt_handle;

  // Outline border
  w = SCREEN_width / 2 - TEXT_MARGIN;
  x = UI_Regions_Config_x_base[instance];
  h = SCREEN_height - TEXT_MARGIN * 2;
  y = UI_Regions_Config_y_base[instance];
  Textfield tf_outline_border;
  tf_outline_border = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_outline_border");
  tf_outline_border
    .setId(-1)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_REGIONS_CONFIG_FILL_NORMAL)
    .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  // Title
  textSize(FONT_HEIGHT);
  str = "Regions "+instance+" Config";
  w = int(textWidth(str));
  x = UI_Regions_Config_x_base[instance] + (SCREEN_width / 2 - TEXT_MARGIN * 2) / 2 - w / 2;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y += TEXT_MARGIN;
  tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_title_label");
  tl_handle
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  for (int region_csv_index = 0; region_csv_index < Regions_handle.get_regions_csv_size_for_index(instance); region_csv_index ++)
  {
    int w_max;
    int id_index;

    w_max = MIN_INT;
    id_index = 0;

    // Region name
    x = UI_Regions_Config_x_base[instance] + FONT_HEIGHT;
    y = UI_Regions_Config_y_base[instance] + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
    y += (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN + TEXT_MARGIN) * 4 * region_csv_index;
    str = "Region name";
    w = int(textWidth(str));
    w_max = max(w_max, w + FONT_HEIGHT);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_region_name_"+region_csv_index);
    tl_handle
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    x += FONT_HEIGHT;

    // Priority
    y += h + TEXT_MARGIN;
    str = "Priority";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_priority_"+region_csv_index);
    tl_handle
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    // Relay index
    y += h + TEXT_MARGIN;
    str = "Relay index";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_relay_index_"+region_csv_index);
    tl_handle
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    // No mark big
    y += h + TEXT_MARGIN;
    str = "No mark big";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_no_mark_big_"+region_csv_index);
    tl_handle
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    x += w_max + FONT_HEIGHT;
    y = UI_Regions_Config_y_base[instance] + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
    //y = UI_Regions_Config_y_base[instance] + FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN;
    y += (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN + TEXT_MARGIN) * 4 * region_csv_index;

    w_max = MIN_INT;

    // Region name input
    //y += h + TEXT_MARGIN;
    str = Regions_handle.get_region_csv_name(instance, region_csv_index);
    w = int(textWidth(str) + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_region_name_input_"+region_csv_index);
    tf_handle
      .setId(instance*100+region_csv_index*10+id_index++)
      //.addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Priority input
    y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_priority(instance, region_csv_index));
    w = int(textWidth(str) + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_priority_input_"+region_csv_index);
    tf_handle
      .setId(instance*100+region_csv_index*10+id_index++)
      //.addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Relay index input
    y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_relay_index(instance, region_csv_index));
    w = int(textWidth(str) + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_relay_index_input_"+region_csv_index);
    tf_handle
      .setId(instance*100+region_csv_index*10+id_index++)
      //.addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // No mark big input
    y += h + TEXT_MARGIN;
    str = Regions_handle.get_region_csv_no_mark_big(instance, region_csv_index)?"true":"false";
    w = int(textWidth("false") + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_no_mark_bit_input_"+region_csv_index);
    tf_handle
      .setId(instance*100+region_csv_index*10+id_index++)
      //.addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    x += w_max + FONT_HEIGHT * 3;
    y = UI_Regions_Config_y_base[instance] + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
    //y = UI_Regions_Config_y_base[instance] + FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN;
    y += (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN + TEXT_MARGIN) * 4 * region_csv_index;

    w_max = MIN_INT;

    // Coord. x
    //y += h + TEXT_MARGIN;
    str = "Coord. x(m)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_coord_x_"+region_csv_index);
    tl_handle
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    // Coord. y
    y += h + TEXT_MARGIN;
    str = "Coord. y(m)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_coord_y_"+region_csv_index);
    tl_handle
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    // Coord. w
    y += h + TEXT_MARGIN;
    str = "Coord. w(m)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_coord_w_"+region_csv_index);
    tl_handle
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    // Coord. h
    y += h + TEXT_MARGIN;
    str = "Coord. h(m)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_coord_h_"+region_csv_index);
    tl_handle
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    x += w_max + FONT_HEIGHT;
    y = UI_Regions_Config_y_base[instance] + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
    //y = UI_Regions_Config_y_base[instance] + FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN;
    y += (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN + TEXT_MARGIN) * 4 * region_csv_index;

    w_max = MIN_INT;

    // Coord. x input
    //y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_field_x(instance, region_csv_index)/100.);
    w = int(textWidth(str) * 2 + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_coord_x_input_"+region_csv_index);
    tf_handle
      .setId(instance*100+region_csv_index*10+id_index++)
      //.addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Coord. y input
    y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_field_y(instance, region_csv_index)/100.);
    w = int(textWidth(str) * 2 + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_coord_y_input_"+region_csv_index);
    tf_handle
      .setId(instance*100+region_csv_index*10+id_index++)
      //.addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Coord. w input
    y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_field_width(instance, region_csv_index)/100.);
    w = int(textWidth(str) * 2 + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_coord_w_input_"+region_csv_index);
    tf_handle
      .setId(instance*100+region_csv_index*10+id_index++)
      //.addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Coord. h input
    y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_field_height(instance, region_csv_index)/100.);
    w = int(textWidth(str) * 2 + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_coord_h_input_"+region_csv_index);
    tf_handle
      .setId(instance*100+region_csv_index*10+id_index++)
      //.addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

  }
}

void UI_Regions_Config_reset()
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_RESET_DBG) println("UI_Regions_Config_reset():Enter");

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    UI_Regions_Config_reset_instance(i);
  }

  if(UI_Regions_Config_cp5_global == null) {
    return;
  }

  List<ControllerInterface<?>> cp5_list = UI_Regions_Config_cp5_global.getAll();

  for (ControllerInterface controller:cp5_list)
  {
    //println("name:"+controller.getName());
    UI_Regions_Config_cp5_global.remove(controller.getName());
  }

  UI_Regions_Config_cp5_global.setGraphics(this,0,0);

  UI_Regions_Config_cp5_global = null;
}

void UI_Regions_Config_reset_instance(int instance)
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_RESET_DBG) println("UI_Regions_Config_reset_instance("+instance+"):Enter");

  if(UI_Regions_Config_cp5_local[instance] == null) {
    return;
  }

  List<ControllerInterface<?>> cp5_list = UI_Regions_Config_cp5_local[instance].getAll();

  for (ControllerInterface controller:cp5_list)
  {
    //println("name:"+controller.getName());
    UI_Regions_Config_cp5_local[instance].remove(controller.getName());
  }

  UI_Regions_Config_cp5_local[instance].setGraphics(this,0,0);

  UI_Regions_Config_cp5_local[instance] = null;
}

void UI_Regions_Config_draw()
{
  if (UI_Regions_Config_enabled) return;

  if (UI_Regions_Config_cp5_global == null)
  {
    int i;
    for (i = 0; i < PS_INSTANCE_MAX; i ++)
    {
      if (UI_Regions_Config_cp5_local[i] != null)
      {
        break;
      }
    }
    if (i == PS_INSTANCE_MAX) return;
  }

  UI_Regions_Config_update();
}


/*
class UI_Regions_Config_TF_ControlListener implements ControlListener {
  int col;
  public void controlEvent(ControlEvent theEvent) {
    Textfield tf_handle;
    println("UI_Regions_Config_TF_ControlListener:controlEvent():Enter");
    tf_handle = (Textfield)theEvent.getController();
    println("UI_Regions_Config_TF_ControlListener:controlEvent():getId="+tf_handle.getId());
    println("UI_Regions_Config_TF_ControlListener:controlEvent():getValue="+tf_handle.getValue());
    println("UI_Regions_Config_TF_ControlListener:controlEvent():getText="+tf_handle.getText());
  }
}
*/

class UI_Regions_Config_BT_ControlListener implements ControlListener {
  int col;
  public void controlEvent(ControlEvent theEvent) {
    println("UI_Regions_Config_BT_ControlListener:controlEvent():Enter");

    Button bt_handle = (Button)theEvent.getController();
    int button_index = bt_handle.getId();

    println("UI_Regions_Config_BT_ControlListener:controlEvent():button_index="+button_index);

    if (button_index != 0) // Button is no OK.
    {
      UI_Regions_Config_enabled = false;
      return;
    }

    boolean updated = false;

    for (int i = 0; i < PS_INSTANCE_MAX; i ++) {
      List<Textfield> cp5_tf_list = UI_Regions_Config_cp5_local[i].getAll(Textfield.class);
      //println(cp5_tf_list);
      boolean updated_instance;
      updated_instance = false;
      for (Textfield tf_handle:cp5_tf_list) {
        //println("Id="+tf_handle.getId()+":Text="+tf_handle.getText());
        if (tf_handle.getId() == -1) continue;
        int instance = tf_handle.getId() / 100;
        if (i != instance) continue;
        int region_csv_index = tf_handle.getId() % 100 / 10;
        int tf_index = tf_handle.getId() % 10;
        //println("indtance="+instance+":region csv index="+region_csv_index+",tf index="+tf_index);
        Region_CSV region_csv = Regions_handle.get_region_csv_element(instance, region_csv_index);

        String str;
        int val;
        boolean bool;

        str = tf_handle.getText();
        switch (tf_index) {
          case 0: // Region name
            if (!region_csv.name.equals(str)) {
              region_csv.name = str;
              updated_instance = true;
            }
            break;
          case 1: // Region priority
            try {
              val = Integer.parseInt(str.trim());
            }
            catch (NumberFormatException e) {
              val = region_csv.priority;
            }
            if (region_csv.priority != val) {
              region_csv.priority = val;
              updated_instance = true;
            }
            break;
          case 2: // Relay index
            try {
              val = Integer.parseInt(str.trim());
            }
            catch (NumberFormatException e) {
              val = region_csv.relay_index;
            }
            if (region_csv.relay_index != val) {
              region_csv.relay_index = val;
              updated_instance = true;
            }
            break;
          case 3: // No mark big
            bool = str.toLowerCase().equals("true")?true:false;
            if (region_csv.no_mark_big != bool) {
              region_csv.no_mark_big = bool;
              updated_instance = true;
            }
            break;
          case 4: // Rect field x
            try {
              val = int(Float.parseFloat(str.trim()) * 100.0);
            }
            catch (NumberFormatException e) {
              val = region_csv.rect_field_x;
            }
            if (region_csv.rect_field_x != val) {
              region_csv.rect_field_x = val;
              updated_instance = true;
            }
            break;
          case 5: // Rect field y
            try {
              val = int(Float.parseFloat(str.trim()) * 100.0);
            }
            catch (NumberFormatException e) {
              val = region_csv.rect_field_y;
            }
            if (region_csv.rect_field_y != val) {
              region_csv.rect_field_y = val;
              updated_instance = true;
            }
            break;
          case 6: // Rect field width
            try {
              val = int(Float.parseFloat(str.trim()) * 100.0);
            }
            catch (NumberFormatException e) {
              val = region_csv.rect_field_width;
            }
            if (region_csv.rect_field_width != val) {
              region_csv.rect_field_width = val;
              updated_instance = true;
            }
            break;
          case 7: // Rect field height
            try {
              val = int(Float.parseFloat(str.trim()) * 100.0);
            }
            catch (NumberFormatException e) {
              val = region_csv.rect_field_height;
            }
            if (region_csv.rect_field_height != val) {
              region_csv.rect_field_height = val;
              updated_instance = true;
            }
            break;
          default:
            println("indtance="+instance+":region csv index="+region_csv_index+",tf index="+tf_index);
            break;
        } // End of switch (tf_index)
      } // End of for (Textfield tf_handle:cp5_tf_list)
      if (updated_instance) {
        Regions_handle.update_regions_csv_file(i);
        updated = true;
      }
    } // End of for (int i = 0; i < PS_INSTANCE_MAX; i ++)
    if (updated) {
      // To restart program set frameCount to -1, this wiil call setup() of main.
      frameCount = -1;
    }
    else {
      UI_Regions_Config_changed_any = true;
    }
  }

}