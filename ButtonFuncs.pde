//final static boolean PRINT_BUTTON_ZOOM_DBG = true; 
final static boolean PRINT_BUTTON_ZOOM_DBG = false;

//final static boolean PRINT_BUTTON_ROTATE_DBG = true; 
final static boolean PRINT_BUTTON_ROTATE_DBG = false;

//final static boolean PRINT_BUTTON_MIRROR_DBG = true; 
final static boolean PRINT_BUTTON_MIRROR_DBG = false;

//final static boolean PRINT_BUTTON_RESET_DBG = true; 
final static boolean PRINT_BUTTON_RESET_DBG = false;

static color C_BTN_NORMAL = #FFFFFF; // White
static color C_BTN_HIGHLIGHT = #C0C0C0; //
static color C_BTN_TEXT = #000000; // Black

static int button_zoom_minus_x, button_zoom_minus_y;           // Position of square button zoom minus
static int button_zoom_minus_width, button_zoom_minus_height;  // Diameter of rect
static int button_zoom_minus_str_x, button_zoom_minus_str_y;   // Position of button string zoom minus
static String button_zoom_minus_str = "-";                     // button string zoom minus
static boolean button_zoom_minus_over = false;
static boolean button_zoom_minus_pressed = false;

static int button_zoom_pluse_x, button_zoom_pluse_y;           // Position of square button zoom pluse
static int button_zoom_pluse_width, button_zoom_pluse_height;  // Diameter of rect
static int button_zoom_pluse_str_x, button_zoom_pluse_str_y;   // Position of button string zoom pluse
static String button_zoom_pluse_str = "+";                     // button string zoom pluse
static boolean button_zoom_pluse_over = false;
static boolean button_zoom_pluse_pressed = false;

static int button_zoom_caption_str_x, button_zoom_caption_str_y;  // Position of button string zoom pluse
static String button_zoom_caption_str = "Zoom";                   // button string zoom pluse

static int button_rotate_ccw_x, button_rotate_ccw_y;           // Position of square button rotate counter clock-wise
static int button_rotate_ccw_width, button_rotate_ccw_height;  // Diameter of rect
static int button_rotate_ccw_str_x, button_rotate_ccw_str_y;   // Position of button string rotate counter clock-wise
static String button_rotate_ccw_str = "↺";                     // button string rotate counter clock-wise
static boolean button_rotate_ccw_over = false;
static boolean button_rotate_ccw_pressed = false;

static int button_rotate_cw_x, button_rotate_cw_y;           // Position of square button rotate clock-wise
static int button_rotate_cw_width, button_rotate_cw_height;  // Diameter of rect
static int button_rotate_cw_str_x, button_rotate_cw_str_y;   // Position of button string rotate clock-wise
static String button_rotate_cw_str = "↻";                    // button string rotate clock-wise
static boolean button_rotate_cw_over = false;
static boolean button_rotate_cw_pressed = false;

static int button_rotate_caption_str_x, button_rotate_caption_str_y;  // Position of button string rotate clock-wise
static String button_rotate_caption_str = "Rotate";                   // button string rotate clock-wise

static int button_mirror_en_x, button_mirror_en_y;      // Position of square button mirror enable
static int button_mirror_en_width, button_mirror_en_height;     // Diameter of rect
static int button_mirror_en_str_x, button_mirror_en_str_y;      // Position of button string mirror enable
static String button_mirror_en_str_up_down = "⇅"; // button string mirror enable
static String button_mirror_en_str_left_right = "⇄"; // button string mirror enable
static boolean button_mirror_en_over = false;
static boolean button_mirror_en_pressed = false;

static int button_mirror_en_caption_str_x, button_mirror_en_caption_str_y;  // Position of button string mirror enable
static String button_mirror_en_caption_str = "Mirror";                      // button string mirror enable

static int button_reset_en_x, button_reset_en_y;           // Position of square button reset enable
static int button_reset_en_width, button_reset_en_height;  // Diameter of rect
static int button_reset_en_str_x, button_reset_en_str_y;   // Position of button string reset enable
static String button_reset_en_str = "0";                   // button string reset enable
static boolean button_reset_en_over = false;
static boolean button_reset_en_pressed = false;

