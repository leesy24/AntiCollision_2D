//final static boolean PRINT_UI_BUTTONS_ZOOM_DBG = true; 
final static boolean PRINT_UI_BUTTONS_ZOOM_DBG = false;

//final static boolean PRINT_UI_BUTTONS_ROTATE_DBG = true; 
final static boolean PRINT_UI_BUTTONS_ROTATE_DBG = false;

//final static boolean PRINT_UI_BUTTONS_MIRROR_DBG = true; 
final static boolean PRINT_UI_BUTTONS_MIRROR_DBG = false;

//final static boolean PRINT_UI_BUTTONS_RESET_DBG = true; 
final static boolean PRINT_UI_BUTTONS_RESET_DBG = false;

static color C_UI_BUTTONS_NORMAL = #FFFFFF; // White
static color C_UI_BUTTONS_HIGHLIGHT = #C0C0C0; //
static color C_UI_BUTTONS_TEXT = #000000; // Black
static color C_UI_BUTTONS_BOX = #000000; // Black
static int W_UI_BUTTONS_BOX = 1; // Black

static int buttons_zoom_minus_x, buttons_zoom_minus_y;           // Position of square button zoom minus
static int buttons_zoom_minus_width, buttons_zoom_minus_height;  // Diameter of rect
static int buttons_zoom_minus_str_x, buttons_zoom_minus_str_y;   // Position of button string zoom minus
static String buttons_zoom_minus_str = "-";                     // button string zoom minus
static boolean buttons_zoom_minus_over = false;
static boolean buttons_zoom_minus_pressed = false;

static int buttons_zoom_pluse_x, buttons_zoom_pluse_y;           // Position of square button zoom pluse
static int buttons_zoom_pluse_width, buttons_zoom_pluse_height;  // Diameter of rect
static int buttons_zoom_pluse_str_x, buttons_zoom_pluse_str_y;   // Position of button string zoom pluse
static String buttons_zoom_pluse_str = "+";                     // button string zoom pluse
static boolean buttons_zoom_pluse_over = false;
static boolean buttons_zoom_pluse_pressed = false;

static int buttons_zoom_caption_str_x, buttons_zoom_caption_str_y;  // Position of button string zoom pluse
static String buttons_zoom_caption_str = "Zoom";                   // button string zoom pluse

static int buttons_rotate_ccw_x, buttons_rotate_ccw_y;           // Position of square button rotate counter clock-wise
static int buttons_rotate_ccw_width, buttons_rotate_ccw_height;  // Diameter of rect
static int buttons_rotate_ccw_str_x, buttons_rotate_ccw_str_y;   // Position of button string rotate counter clock-wise
static String buttons_rotate_ccw_str = "↺";                     // button string rotate counter clock-wise
static boolean buttons_rotate_ccw_over = false;
static boolean buttons_rotate_ccw_pressed = false;

static int buttons_rotate_cw_x, buttons_rotate_cw_y;           // Position of square button rotate clock-wise
static int buttons_rotate_cw_width, buttons_rotate_cw_height;  // Diameter of rect
static int buttons_rotate_cw_str_x, buttons_rotate_cw_str_y;   // Position of button string rotate clock-wise
static String buttons_rotate_cw_str = "↻";                    // button string rotate clock-wise
static boolean buttons_rotate_cw_over = false;
static boolean buttons_rotate_cw_pressed = false;

static int buttons_rotate_caption_str_x, buttons_rotate_caption_str_y;  // Position of button string rotate clock-wise
static String buttons_rotate_caption_str = "Rotate";                   // button string rotate clock-wise

static int buttons_mirror_ud_x, buttons_mirror_ud_y;      // Position of square button mirror enable
static int buttons_mirror_ud_width, buttons_mirror_ud_height;     // Diameter of rect
static int buttons_mirror_ud_str_x, buttons_mirror_ud_str_y;      // Position of button string mirror enable
static String buttons_mirror_ud_str = "⇅"; // button string mirror enable
static boolean buttons_mirror_ud_over = false;
static boolean buttons_mirror_ud_pressed = false;

