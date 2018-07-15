//final static boolean PRINT_UI_BUTTONS_ALL_DBG = true;
final static boolean PRINT_UI_BUTTONS_ALL_DBG = false;

//final static boolean PRINT_UI_BUTTONS_SETUP_DBG = true;
final static boolean PRINT_UI_BUTTONS_SETUP_DBG = false;

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

static String UI_Buttons_zoom_minus_str = "-";           // button string zoom minus
static String UI_Buttons_zoom_pluse_str = "+";           // button string zoom pluse
static String UI_Buttons_zoom_caption_str = "Zoom";      // button string zoom pluse

//static String UI_Buttons_rotate_ccw_str = "↺";           // button string rotate counter clock-wise
static String UI_Buttons_rotate_cw_str = "↻";            // button string rotate clock-wise
static String UI_Buttons_rotate_caption_str = "Rotate";  // button string rotate clock-wise

static String UI_Buttons_mirror_ud_str = "⇅";            // button string mirror enable
//static String UI_Buttons_mirror_lr_str = "⇄";            // button string mirror enable
static String UI_Buttons_mirror_caption_str = "Mirror";  // button string mirror enable

//static String UI_Buttons_reset_en_str = "0";             // button string reset enable
//static String UI_Buttons_reset_en_caption_str = "Reset"; // button string reset enable

static boolean UI_Buttons_enabled;
static Buttons_Group UI_Buttons_group_zoom;
static LinkedList<Buttons_Group>[] UI_Buttons_groups_array;
static enum UI_Buttons_action_enum {
  ZOOM_PLUSE, ZOOM_MINUS, ROTATE_CW, ROTATE_CCW, MIRROR_LR, MIRROR_UD, RESET, MAX
}

static enum UI_Buttons_state_enum {
  IDLE,
  PASSWORD_REQ,
  DRAW_BUTTONS,
  DISPLAY_MESSAGE,
  MAX
}
static UI_Buttons_state_enum UI_Buttons_state;
static UI_Buttons_state_enum UI_Buttons_state_next;
static int UI_Buttons_timeout_start;