static int button_reset_en_caption_str_x, button_reset_en_caption_str_y;  // Position of button string reset enable
static String button_reset_en_caption_str = "Reset";                      // button string reset enable

void button_setup()
{
  button_zoom_minus_width = FONT_HEIGHT * 2;
  button_zoom_minus_height = FONT_HEIGHT * 2;
  button_zoom_minus_x = TEXT_MARGIN + FONT_HEIGHT * 3;
  button_zoom_minus_y = SCREEN_height - button_zoom_minus_height - TEXT_MARGIN - FONT_HEIGHT * 1;
  button_zoom_minus_str_x = button_zoom_minus_x + button_zoom_minus_width / 2 - int(textWidth(button_zoom_minus_str)) / 2;
  button_zoom_minus_str_y = button_zoom_minus_y + button_zoom_minus_height / 2 + FONT_HEIGHT / 2;

  button_zoom_pluse_width = FONT_HEIGHT * 2;
  button_zoom_pluse_height = FONT_HEIGHT * 2;
  button_zoom_pluse_x = TEXT_MARGIN + FONT_HEIGHT * 3;
  button_zoom_pluse_y = SCREEN_height - button_zoom_pluse_height - TEXT_MARGIN - FONT_HEIGHT * 3;
  button_zoom_pluse_str_x = button_zoom_pluse_x + button_zoom_pluse_width / 2 - int(textWidth(button_zoom_pluse_str)) / 2;
  button_zoom_pluse_str_y = button_zoom_pluse_y + button_zoom_pluse_height / 2 + FONT_HEIGHT / 2;

  button_zoom_caption_str_x = button_zoom_pluse_x + button_zoom_pluse_width / 2 - int(textWidth(button_zoom_caption_str)) / 2;
  button_zoom_caption_str_y = button_zoom_pluse_y - FONT_HEIGHT / 2;

  button_rotate_ccw_width = FONT_HEIGHT * 2;
  button_rotate_ccw_height = FONT_HEIGHT * 2;
  button_rotate_ccw_x = TEXT_MARGIN + FONT_HEIGHT * 6;
  button_rotate_ccw_y = SCREEN_height - button_rotate_ccw_height - TEXT_MARGIN - FONT_HEIGHT * 1;
  button_rotate_ccw_str_x = button_rotate_ccw_x + button_rotate_ccw_width / 2 - int(textWidth(button_rotate_ccw_str)) / 2;
  button_rotate_ccw_str_y = button_rotate_ccw_y + button_rotate_ccw_height / 2 + FONT_HEIGHT / 2;

  button_rotate_cw_width = FONT_HEIGHT * 2;
  button_rotate_cw_height = FONT_HEIGHT * 2;
  button_rotate_cw_x = TEXT_MARGIN + FONT_HEIGHT * 6;
  button_rotate_cw_y = SCREEN_height - button_rotate_cw_height - TEXT_MARGIN - FONT_HEIGHT * 3;
  button_rotate_cw_str_x = button_rotate_cw_x + button_rotate_cw_width / 2 - int(textWidth(button_rotate_cw_str)) / 2;
  button_rotate_cw_str_y = button_rotate_cw_y + button_rotate_cw_height / 2 + FONT_HEIGHT / 2;

  button_rotate_caption_str_x = button_rotate_cw_x + button_rotate_cw_width / 2 - int(textWidth(button_rotate_caption_str)) / 2;
  button_rotate_caption_str_y = button_rotate_cw_y - FONT_HEIGHT / 2;

  button_mirror_en_width = FONT_HEIGHT * 2;
  button_mirror_en_height = FONT_HEIGHT * 2;
  button_mirror_en_x = TEXT_MARGIN + FONT_HEIGHT * 9;
  button_mirror_en_y = SCREEN_height - button_mirror_en_height - TEXT_MARGIN - FONT_HEIGHT * 1;
  button_mirror_en_str_x = button_mirror_en_x + button_mirror_en_width / 2 - int(max(textWidth(button_mirror_en_str_up_down), textWidth(button_mirror_en_str_left_right))) / 2;
  button_mirror_en_str_y = button_mirror_en_y + button_mirror_en_height / 2 + FONT_HEIGHT / 2;

  button_mirror_en_caption_str_x = button_mirror_en_x + button_mirror_en_width / 2 - int(textWidth(button_mirror_en_caption_str)) / 2;
  button_mirror_en_caption_str_y = button_mirror_en_y - FONT_HEIGHT / 2;

  button_reset_en_width = FONT_HEIGHT * 2;
  button_reset_en_height = FONT_HEIGHT * 2;
  button_reset_en_x = TEXT_MARGIN + FONT_HEIGHT * 12;
  button_reset_en_y = SCREEN_height - button_mirror_en_height - TEXT_MARGIN - FONT_HEIGHT * 1;
  button_reset_en_str_x = button_reset_en_x + button_reset_en_width / 2 - int(textWidth(button_reset_en_str)) / 2;
  button_reset_en_str_y = button_reset_en_y + button_reset_en_height / 2 + FONT_HEIGHT / 2;
  
  button_reset_en_caption_str_x = button_reset_en_x + button_reset_en_width / 2 - int(textWidth(button_reset_en_caption_str)) / 2;
  button_reset_en_caption_str_y = button_reset_en_y - FONT_HEIGHT / 2;
}