static int buttons_mirror_lr_x, buttons_mirror_lr_y;      // Position of square button mirror enable
static int buttons_mirror_lr_width, buttons_mirror_lr_height;     // Diameter of rect
static int buttons_mirror_lr_str_x, buttons_mirror_lr_str_y;      // Position of button string mirror enable
static String buttons_mirror_lr_str = "⇄"; // button string mirror enable
static boolean buttons_mirror_lr_over = false;
static boolean buttons_mirror_lr_pressed = false;

static int buttons_mirror_caption_str_x, buttons_mirror_caption_str_y;  // Position of button string mirror enable
static String buttons_mirror_caption_str = "Mirror";                      // button string mirror enable

static int buttons_reset_en_x, buttons_reset_en_y;           // Position of square button reset enable
static int buttons_reset_en_width, buttons_reset_en_height;  // Diameter of rect
static int buttons_reset_en_str_x, buttons_reset_en_str_y;   // Position of button string reset enable
static String buttons_reset_en_str = "0";                   // button string reset enable
static boolean buttons_reset_en_over = false;
static boolean buttons_reset_en_pressed = false;

static int buttons_reset_en_caption_str_x, buttons_reset_en_caption_str_y;  // Position of button string reset enable
static String buttons_reset_en_caption_str = "Reset";                      // button string reset enable

static boolean UI_Buttons_enabled = false;