void UI_Buttons_setup()
{
  if (PRINT_UI_BUTTONS_ALL_DBG || PRINT_UI_BUTTONS_SETUP_DBG) println("UI_Buttons_setup():Enter");

  //UI_Buttons_enabled = true;
  UI_Buttons_enabled = false;

  UI_Buttons_groups_array = new LinkedList[PS_INSTANCE_MAX];

  //int top_y = SCREEN_height - FONT_HEIGHT - FONT_HEIGHT * 2 * 2 - TEXT_MARGIN - FONT_HEIGHT - TEXT_MARGIN;
  int top_y = SCREEN_height / 2 - FONT_HEIGHT - FONT_HEIGHT * 2 * 2 - TEXT_MARGIN - FONT_HEIGHT - TEXT_MARGIN;
  int offset_top_y_start = FONT_HEIGHT + TEXT_MARGIN + TEXT_MARGIN;
  int w_h = FONT_HEIGHT * 2;
  int center_x_adv = 0;
  int top_y_adv = FONT_HEIGHT * 4;

  UI_Buttons_state = UI_Buttons_state_enum.IDLE;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    UI_Buttons_groups_array[i] = new LinkedList<Buttons_Group>();

    int center_x_start;
    Buttons_Group buttons_group;

    switch (i)
    {
      case 0:
        //center_x_start = TEXT_MARGIN + FONT_HEIGHT + FONT_HEIGHT;
        center_x_start = TEXT_MARGIN + FONT_HEIGHT + FONT_HEIGHT / 2;
        //center_x_adv = FONT_HEIGHT * 3;
        //top_y_adv = 0;
        break;
      case 1:
        //center_x_start = SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT + FONT_HEIGHT);
        center_x_start = SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT + FONT_HEIGHT / 2);
        //center_x_adv = -(FONT_HEIGHT * 3);
        //top_y_adv = 0;
        break;
      default:
        continue;
    }

    buttons_group =
      new Buttons_Group(
        UI_Buttons_zoom_caption_str, center_x_start, top_y,
        C_UI_BUTTONS_BOX, W_UI_BUTTONS_BOX, C_UI_BUTTONS_NORMAL, C_UI_BUTTONS_HIGHLIGHT, C_UI_BUTTONS_TEXT);
    buttons_group.add_button(
      UI_Buttons_action_enum.ZOOM_PLUSE, UI_Buttons_zoom_pluse_str,
      0, offset_top_y_start, w_h, w_h);
    buttons_group.add_button(
      UI_Buttons_action_enum.ZOOM_MINUS, UI_Buttons_zoom_minus_str,
       0, offset_top_y_start + FONT_HEIGHT * 2, w_h, w_h);
    UI_Buttons_groups_array[i].add(buttons_group);

    buttons_group =
      new Buttons_Group(
        UI_Buttons_rotate_caption_str, center_x_start + center_x_adv, top_y + top_y_adv + w_h,
        C_UI_BUTTONS_BOX, W_UI_BUTTONS_BOX, C_UI_BUTTONS_NORMAL, C_UI_BUTTONS_HIGHLIGHT, C_UI_BUTTONS_TEXT);
    buttons_group.add_button(
      UI_Buttons_action_enum.ROTATE_CW, UI_Buttons_rotate_cw_str,
      0, offset_top_y_start, w_h, w_h);
    /*
    buttons_group.add_button(
      UI_Buttons_action_enum.ROTATE_CCW, UI_Buttons_rotate_ccw_str,
      0, offset_top_y_start + FONT_HEIGHT * 2, w_h, w_h);
    */
    UI_Buttons_groups_array[i].add(buttons_group);

    buttons_group =
      new Buttons_Group(
        UI_Buttons_mirror_caption_str, center_x_start + center_x_adv * 2, top_y + top_y_adv * 2 + w_h,
        C_UI_BUTTONS_BOX, W_UI_BUTTONS_BOX, C_UI_BUTTONS_NORMAL, C_UI_BUTTONS_HIGHLIGHT, C_UI_BUTTONS_TEXT);
    /*
    buttons_group.add_button(
      UI_Buttons_action_enum.MIRROR_LR, UI_Buttons_mirror_lr_str,
      0, offset_top_y_start, w_h, w_h);
    */
    buttons_group.add_button(
      UI_Buttons_action_enum.MIRROR_UD, UI_Buttons_mirror_ud_str,
      //0, offset_top_y_start + FONT_HEIGHT * 2, w_h, w_h);
      0, offset_top_y_start, w_h, w_h);
    UI_Buttons_groups_array[i].add(buttons_group);

    /*
    buttons_group =
      new Buttons_Group(
        UI_Buttons_reset_en_caption_str, center_x_start + center_x_adv * 3, top_y + top_y_adv * 3 + w_h,
        C_UI_BUTTONS_BOX, W_UI_BUTTONS_BOX, C_UI_BUTTONS_NORMAL, C_UI_BUTTONS_HIGHLIGHT, C_UI_BUTTONS_TEXT);
    buttons_group.add_button(
      UI_Buttons_action_enum.RESET, UI_Buttons_reset_en_str,
      0, offset_top_y_start, w_h, w_h);
    UI_Buttons_groups_array[i].add(buttons_group);
    */
  }
}