void button_draw()
{
  //String string;

  // Sets the color used to draw lines and borders around shapes.
  stroke(C_BTN_TEXT);

  if (button_zoom_minus_over) {
    fill( C_BTN_HIGHLIGHT);
  } else {
    fill( C_BTN_NORMAL);
  }
  rect(button_zoom_minus_x, button_zoom_minus_y, button_zoom_minus_width, button_zoom_minus_height);
  fill(C_BTN_TEXT);
  text(button_zoom_minus_str, button_zoom_minus_str_x, button_zoom_minus_str_y);

  if (button_zoom_pluse_over) {
    fill( C_BTN_HIGHLIGHT);
  } else {
    fill( C_BTN_NORMAL);
  }
  rect(button_zoom_pluse_x, button_zoom_pluse_y, button_zoom_pluse_width, button_zoom_pluse_height);
  fill(C_BTN_TEXT);
  text(button_zoom_pluse_str, button_zoom_pluse_str_x, button_zoom_pluse_str_y);

  text(button_zoom_caption_str, button_zoom_caption_str_x, button_zoom_caption_str_y);


  if (button_rotate_ccw_over) {
    fill( C_BTN_HIGHLIGHT);
  } else {
    fill( C_BTN_NORMAL);
  }
  rect(button_rotate_ccw_x, button_rotate_ccw_y, button_rotate_ccw_width, button_rotate_ccw_height);
  fill(C_BTN_TEXT);
  text(button_rotate_ccw_str, button_rotate_ccw_str_x, button_rotate_ccw_str_y);

  if (button_rotate_cw_over) {
    fill( C_BTN_HIGHLIGHT);
  } else {
    fill( C_BTN_NORMAL);
  }
  rect(button_rotate_cw_x, button_rotate_cw_y, button_rotate_cw_width, button_rotate_cw_height);
  fill(C_BTN_TEXT);
  text(button_rotate_cw_str, button_rotate_cw_str_x, button_rotate_cw_str_y);

  text(button_rotate_caption_str, button_rotate_caption_str_x, button_rotate_caption_str_y);


  if (button_mirror_en_over) {
    fill( C_BTN_HIGHLIGHT);
  } else {
    fill( C_BTN_NORMAL);
  }
  rect(button_mirror_en_x, button_mirror_en_y, button_mirror_en_width, button_mirror_en_height);
  fill(C_BTN_TEXT);
  if (ROTATE_FACTOR == 315 || ROTATE_FACTOR == 135)
    text(button_mirror_en_str_up_down, button_mirror_en_str_x, button_mirror_en_str_y);
  else
    text(button_mirror_en_str_left_right, button_mirror_en_str_x, button_mirror_en_str_y);

  text(button_mirror_en_caption_str, button_mirror_en_caption_str_x, button_mirror_en_caption_str_y);


  if (button_reset_en_over) {
    fill( C_BTN_HIGHLIGHT);
  } else {
    fill( C_BTN_NORMAL);
  }
  rect(button_reset_en_x, button_reset_en_y, button_reset_en_width, button_reset_en_height);
  fill(C_BTN_TEXT);
  text(button_reset_en_str, button_reset_en_str_x, button_reset_en_str_y);

  text(button_reset_en_caption_str, button_reset_en_caption_str_x, button_reset_en_caption_str_y);
}