void UI_Buttons_setup()
{
  buttons_zoom_minus_width = FONT_HEIGHT * 2;
  buttons_zoom_minus_height = FONT_HEIGHT * 2;
  buttons_zoom_minus_x = TEXT_MARGIN + FONT_HEIGHT * 3;
  buttons_zoom_minus_y = SCREEN_height - buttons_zoom_minus_height - TEXT_MARGIN - FONT_HEIGHT * 1;
  buttons_zoom_minus_str_x = buttons_zoom_minus_x + buttons_zoom_minus_width / 2 - int(textWidth(buttons_zoom_minus_str)) / 2;
  buttons_zoom_minus_str_y = buttons_zoom_minus_y + buttons_zoom_minus_height / 2 + FONT_HEIGHT / 2;

  buttons_zoom_pluse_width = FONT_HEIGHT * 2;
  buttons_zoom_pluse_height = FONT_HEIGHT * 2;
  buttons_zoom_pluse_x = TEXT_MARGIN + FONT_HEIGHT * 3;
  buttons_zoom_pluse_y = SCREEN_height - buttons_zoom_pluse_height - TEXT_MARGIN - FONT_HEIGHT * 3;
  buttons_zoom_pluse_str_x = buttons_zoom_pluse_x + buttons_zoom_pluse_width / 2 - int(textWidth(buttons_zoom_pluse_str)) / 2;
  buttons_zoom_pluse_str_y = buttons_zoom_pluse_y + buttons_zoom_pluse_height / 2 + FONT_HEIGHT / 2;

  buttons_zoom_caption_str_x = buttons_zoom_pluse_x + buttons_zoom_pluse_width / 2 - int(textWidth(buttons_zoom_caption_str)) / 2;
  buttons_zoom_caption_str_y = buttons_zoom_pluse_y - FONT_HEIGHT / 2;

  buttons_rotate_ccw_width = FONT_HEIGHT * 2;
  buttons_rotate_ccw_height = FONT_HEIGHT * 2;
  buttons_rotate_ccw_x = TEXT_MARGIN + FONT_HEIGHT * 6;
  buttons_rotate_ccw_y = SCREEN_height - buttons_rotate_ccw_height - TEXT_MARGIN - FONT_HEIGHT * 1;
  buttons_rotate_ccw_str_x = buttons_rotate_ccw_x + buttons_rotate_ccw_width / 2 - int(textWidth(buttons_rotate_ccw_str)) / 2;
  buttons_rotate_ccw_str_y = buttons_rotate_ccw_y + buttons_rotate_ccw_height / 2 + FONT_HEIGHT / 2;

  buttons_rotate_cw_width = FONT_HEIGHT * 2;
  buttons_rotate_cw_height = FONT_HEIGHT * 2;
  buttons_rotate_cw_x = TEXT_MARGIN + FONT_HEIGHT * 6;
  buttons_rotate_cw_y = SCREEN_height - buttons_rotate_cw_height - TEXT_MARGIN - FONT_HEIGHT * 3;
  buttons_rotate_cw_str_x = buttons_rotate_cw_x + buttons_rotate_cw_width / 2 - int(textWidth(buttons_rotate_cw_str)) / 2;
  buttons_rotate_cw_str_y = buttons_rotate_cw_y + buttons_rotate_cw_height / 2 + FONT_HEIGHT / 2;

  buttons_rotate_caption_str_x = buttons_rotate_cw_x + buttons_rotate_cw_width / 2 - int(textWidth(buttons_rotate_caption_str)) / 2;
  buttons_rotate_caption_str_y = buttons_rotate_cw_y - FONT_HEIGHT / 2;

  buttons_mirror_ud_width = FONT_HEIGHT * 2;
  buttons_mirror_ud_height = FONT_HEIGHT * 2;
  buttons_mirror_ud_x = TEXT_MARGIN + FONT_HEIGHT * 9;
  buttons_mirror_ud_y = SCREEN_height - buttons_mirror_ud_height - TEXT_MARGIN - FONT_HEIGHT * 1;
  buttons_mirror_ud_str_x = buttons_mirror_ud_x + buttons_mirror_ud_width / 2 - int(textWidth(buttons_mirror_ud_str)) / 2;
  buttons_mirror_ud_str_y = buttons_mirror_ud_y + buttons_mirror_ud_height / 2 + FONT_HEIGHT / 2;

  buttons_mirror_lr_width = FONT_HEIGHT * 2;
  buttons_mirror_lr_height = FONT_HEIGHT * 2;
  buttons_mirror_lr_x = TEXT_MARGIN + FONT_HEIGHT * 9;
  buttons_mirror_lr_y = SCREEN_height - buttons_mirror_lr_height - TEXT_MARGIN - FONT_HEIGHT * 3;
  buttons_mirror_lr_str_x = buttons_mirror_lr_x + buttons_mirror_lr_width / 2 - int(textWidth(buttons_mirror_lr_str)) / 2;
  buttons_mirror_lr_str_y = buttons_mirror_lr_y + buttons_mirror_lr_height / 2 + FONT_HEIGHT / 2;

  buttons_mirror_caption_str_x = buttons_mirror_lr_x + buttons_mirror_lr_width / 2 - int(textWidth(buttons_mirror_caption_str)) / 2;
  buttons_mirror_caption_str_y = buttons_mirror_lr_y - FONT_HEIGHT / 2;

  buttons_reset_en_width = FONT_HEIGHT * 2;
  buttons_reset_en_height = FONT_HEIGHT * 2;
  buttons_reset_en_x = TEXT_MARGIN + FONT_HEIGHT * 12;
  buttons_reset_en_y = SCREEN_height - buttons_mirror_ud_height - TEXT_MARGIN - FONT_HEIGHT * 1;
  buttons_reset_en_str_x = buttons_reset_en_x + buttons_reset_en_width / 2 - int(textWidth(buttons_reset_en_str)) / 2;
  buttons_reset_en_str_y = buttons_reset_en_y + buttons_reset_en_height / 2 + FONT_HEIGHT / 2;
  
  buttons_reset_en_caption_str_x = buttons_reset_en_x + buttons_reset_en_width / 2 - int(textWidth(buttons_reset_en_caption_str)) / 2;
  buttons_reset_en_caption_str_y = buttons_reset_en_y - FONT_HEIGHT / 2;
}