void UI_Buttons_draw()
{
  //println("UI_Buttons_state=", UI_Buttons_state);
  switch (UI_Buttons_state)
  {
    case IDLE:
      if (!UI_Buttons_enabled)
      {
        break;
      }

      // Check password not required.
      if (SYSTEM_PASSWORD_disabled)
      {
        UI_Buttons_state = UI_Buttons_state_enum.DRAW_BUTTONS;
        UI_Buttons_timeout_start = millis();
        break;
      }

      UI_Num_Pad_setup("Input system password");
      UI_Buttons_state = UI_Buttons_state_enum.PASSWORD_REQ;
      break;
    case PASSWORD_REQ:
      if (!UI_Buttons_enabled)
      {
        UI_Buttons_state = UI_Buttons_state_enum.IDLE;
        break;
      }

      UI_Num_Pad_handle.draw();
      if (!UI_Num_Pad_handle.input_done())
      {
        break;
      }

      if (UI_Num_Pad_handle.input_string == null)
      {
        UI_Buttons_enabled = false;
        UI_Buttons_state = UI_Buttons_state_enum.IDLE;
        break;
      }

      // Input done, check password.
      if (!UI_Num_Pad_handle.input_string.equals(SYSTEM_PASSWORD))
      {
        // Password fail...
        UI_Message_Box_setup("Error !", "Wrong password input!\nYou can NOT access special functions.", 5000);
        UI_Buttons_state = UI_Buttons_state_enum.DISPLAY_MESSAGE;
        UI_Buttons_state_next = UI_Buttons_state_enum.IDLE;
        UI_Buttons_enabled = false;
        break;
      }

      UI_Buttons_state = UI_Buttons_state_enum.DRAW_BUTTONS;
      UI_Buttons_timeout_start = millis();
      break;
    case DRAW_BUTTONS:
      if (!UI_Buttons_enabled)
      {
        UI_Buttons_state = UI_Buttons_state_enum.IDLE;
        break;
      }

      if (get_millis_diff(UI_Buttons_timeout_start) > SYSTEM_UI_TIMEOUT * 1000)
      {
        UI_Buttons_enabled = false;
        UI_Buttons_state = UI_Buttons_state_enum.IDLE;
        break;
      }

      for (int i = 0; i < PS_INSTANCE_MAX; i ++)
      {
        for (Buttons_Group buttons_group:UI_Buttons_groups_array[i])
        {
          buttons_group.draw();
        }
      }
      break;
    case DISPLAY_MESSAGE:
      if (UI_Message_Box_handle.draw())
      {
        break;
      }
      UI_Buttons_state = UI_Buttons_state_next;
      break;
  }
}

void UI_Buttons_mouse_pressed()
{
  if (!UI_Buttons_enabled) return;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    for (Buttons_Group buttons_group:UI_Buttons_groups_array[i])
    {
      if (buttons_group.mouse_pressed()) {
        switch (buttons_group.get_action())
        {
          case ZOOM_PLUSE:
            UI_Buttons_zoom_pluse(i);
            break;
          case ZOOM_MINUS:
            UI_Buttons_zoom_minus(i);
            break;
          case ROTATE_CW:
            UI_Buttons_rotate_cw(i);
            break;
          case ROTATE_CCW:
            UI_Buttons_rotate_ccw(i);
            break;
          case MIRROR_UD:
            UI_Buttons_mirror_ud(i);
            break;
          case MIRROR_LR:
            UI_Buttons_mirror_lr(i);
            break;
          case RESET:
            UI_Buttons_reset_en(i);
            break;
        }
      }
    }
  }
}

void UI_Buttons_mouse_released()
{
  if (!UI_Buttons_enabled) return;
}

void UI_Buttons_mouse_moved()
{
  if (!UI_Buttons_enabled) return;

  UI_Buttons_timeout_start = millis();

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    for (Buttons_Group buttons_group:UI_Buttons_groups_array[i])
    {
      buttons_group.mouse_moved();
    }
  }
}

void UI_Buttons_mouse_dragged()
{
  if (!UI_Buttons_enabled) return;

  UI_Buttons_timeout_start = millis();

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    for (Buttons_Group buttons_group:UI_Buttons_groups_array[i])
    {
      buttons_group.mouse_dragged();
    }
  }
}

void UI_Buttons_mouse_wheel(int wheel_count)
{
  if (!UI_Buttons_enabled) return;

  UI_Buttons_timeout_start = millis();

  if (wheel_count > 0)
  {
    //for (; wheel_count > 0; wheel_count -= 1)
    {
      for (int i = 0; i < PS_INSTANCE_MAX; i ++)
        UI_Buttons_zoom_minus(i);
    }
  }
  else if (wheel_count < 0)
  {
    //for (; wheel_count < 0; wheel_count += 1)
    {  
      for (int i = 0; i < PS_INSTANCE_MAX; i ++)
        UI_Buttons_zoom_pluse(i);
    }
  }
}

void UI_Buttons_zoom_minus(int i)
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

void UI_Buttons_zoom_pluse(int i)
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

void UI_Buttons_rotate_ccw(int i)
{
  ROTATE_FACTOR[i] -= 90;
  if (ROTATE_FACTOR[i] < 0) ROTATE_FACTOR[i] += 360;
  Screen_update_offsets();
  Screen_update_variable();
  if(PRINT_UI_BUTTONS_ROTATE_DBG) println("ROTATE_FACTOR[i]=" + ROTATE_FACTOR[i]);
}