/*static*/ boolean button_check_over(int r_x, int r_y, int r_width, int r_height)
{
  if( mouseX >= r_x && mouseX <= r_x+r_width
      && 
      mouseY >= r_y && mouseY <= r_y+r_height
    )
  {
    return true;
  }
  else
  {
    return false;
  }
}

void button_check_update()
{
  if( button_check_over(button_zoom_minus_x, button_zoom_minus_y, button_zoom_minus_width, button_zoom_minus_height) )
  {
    //println("ZOOM_FACTOR=" + ZOOM_FACTOR);
    button_zoom_minus_over = true;
    button_zoom_pluse_over =
    button_rotate_ccw_over =
    button_rotate_cw_over =
    button_mirror_en_over =
    button_reset_en_over = false;
  }
  else if( button_check_over(button_zoom_pluse_x, button_zoom_pluse_y, button_zoom_pluse_width, button_zoom_pluse_height) )
  {
    //println("ZOOM_FACTOR=" + ZOOM_FACTOR);
    button_zoom_pluse_over = true;
    button_zoom_minus_over =
    button_rotate_ccw_over =
    button_rotate_cw_over =
    button_mirror_en_over =
    button_reset_en_over = false;
  }
  else if( button_check_over(button_rotate_ccw_x, button_rotate_ccw_y, button_rotate_ccw_width, button_rotate_ccw_height) )
  {
    button_rotate_ccw_over = true;
    button_zoom_minus_over =
    button_zoom_pluse_over =
    button_rotate_cw_over =
    button_mirror_en_over =
    button_reset_en_over = false;
  }
  else if( button_check_over(button_rotate_cw_x, button_rotate_cw_y, button_rotate_cw_width, button_rotate_cw_height) )
  {
    button_rotate_cw_over = true;
    button_zoom_minus_over =
    button_zoom_pluse_over =
    button_rotate_ccw_over =
    button_mirror_en_over =
    button_reset_en_over = false;
  }
  else if( button_check_over(button_mirror_en_x, button_mirror_en_y, button_mirror_en_width, button_mirror_en_height) )
  {
    button_mirror_en_over = true;
    button_zoom_minus_over =
    button_zoom_pluse_over =
    button_rotate_ccw_over =
    button_rotate_cw_over =
    button_reset_en_over = false;
  }
  else if( button_check_over(button_reset_en_x, button_reset_en_y, button_reset_en_width, button_reset_en_height) )
  {
    button_reset_en_over = true;
    button_zoom_minus_over =
    button_zoom_pluse_over =
    button_rotate_ccw_over =
    button_rotate_cw_over =
    button_mirror_en_over = false;
  }
  else
  {
    button_zoom_minus_over =
    button_zoom_pluse_over =
    button_rotate_ccw_over =
    button_rotate_cw_over =
    button_mirror_en_over =
    button_reset_en_over = false;
  }
}

void button_zoom_minus()
{
  if (ZOOM_FACTOR <= 3000)
  {
    if (ZOOM_FACTOR < 100) ZOOM_FACTOR += 10;
    else ZOOM_FACTOR = int(float(ZOOM_FACTOR) * 1.1 + 5.0) / 10 * 10;
    config_save();
  }
  if(PRINT_BUTTON_ZOOM_DBG) println("ZOOM_FACTOR=" + ZOOM_FACTOR);
}

void button_zoom_pluse()
{
  if (ZOOM_FACTOR > 10)
  {
    if (ZOOM_FACTOR < 100) ZOOM_FACTOR -= 10;
    else ZOOM_FACTOR = int(float(ZOOM_FACTOR) / 1.1 + 5.0) / 10 * 10;
    config_save();
  }
  if(PRINT_BUTTON_ZOOM_DBG) println("ZOOM_FACTOR=" + ZOOM_FACTOR);
}