void UI_Buttons_draw()
{
  if (!UI_Buttons_enabled) return;

  // Sets the color and weight used to draw lines and borders around shapes.
  stroke(C_UI_BUTTONS_BOX);
  strokeWeight(W_UI_BUTTONS_BOX);

  if (buttons_zoom_minus_over) {
    fill( C_UI_BUTTONS_HIGHLIGHT);
  } else {
    fill( C_UI_BUTTONS_NORMAL);
  }
  rect(buttons_zoom_minus_x, buttons_zoom_minus_y, buttons_zoom_minus_width, buttons_zoom_minus_height);
  fill(C_UI_BUTTONS_TEXT);
  text(buttons_zoom_minus_str, buttons_zoom_minus_str_x, buttons_zoom_minus_str_y);

  if (buttons_zoom_pluse_over) {
    fill( C_UI_BUTTONS_HIGHLIGHT);
  } else {
    fill( C_UI_BUTTONS_NORMAL);
  }
  rect(buttons_zoom_pluse_x, buttons_zoom_pluse_y, buttons_zoom_pluse_width, buttons_zoom_pluse_height);
  fill(C_UI_BUTTONS_TEXT);
  text(buttons_zoom_pluse_str, buttons_zoom_pluse_str_x, buttons_zoom_pluse_str_y);

  text(buttons_zoom_caption_str, buttons_zoom_caption_str_x, buttons_zoom_caption_str_y);


  if (buttons_rotate_ccw_over) {
    fill( C_UI_BUTTONS_HIGHLIGHT);
  } else {
    fill( C_UI_BUTTONS_NORMAL);
  }
  rect(buttons_rotate_ccw_x, buttons_rotate_ccw_y, buttons_rotate_ccw_width, buttons_rotate_ccw_height);
  fill(C_UI_BUTTONS_TEXT);
  text(buttons_rotate_ccw_str, buttons_rotate_ccw_str_x, buttons_rotate_ccw_str_y);

  if (buttons_rotate_cw_over) {
    fill( C_UI_BUTTONS_HIGHLIGHT);
  } else {
    fill( C_UI_BUTTONS_NORMAL);
  }
  rect(buttons_rotate_cw_x, buttons_rotate_cw_y, buttons_rotate_cw_width, buttons_rotate_cw_height);
  fill(C_UI_BUTTONS_TEXT);
  text(buttons_rotate_cw_str, buttons_rotate_cw_str_x, buttons_rotate_cw_str_y);

  text(buttons_rotate_caption_str, buttons_rotate_caption_str_x, buttons_rotate_caption_str_y);


  if (buttons_mirror_ud_over) {
    fill( C_UI_BUTTONS_HIGHLIGHT);
  } else {
    fill( C_UI_BUTTONS_NORMAL);
  }
  rect(buttons_mirror_ud_x, buttons_mirror_ud_y, buttons_mirror_ud_width, buttons_mirror_ud_height);
  fill(C_UI_BUTTONS_TEXT);
  text(buttons_mirror_ud_str, buttons_mirror_ud_str_x, buttons_mirror_ud_str_y);

  if (buttons_mirror_lr_over) {
    fill( C_UI_BUTTONS_HIGHLIGHT);
  } else {
    fill( C_UI_BUTTONS_NORMAL);
  }
  rect(buttons_mirror_lr_x, buttons_mirror_lr_y, buttons_mirror_lr_width, buttons_mirror_lr_height);
  fill(C_UI_BUTTONS_TEXT);
  text(buttons_mirror_lr_str, buttons_mirror_lr_str_x, buttons_mirror_lr_str_y);

  text(buttons_mirror_caption_str, buttons_mirror_caption_str_x, buttons_mirror_caption_str_y);


  if (buttons_reset_en_over) {
    fill( C_UI_BUTTONS_HIGHLIGHT);
  } else {
    fill( C_UI_BUTTONS_NORMAL);
  }
  rect(buttons_reset_en_x, buttons_reset_en_y, buttons_reset_en_width, buttons_reset_en_height);
  fill(C_UI_BUTTONS_TEXT);
  text(buttons_reset_en_str, buttons_reset_en_str_x, buttons_reset_en_str_y);

  text(buttons_reset_en_caption_str, buttons_reset_en_caption_str_x, buttons_reset_en_caption_str_y);
}