void UI_Buttons_rotate_cw(int i)
{
  if (ROTATE_FACTOR[i] == 135 && MIRROR_ENABLE[i] == true)
  {
    ROTATE_FACTOR[i] = 225;
    MIRROR_ENABLE[i] = false;
  }
  else if (ROTATE_FACTOR[i] == 225 && MIRROR_ENABLE[i] == false)
  {
    ROTATE_FACTOR[i] = 135;
    MIRROR_ENABLE[i] = true;
  }
  else if (ROTATE_FACTOR[i] == 45 && MIRROR_ENABLE[i] == true)
  {
    ROTATE_FACTOR[i] = 135;
    MIRROR_ENABLE[i] = false;
  }
  else if(ROTATE_FACTOR[i] == 135 && MIRROR_ENABLE[i] == false)
  {
    ROTATE_FACTOR[i] = 45;
    MIRROR_ENABLE[i] = true;
  }
  else if (ROTATE_FACTOR[i] == 315 && MIRROR_ENABLE[i] == false)
  {
    ROTATE_FACTOR[i] = 225;
    MIRROR_ENABLE[i] = true;
  }
  else if (ROTATE_FACTOR[i] == 225 && MIRROR_ENABLE[i] == true)
  {
    ROTATE_FACTOR[i] = 315;
    MIRROR_ENABLE[i] = false;
  }
  else if (ROTATE_FACTOR[i] == 45 && MIRROR_ENABLE[i] == false)
  {
    ROTATE_FACTOR[i] = 315;
    MIRROR_ENABLE[i] = true;
  }
  else if(ROTATE_FACTOR[i] == 315 && MIRROR_ENABLE[i] == true)
  {
    ROTATE_FACTOR[i] = 45;
    MIRROR_ENABLE[i] = false;
  }

/*
  ROTATE_FACTOR[i] += 90;
  if (ROTATE_FACTOR[i] > 360) ROTATE_FACTOR[i] -= 360;
*/
  Screen_update_offsets();
  Screen_update_variable();
  if(PRINT_UI_BUTTONS_ROTATE_DBG) println("ROTATE_FACTOR[i]=" + ROTATE_FACTOR[i]);
}

void UI_Buttons_mirror_ud(int i)
{
  MIRROR_ENABLE[i] = !MIRROR_ENABLE[i];
  if (ROTATE_FACTOR[i] == 45 || ROTATE_FACTOR[i] == 225)
  {
    if (ROTATE_FACTOR[i] == 45) { // OK
      ROTATE_FACTOR[i] = 225;
    }
    else /*if (ROTATE_FACTOR[i] == 225)*/ { // OK
      ROTATE_FACTOR[i] = 45;
    }
  }
  Screen_update_offsets();
  Screen_update_variable();
  if(PRINT_UI_BUTTONS_MIRROR_DBG) println("MIRROR_ENABLE[i]=" + MIRROR_ENABLE[i] + ", ROTATE_FACTOR[i]=" + ROTATE_FACTOR[i]);
}

void UI_Buttons_mirror_lr(int i)
{
  MIRROR_ENABLE[i] = !MIRROR_ENABLE[i];
  if (ROTATE_FACTOR[i] == 315 || ROTATE_FACTOR[i] == 135)
  {
    if (ROTATE_FACTOR[i] == 315) { // OK
      ROTATE_FACTOR[i] = 135;
    }
    else /*if (ROTATE_FACTOR[i] == 135)*/ { // OK
      ROTATE_FACTOR[i] = 315;
    }
  }
  Screen_update_offsets();
  Screen_update_variable();
  if(PRINT_UI_BUTTONS_MIRROR_DBG) println("MIRROR_ENABLE[i]=" + MIRROR_ENABLE[i] + ", ROTATE_FACTOR[i]=" + ROTATE_FACTOR[i]);
}

