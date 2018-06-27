//final static boolean PRINT_UI_MESSAGE_BOX_ZOOM_DBG = true; 
final static boolean PRINT_UI_MESSAGE_BOX_ZOOM_DBG = false;

//final static boolean PRINT_UI_MESSAGE_BOX_ROTATE_DBG = true; 
final static boolean PRINT_UI_MESSAGE_BOX_ROTATE_DBG = false;

//final static boolean PRINT_UI_MESSAGE_BOX_MIRROR_DBG = true; 
final static boolean PRINT_UI_MESSAGE_BOX_MIRROR_DBG = false;

//final static boolean PRINT_UI_MESSAGE_BOX_RESET_DBG = true; 
final static boolean PRINT_UI_MESSAGE_BOX_RESET_DBG = false;

/*
static color C_UI_MESSAGE_BOX_FILL = #FFFFFF; // White
static color C_UI_MESSAGE_BOX_TEXT = #000000; // Black
static color C_UI_MESSAGE_BOX_RECT = #000000; // Black
static int W_UI_MESSAGE_BOX_RECT = 1; // Black
*/
static color C_UI_MESSAGE_BOX_FILL = 0xC0000000; // White
static color C_UI_MESSAGE_BOX_TEXT = 0xC0FFFFFF; // Black
static color C_UI_MESSAGE_BOX_RECT = 0xC0FFFFFF; // Black
static int W_UI_MESSAGE_BOX_RECT = 1; // Black

static boolean UI_Message_Box_enabled = false;

static enum UI_Message_Box_button_enum {
  NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7, NUM_8, NUM_9,
  CLEAR, BACK, ENTER, OUTPUT
}

static UI_Message_Box UI_Message_Box_handle = null;

void UI_Message_Box_setup(String title, String message, int time_out)
{
  UI_Message_Box_handle = new UI_Message_Box(title, message, time_out);
  UI_Message_Box_enabled = true;
}

void UI_Message_Box_reset()
{
  UI_Message_Box_enabled = false;
}

void UI_Message_Box_mouse_pressed()
{
  if (!UI_Message_Box_enabled) return;

  UI_Message_Box_handle.forced_time_out = true;
  //UI_Message_Box_handle.mouse_pressed();
}

void UI_Message_Box_mouse_released()
{
  if (!UI_Message_Box_enabled) return;

  //UI_Message_Box_handle.mouse_released();
}

void UI_Message_Box_mouse_moved()
{
  if (!UI_Message_Box_enabled) return;

  //UI_Message_Box_handle.mouse_moved();
}

void UI_Message_Box_mouse_dragged()
{
  if (!UI_Message_Box_enabled) return;

  //UI_Message_Box_mouse_moved();
}

class UI_Message_Box {
  String title;
  String msg;
  int box_x, box_y, box_w, box_h;
  int title_x, title_y, title_w, title_h;
  int msg_x, msg_y, msg_w, msg_h;
  int time_out;
  int time_start;
  boolean forced_time_out = false;

  UI_Message_Box(String title, String msg, int time_out) {
    set(title, msg, time_out, SCREEN_width, SCREEN_height);
  }

  UI_Message_Box(String title, String msg, int time_out, int width, int height) {
    set(title, msg, time_out, width, height);
  }

  private void set(String title, String msg, int time_out, int width, int height) {
    String[] lines = msg.split("\r\n|\r|\n");

    int center_x, center_y;
    int width_max = 0;
    center_x = SCREEN_width / 2;
    center_y = SCREEN_height / 2;

    textSize(FONT_HEIGHT*1.5);
    width_max = max(width_max, int(textWidth(msg))) + int(TEXT_MARGIN * 2 * 1.5);
    textSize(FONT_HEIGHT*2);
    width_max = max(width_max, int(textWidth(title))) + TEXT_MARGIN * 2 * 2;

    this.msg = msg;
    this.msg_w = min(width, width_max);
    this.msg_h = int((TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN) * 1.5) * (lines.length + 2);
    //println("msg_h="+msg_h);
    this.title = title;
    this.title_w = min(width, width_max);
    //this.title_h = int(FONT_HEIGHT * 2.0 * ((this.title_w / width_max) + 1));
    this.title_h = int((TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN) * 2.0);
    //println("title_h="+title_h);
    this.box_w = max(this.msg_w, this.title_w) + TEXT_MARGIN * 2;
    this.box_h = this.title_h + this.msg_h + TEXT_MARGIN * 2;

    this.msg_x = center_x - this.msg_w / 2;
    this.msg_y = center_y - this.msg_h / 2;
    this.title_x = center_x - this.title_w / 2;
    this.title_y = this.msg_y - this.title_h;
    this.box_x = min(this.msg_x, this.title_x) - TEXT_MARGIN;
    this.box_y = this.title_y - TEXT_MARGIN;

    this.time_out = time_out;
    this.time_start = millis();
  }

  boolean draw() {
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(C_UI_MESSAGE_BOX_RECT);
    strokeWeight(W_UI_MESSAGE_BOX_RECT);

    fill(C_UI_MESSAGE_BOX_FILL);
    rect(box_x, box_y, box_w, box_h, 3, 3, 3, 3);
    rect(box_x, box_y, box_w, title_h, 3, 3, 0, 0);
    //rect(title_x, title_y, title_w, title_h);
    //rect(msg_x, msg_y, msg_w, msg_h);

    fill(C_UI_MESSAGE_BOX_TEXT);
    textAlign(LEFT, TOP);
    textSize(FONT_HEIGHT*2);
    text(title, title_x, title_y, title_w, title_h);
    textAlign(CENTER, CENTER);
    textSize(FONT_HEIGHT*1.5);
    text(msg, msg_x, msg_y, msg_w, msg_h);

    if (forced_time_out
        ||
        ( time_out > 0
          &&
          millis() - time_start > time_out)) {
      return false;
    }

    return true;
  }

}