void UI_Buttons_check_over()
{
  if (!UI_Buttons_enabled) return;

  if( mouse_is_over(buttons_zoom_minus_x, buttons_zoom_minus_y, buttons_zoom_minus_width, buttons_zoom_minus_height) )
  {
    //println("ZOOM_FACTOR[0]=" + ZOOM_FACTOR[0]);
    buttons_zoom_minus_over = true;
    buttons_zoom_pluse_over =
    buttons_rotate_ccw_over =
    buttons_rotate_cw_over =
    buttons_mirror_ud_over =
    buttons_mirror_lr_over =
    buttons_reset_en_over = false;
  }
  else if( mouse_is_over(buttons_zoom_pluse_x, buttons_zoom_pluse_y, buttons_zoom_pluse_width, buttons_zoom_pluse_height) )
  {
    //println("ZOOM_FACTOR[0]=" + ZOOM_FACTOR[0]);
    buttons_zoom_pluse_over = true;
    buttons_zoom_minus_over =
    buttons_rotate_ccw_over =
    buttons_rotate_cw_over =
    buttons_mirror_ud_over =
    buttons_mirror_lr_over =
    buttons_reset_en_over = false;
  }
  else if( mouse_is_over(buttons_rotate_ccw_x, buttons_rotate_ccw_y, buttons_rotate_ccw_width, buttons_rotate_ccw_height) )
  {
    buttons_rotate_ccw_over = true;
    buttons_zoom_minus_over =
    buttons_zoom_pluse_over =
    buttons_rotate_cw_over =
    buttons_mirror_ud_over =
    buttons_mirror_lr_over =
    buttons_reset_en_over = false;
  }
  else if( mouse_is_over(buttons_rotate_cw_x, buttons_rotate_cw_y, buttons_rotate_cw_width, buttons_rotate_cw_height) )
  {
    buttons_rotate_cw_over = true;
    buttons_zoom_minus_over =
    buttons_zoom_pluse_over =
    buttons_rotate_ccw_over =
    buttons_mirror_ud_over =
    buttons_mirror_lr_over =
    buttons_reset_en_over = false;
  }
  else if( mouse_is_over(buttons_mirror_ud_x, buttons_mirror_ud_y, buttons_mirror_ud_width, buttons_mirror_ud_height) )
  {
    buttons_mirror_ud_over = true;
    buttons_zoom_minus_over =
    buttons_zoom_pluse_over =
    buttons_rotate_ccw_over =
    buttons_rotate_cw_over =
    buttons_mirror_lr_over =
    buttons_reset_en_over = false;
  }
  else if( mouse_is_over(buttons_mirror_lr_x, buttons_mirror_lr_y, buttons_mirror_lr_width, buttons_mirror_lr_height) )
  {
    buttons_mirror_lr_over = true;
    buttons_zoom_minus_over =
    buttons_zoom_pluse_over =
    buttons_rotate_ccw_over =
    buttons_rotate_cw_over =
    buttons_mirror_ud_over =
    buttons_reset_en_over = false;
  }
  else if( mouse_is_over(buttons_reset_en_x, buttons_reset_en_y, buttons_reset_en_width, buttons_reset_en_height) )
  {
    buttons_reset_en_over = true;
    buttons_zoom_minus_over =
    buttons_zoom_pluse_over =
    buttons_rotate_ccw_over =
    buttons_rotate_cw_over =
    buttons_mirror_ud_over =
    buttons_mirror_lr_over = false;
  }
  else
  {
    buttons_zoom_minus_over =
    buttons_zoom_pluse_over =
    buttons_rotate_ccw_over =
    buttons_rotate_cw_over =
    buttons_mirror_ud_over =
    buttons_mirror_lr_over =
    buttons_reset_en_over = false;
  }
}