void UI_Buttons_reset_en(int i)
{
  if(PRINT_UI_BUTTONS_RESET_DBG)
  {
    println("ZOOM_FACTOR[i]=" + ZOOM_FACTOR[i]);
    println("MIRROR_ENABLE[i]=" + MIRROR_ENABLE[i]);
    println("DRAW_OFFSET_X[i]=" + DRAW_OFFSET_X[i] + ", DRAW_OFFSET_Y[i]=" + DRAW_OFFSET_Y[i]);
  }
  DRAW_OFFSET_X[i] = DRAW_OFFSET_Y[i] = 0;
  MIRROR_ENABLE[i] = false;
  ZOOM_FACTOR[i] = 100;

  Screen_update_offsets();
  Screen_update_variable();
}

class Buttons_Group {
  private LinkedList<Button_Instance> buttons = new LinkedList<Button_Instance>();
  private int center_x, top_y;
  private String text;
  private color stroke_c;
  private int stroke_w;
  private color fill_c_normal;
  private color fill_c_highlight;
  private color fill_c_text;
  private UI_Buttons_action_enum action;

  Buttons_Group(String text, int center_x, int top_y, color stroke_c, int stroke_w, color fill_c_normal, color fill_c_highlight, color fill_c_text) {
    this.text = text;
    this.center_x = center_x;
    this.top_y = top_y;
    this.stroke_c = stroke_c;
    this.stroke_w = stroke_w;
    this.fill_c_normal = fill_c_normal;
    this.fill_c_highlight = fill_c_highlight;
    this.fill_c_text = fill_c_text;
  }

  public void set_caption_text(String text) {
    this.text = text;
  }

  public void add_button(UI_Buttons_action_enum action, String text, int offset_center_x, int offset_top_y, int w, int h) {
    int left_x, top_y;
    left_x = int(this.center_x + offset_center_x - w / 2.0 );
    top_y = this.top_y + offset_top_y;
    this.buttons.add(new Button_Instance(action, text, left_x, top_y, w, h));
  }

  public void draw() {
    textSize(FONT_HEIGHT);
    //textAlign(CENTER, TOP);
    //textAlign(CENTER, BASELINE);
    textAlign(CENTER, CENTER);
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(stroke_c);
    strokeWeight(stroke_w);
    for (Button_Instance button:buttons) {
      button.draw(fill_c_normal, fill_c_highlight, fill_c_text);
    }
    textAlign(CENTER, TOP);
    text(text, center_x, top_y);
  }

  public UI_Buttons_action_enum get_action() {
    return action;
  }

  public boolean mouse_pressed() {
    for (Button_Instance button:buttons) {
      if (button.mouse_pressed()) {
        this.action = button.get_action();
        return true;
      }
    }
    return false;
  }

  public void mouse_moved() {
    for (Button_Instance button:buttons) {
      button.mouse_moved();
    }
  }

  public void mouse_dragged() {
    for (Button_Instance button:buttons) {
      button.mouse_dragged();
    }
  }
}

class Button_Instance {
  private UI_Buttons_action_enum action;
  private int left_x, top_y;
  private int w, h;
  private String text;
  private boolean focused;
  private boolean pressed;

  Button_Instance(UI_Buttons_action_enum action, String text, int left_x, int top_y, int w, int h) {
    this.action = action;
    this.text = text;
    this.left_x = left_x;
    this.top_y = top_y;
    this.w = w;
    this.h = h;
    this.focused = false;
    this.pressed = false;
  }

  public void set_text(String text) {
    this.text = text;
  }

  public void draw(color fill_c_normal, color fill_c_highlight, color fill_c_text) {
    if (focused) {
      fill(fill_c_highlight);
    }
    else {
      fill(fill_c_normal);
    }
    rect(left_x, top_y, w, h);
    fill(fill_c_text);
    text(text, left_x, top_y, w, h);
  }

  public UI_Buttons_action_enum get_action() {
    return action;
  }

  public boolean mouse_pressed() {
    if (focused) {
      pressed = true;
    }
    else
    {
      pressed = false;
    }
    return pressed;
  }

  public void mouse_moved() {
    if (mouse_is_over(left_x, top_y, w, h)) {
      focused = true;
    }
    else
    {
      focused = false;
    }
  }

  public void mouse_dragged() {
    if (mouse_is_over(left_x, top_y, w, h)) {
      focused = true;
    }
    else
    {
      focused = false;
    }
  }
}