void button_rotate_ccw()
{
  float save_ox, save_oy;
  ROTATE_FACTOR -= 90;
  if (ROTATE_FACTOR < 0) ROTATE_FACTOR += 360;
  save_ox = float(GRID_OFFSET_X);
  save_oy = float(GRID_OFFSET_Y);
  if (ROTATE_FACTOR == 315) { // OK
    GRID_OFFSET_X =  int(save_oy - (float(SCREEN_height) / 2.0) + (float(SCREEN_width)  / 2.0));
    GRID_OFFSET_Y = -int(save_ox);
  }
  else if (ROTATE_FACTOR == 45) { // OK
    GRID_OFFSET_Y = -int(save_ox + (float(SCREEN_width)  / 2.0) - (float(SCREEN_height) / 2.0));
    GRID_OFFSET_X =  int(save_oy);
  }
  else if (ROTATE_FACTOR == 135) { // OK
    GRID_OFFSET_X =  int(save_oy + (float(SCREEN_height) / 2.0) - (float(SCREEN_width)  / 2.0));
    GRID_OFFSET_Y = -int(save_ox);
  }
  else /*if (ROTATE_FACTOR == 225)*/ { // OK
    GRID_OFFSET_Y = -int(save_ox - (float(SCREEN_width)  / 2.0) + (float(SCREEN_height) / 2.0));
    GRID_OFFSET_X =  int(save_oy);
  }
  grid_ready();
  config_save();
  if(PRINT_BUTTON_ROTATE_DBG) println("ROTATE_FACTOR=" + ROTATE_FACTOR);
}

void button_rotate_cw()
{
  float save_ox, save_oy;
  ROTATE_FACTOR += 90;
  if (ROTATE_FACTOR > 360) ROTATE_FACTOR -= 360;
  save_ox = float(GRID_OFFSET_X);
  save_oy = float(GRID_OFFSET_Y);
  if (ROTATE_FACTOR == 315) { // OK
    GRID_OFFSET_X = -int(save_oy + (float(SCREEN_height) / 2.0) - (float(SCREEN_width)  / 2.0));
    GRID_OFFSET_Y =  int(save_ox);
  }
  else if (ROTATE_FACTOR == 45) { // OK
    GRID_OFFSET_Y =  int(save_ox - (float(SCREEN_width)  / 2.0) + (float(SCREEN_height) / 2.0));
    GRID_OFFSET_X = -int(save_oy);
  }
  else if (ROTATE_FACTOR == 135) { // OK
    GRID_OFFSET_X = -int(save_oy - (float(SCREEN_height) / 2.0) + (float(SCREEN_width)  / 2.0));
    GRID_OFFSET_Y =  int(save_ox);
  }
  else /*if (ROTATE_FACTOR == 225)*/ { // OK
    GRID_OFFSET_Y =  int(save_ox + (float(SCREEN_width)  / 2.0) - (float(SCREEN_height) / 2.0));
    GRID_OFFSET_X = -int(save_oy);
  }
  grid_ready();
  config_save();
  if(PRINT_BUTTON_ROTATE_DBG) println("ROTATE_FACTOR=" + ROTATE_FACTOR);
}

void button_mirror_en()
{
  MIRROR_ENABLE = !MIRROR_ENABLE;
  grid_ready();
  config_save();
  if(PRINT_BUTTON_MIRROR_DBG) println("MIRROR_ENABLE=" + MIRROR_ENABLE);
}

void button_reset_en()
{
  if(PRINT_BUTTON_RESET_DBG)
  {
    println("ZOOM_FACTOR=" + ZOOM_FACTOR);
    println("MIRROR_ENABLE=" + MIRROR_ENABLE);
    println("GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
  }
  GRID_OFFSET_X = GRID_OFFSET_Y = 0;
  MIRROR_ENABLE = false;
  ZOOM_FACTOR = 100;
  grid_ready();
  config_save();
}