void UI_Buttons_zoom_minus()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (ZOOM_FACTOR[i] < 5000)
    {
      if (ZOOM_FACTOR[i] < 200) ZOOM_FACTOR[i] += 10;
      else if (ZOOM_FACTOR[i] < 1000) ZOOM_FACTOR[i] += 100;
      else if (ZOOM_FACTOR[i] < 2000) ZOOM_FACTOR[i] += 200;
      else ZOOM_FACTOR[i] += 500;
      Screen_update_variable();
    }
    if(PRINT_UI_BUTTONS_ZOOM_DBG) println("ZOOM_FACTOR["+i+"]=" + ZOOM_FACTOR[i]);
  }
}

void UI_Buttons_zoom_pluse()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (ZOOM_FACTOR[i] > 20)
    {
      if (ZOOM_FACTOR[i] <= 200) ZOOM_FACTOR[i] -= 10;
      else if (ZOOM_FACTOR[i] <= 1000) ZOOM_FACTOR[i] -= 100;
      else if (ZOOM_FACTOR[i] <= 2000) ZOOM_FACTOR[i] -= 200;
      else ZOOM_FACTOR[i] -= 500;
      Screen_update_variable();
    }
    if(PRINT_UI_BUTTONS_ZOOM_DBG) println("ZOOM_FACTOR["+i+"]=" + ZOOM_FACTOR[i]);
  }
}

void UI_Buttons_rotate_ccw()
{
  float save_ox, save_oy;
  ROTATE_FACTOR[0] -= 90;
  if (ROTATE_FACTOR[0] < 0) ROTATE_FACTOR[0] += 360;
  save_ox = float(DRAW_OFFSET_X[0]);
  save_oy = float(DRAW_OFFSET_Y[0]);
  if (ROTATE_FACTOR[0] == 315) { // OK
    DRAW_OFFSET_X[0] =  int(save_oy - (float(SCREEN_height) / 2.0) + (float(SCREEN_width)  / 2.0));
    DRAW_OFFSET_Y[0] = -int(save_ox);
  }
  else if (ROTATE_FACTOR[0] == 45) { // OK
    DRAW_OFFSET_Y[0] = -int(save_ox + (float(SCREEN_width)  / 2.0) - (float(SCREEN_height) / 2.0));
    DRAW_OFFSET_X[0] =  int(save_oy);
  }
  else if (ROTATE_FACTOR[0] == 135) { // OK
    DRAW_OFFSET_X[0] =  int(save_oy + (float(SCREEN_height) / 2.0) - (float(SCREEN_width)  / 2.0));
    DRAW_OFFSET_Y[0] = -int(save_ox);
  }
  else /*if (ROTATE_FACTOR[0] == 225)*/ { // OK
    DRAW_OFFSET_Y[0] = -int(save_ox - (float(SCREEN_width)  / 2.0) + (float(SCREEN_height) / 2.0));
    DRAW_OFFSET_X[0] =  int(save_oy);
  }
  Screen_update_variable();
  if(PRINT_UI_BUTTONS_ROTATE_DBG) println("ROTATE_FACTOR[0]=" + ROTATE_FACTOR[0]);
}

void UI_Buttons_rotate_cw()
{
  float save_ox, save_oy;
  ROTATE_FACTOR[0] += 90;
  if (ROTATE_FACTOR[0] > 360) ROTATE_FACTOR[0] -= 360;
  save_ox = float(DRAW_OFFSET_X[0]);
  save_oy = float(DRAW_OFFSET_Y[0]);
  if (ROTATE_FACTOR[0] == 315) { // OK
    DRAW_OFFSET_X[0] = -int(save_oy + (float(SCREEN_height) / 2.0) - (float(SCREEN_width)  / 2.0));
    DRAW_OFFSET_Y[0] =  int(save_ox);
  }
  else if (ROTATE_FACTOR[0] == 45) { // OK
    DRAW_OFFSET_Y[0] =  int(save_ox - (float(SCREEN_width)  / 2.0) + (float(SCREEN_height) / 2.0));
    DRAW_OFFSET_X[0] = -int(save_oy);
  }
  else if (ROTATE_FACTOR[0] == 135) { // OK
    DRAW_OFFSET_X[0] = -int(save_oy - (float(SCREEN_height) / 2.0) + (float(SCREEN_width)  / 2.0));
    DRAW_OFFSET_Y[0] =  int(save_ox);
  }
  else /*if (ROTATE_FACTOR[0] == 225)*/ { // OK
    DRAW_OFFSET_Y[0] =  int(save_ox + (float(SCREEN_width)  / 2.0) - (float(SCREEN_height) / 2.0));
    DRAW_OFFSET_X[0] = -int(save_oy);
  }
  Screen_update_variable();
  if(PRINT_UI_BUTTONS_ROTATE_DBG) println("ROTATE_FACTOR[0]=" + ROTATE_FACTOR[0]);
}

void UI_Buttons_mirror_ud()
{
  MIRROR_ENABLE[0] = !MIRROR_ENABLE[0];
  if (ROTATE_FACTOR[0] == 45 || ROTATE_FACTOR[0] == 225)
  {
    if(PRINT_UI_BUTTONS_MIRROR_DBG) println("Old DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
    if (ROTATE_FACTOR[0] == 45) { // OK
      ROTATE_FACTOR[0] = 225;
      DRAW_OFFSET_X[0] = DRAW_OFFSET_X[0];
      DRAW_OFFSET_Y[0] += -(SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT));
    }
    else /*if (ROTATE_FACTOR[0] == 225)*/ { // OK
      ROTATE_FACTOR[0] = 45;
      DRAW_OFFSET_X[0] = DRAW_OFFSET_X[0];
      DRAW_OFFSET_Y[0] += SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT);
    }
    if(PRINT_UI_BUTTONS_MIRROR_DBG) println("New DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
  }
  Screen_update_variable();
  if(PRINT_UI_BUTTONS_MIRROR_DBG) println("MIRROR_ENABLE[0]=" + MIRROR_ENABLE[0] + ", ROTATE_FACTOR[0]=" + ROTATE_FACTOR[0]);
}

void UI_Buttons_mirror_lr()
{
  MIRROR_ENABLE[0] = !MIRROR_ENABLE[0];
  if (ROTATE_FACTOR[0] == 315 || ROTATE_FACTOR[0] == 135)
  {
    if(PRINT_UI_BUTTONS_MIRROR_DBG) println("Old DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
    if (ROTATE_FACTOR[0] == 315) { // OK
      ROTATE_FACTOR[0] = 135;
      DRAW_OFFSET_X[0] += -(SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT));
      DRAW_OFFSET_Y[0] = DRAW_OFFSET_Y[0];
    }
    else /*if (ROTATE_FACTOR[0] == 135)*/ { // OK
      ROTATE_FACTOR[0] = 315;
      DRAW_OFFSET_X[0] += SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT);
      DRAW_OFFSET_Y[0] = DRAW_OFFSET_Y[0];
    }
    if(PRINT_UI_BUTTONS_MIRROR_DBG) println("New DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
  }
  Screen_update_variable();
  if(PRINT_UI_BUTTONS_MIRROR_DBG) println("MIRROR_ENABLE[0]=" + MIRROR_ENABLE[0] + ", ROTATE_FACTOR[0]=" + ROTATE_FACTOR[0]);
}

void UI_Buttons_reset_en()
{
  if(PRINT_UI_BUTTONS_RESET_DBG)
  {
    println("ZOOM_FACTOR[0]=" + ZOOM_FACTOR[0]);
    println("MIRROR_ENABLE[0]=" + MIRROR_ENABLE[0]);
    println("DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
  }
  DRAW_OFFSET_X[0] = DRAW_OFFSET_Y[0] = 0;
  MIRROR_ENABLE[0] = false;
  ZOOM_FACTOR[0] = 100;

  Screen_update_variable();
}


