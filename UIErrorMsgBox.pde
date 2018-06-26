//final static boolean PRINT_UI_ERR_MSG_BOX_ZOOM_DBG = true; 
final static boolean PRINT_UI_ERR_MSG_BOX_ZOOM_DBG = false;

//final static boolean PRINT_UI_ERR_MSG_BOX_ROTATE_DBG = true; 
final static boolean PRINT_UI_ERR_MSG_BOX_ROTATE_DBG = false;

//final static boolean PRINT_UI_ERR_MSG_BOX_MIRROR_DBG = true; 
final static boolean PRINT_UI_ERR_MSG_BOX_MIRROR_DBG = false;

//final static boolean PRINT_UI_ERR_MSG_BOX_RESET_DBG = true; 
final static boolean PRINT_UI_ERR_MSG_BOX_RESET_DBG = false;

/*
static color C_UI_ERR_MSG_BOX_NORMAL = #FFFFFF; // White
static color C_UI_ERR_MSG_BOX_HIGHLIGHT = #C0C0C0; //
static color C_UI_ERR_MSG_BOX_TEXT = #000000; // Black
static color C_UI_ERR_MSG_BOX_BOX = #000000; // Black
static int W_UI_ERR_MSG_BOX_BOX = 1; // Black
*/
static color C_UI_ERR_MSG_BOX_NORMAL = 0xC0000000; // White
static color C_UI_ERR_MSG_BOX_HIGHLIGHT = 0xC0404040; //
static color C_UI_ERR_MSG_BOX_TEXT = 0xC0FFFFFF; // Black
static color C_UI_ERR_MSG_BOX_BOX = 0xC0FFFFFF; // Black
static int W_UI_ERR_MSG_BOX_BOX = 1; // Black

static boolean UI_Err_Mmg_Box_enabled = false;

static enum UI_Err_Mmg_Box_button_enum {
  NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7, NUM_8, NUM_9,
  CLEAR, BACK, ENTER, OUTPUT
}

static UI_Err_Mmg_Box UI_Err_Mmg_Box_handle = null;

void UI_Err_Mmg_Box_setup(String title, String message)
{
  UI_Err_Mmg_Box_handle = new UI_Err_Mmg_Box(title, message);
  UI_Err_Mmg_Box_enabled = true;
}

void UI_NumPad_mouse_pressed()
{
  if (!UI_Err_Mmg_Box_enabled) return;

  UI_Err_Mmg_Box_handle.mouse_pressed();
}

void UI_NumPad_mouse_released()
{
  if (!UI_Err_Mmg_Box_enabled) return;

  UI_Err_Mmg_Box_handle.mouse_released();
}

void UI_NumPad_mouse_moved()
{
  if (!UI_Err_Mmg_Box_enabled) return;

  UI_Err_Mmg_Box_handle.mouse_moved();
}

void UI_NumPad_mouse_dragged()
{
  if (!UI_Err_Mmg_Box_enabled) return;

  UI_NumPad_mouse_moved();
}

class UI_Err_Mmg_Box {
  String title;
  String msg;
  int box_x, box_y, box_w, box_h;
  int title_x, title_y, title_w, title_h;
  int msg_x, msg_y, msg_w, msg_h;

  UI_Err_Mmg_Box(String title, String msg) {
    set(title, msg, SCREEN_width, SCREEN_height);
  }

  UI_Err_Mmg_Box(String title, String msg, int width, int height) {
    set(title, msg, width, height);
  }

  private void set(String title, String msg, int width, int height) {
    int center_x, center_y;
    center_x = SCREEN_width / 2;
    center_y = SCREEN_height / 2;

    textSize(FONT_HEIGHT*1.5);
    this.msg = msg;
    this.msg_w = max(width, int(textWidth(msg)));
    this.msg_w = base_w * 3 + base_margin * 2;
    this.msg_h = base_h + base_margin;
    this.msg_x = offset_x;
    this.msg_y = offset_y - this.title_h;

    textSize(FONT_HEIGHT*2);
    this.title = title;
    this.title_w = base_w * 3 + base_margin * 2;
    this.title_h = base_h + base_margin;
    this.title_x = offset_x;
    this.title_y = offset_y - this.title_h;

    this.box_w = this.title_w + base_margin * 2;
    this.box_h = this.title_h + (base_h * 5 + base_margin * 4) + base_margin * 2;
    this.box_x = offset_x - base_margin;
    this.box_y = this.title_y - base_margin;

    this.input_count = input_count;
    this.input_hide = input_hide;

    int base_w = 65;
    int base_h = 65;
    int base_margin = 7;
    int offset_x = SCREEN_width / 2 - (base_w * 3 + base_margin * 2) / 2;
    int offset_y = SCREEN_height / 2 - (base_h * 5 + base_margin * 4) / 2;

    this.title = title;
    this.title_w = base_w * 3 + base_margin * 2;
    this.title_h = base_h + base_margin;
    this.title_x = offset_x;
    this.title_y = offset_y - this.title_h;
    //println("x="+title_x+"y="+title_y+"w="+title_w+"h="+title_h);

    this.box_w = this.title_w + base_margin * 2;
    this.box_h = this.title_h + (base_h * 5 + base_margin * 4) + base_margin * 2;
    this.box_x = offset_x - base_margin;
    this.box_y = this.title_y - base_margin;

    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_7, "7",
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 0 + base_margin * 0,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_8, "8",
        offset_x + base_w * 1 + base_margin * 1,
        offset_y + base_h * 0 + base_margin * 0,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_9, "9",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 0 + base_margin * 0,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_4, "4",
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 1 + base_margin * 1,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_5, "5",
        offset_x + base_w * 1 + base_margin * 1,
        offset_y + base_h * 1 + base_margin * 1,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_6, "6",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 1 + base_margin * 1,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_1, "1",
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 2 + base_margin * 2,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_2, "2",
        offset_x + base_w * 1 + base_margin * 1,
        offset_y + base_h * 2 + base_margin * 2,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_3, "3",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 2 + base_margin * 2,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.CLEAR, "Clear",
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 3 + base_margin * 3,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.NUM_0, "0",
        offset_x + base_w * 1 + base_margin * 1,
        offset_y + base_h * 3 + base_margin * 3,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.BACK, "Back",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 3 + base_margin * 3,
        base_w, base_h));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.OUTPUT, input_text,
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 4 + base_margin * 4,
        base_w * 2 + base_margin, base_h,
        false));
    buttons.add(
      new UI_Err_Mmg_Box_Button(
        UI_Err_Mmg_Box_button_enum.ENTER, "Enter",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 4 + base_margin * 4,
        base_w, base_h));
  }

  void draw() {
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(C_UI_ERR_MSG_BOX_BOX);
    strokeWeight(W_UI_ERR_MSG_BOX_BOX);

    fill(C_UI_ERR_MSG_BOX_NORMAL);
    rect(box_x, box_y, box_w, box_h, 3, 3, 3, 3);
    for (UI_Err_Mmg_Box_Button button:buttons) {
      if (button.clickable) {
        if (button.pressed) {
          fill(C_UI_ERR_MSG_BOX_HIGHLIGHT);
        }
        else {
          fill(C_UI_ERR_MSG_BOX_NORMAL);
        }
        rect(button.x, button.y, button.w, button.h, 3, 3, 3, 3);
      }
      else {
        fill(C_UI_ERR_MSG_BOX_NORMAL);
        rect(button.x, button.y, button.w, button.h);
      }
    }

    fill(C_UI_ERR_MSG_BOX_TEXT);
    textAlign(CENTER, CENTER);
    textSize(FONT_HEIGHT*2);
    text(title, title_x, title_y, title_w, title_h);
    textSize(FONT_HEIGHT*1.5);
    for (UI_Err_Mmg_Box_Button button:buttons) {
      text(button.text, button.x, button.y, button.w, button.h);
    }
  }

  void set_button_text(UI_Err_Mmg_Box_button_enum button_enum, String text) {
    for (UI_Err_Mmg_Box_Button button:buttons) {
      if (button.button_enum == button_enum) {
        button.text = text;
      }
    }
  }

  boolean input_done() {
    return this.input_done;
  }

  String get_input_string() {
    return this.input_string;
  }

  void mouse_moved() {
    for (UI_Err_Mmg_Box_Button button:buttons) {
      if (button.clickable
          &&
          mouse_is_over(button.x, button.y, button.w, button.h)) {
        button.mouse_over = true;
        //println("button "+button.text+" over.");
      }
      else
      {
        button.mouse_over = false;
      }
    }
  }

  void mouse_pressed() {
    for (UI_Err_Mmg_Box_Button button:buttons) {
      if (button.mouse_over) {
        //println("button "+button.text+" pressed.");
        button.pressed = true;

        switch(button.button_enum) {
          case ENTER:
            input_string = new String(input_chars);
            println("input_chars=\""+input_string+"\"");
            input_done = true;
            break;
          case BACK:
            if (input_index == 0) {
              break;
            }
            input_index --;
            input_text = "";
            for (int i = 0; i < 4; i ++) {
              if (i < input_index) {
                input_text = input_text + "*";
              }
              else {
                input_text = input_text + "_";
              }
              if (i != 3) {
                input_text = input_text + " ";
              }
            }
            input_chars[input_index] = ' ';
            set_button_text(UI_Err_Mmg_Box_button_enum.OUTPUT, input_text);
            break;
          case CLEAR:
            input_index = 0;
            input_text = "_ _ _ _";
            input_chars[0] = input_chars[1] = input_chars[2] = input_chars[3] = ' ';
            set_button_text(UI_Err_Mmg_Box_button_enum.OUTPUT, input_text);
            break;
          case OUTPUT:
            // Do nothing.
            break;
          default:
            if (input_index >= 4) {
              break;
            }
            input_text = "";
            for (int i = 0; i < 4; i ++) {
              if (i <= input_index) {
                input_text = input_text + "*";
              }
              else {
                input_text = input_text + "_";
              }
              if (i != 3) {
                input_text = input_text + " ";
              }
            }
            input_chars[input_index] = button.text.charAt(0);
            set_button_text(UI_Err_Mmg_Box_button_enum.OUTPUT, input_text);
            input_index ++;
            //println("input_text "+input_text);
            break;
        }
      }
      else
      {
        button.pressed = false;
      }
    }
  }

  void mouse_released() {
    for (UI_Err_Mmg_Box_Button button:buttons) {
      button.pressed = false;
    }
  }

}

class UI_Err_Mmg_Box_Button {
  int x, y;
  int w, h;
  String text;
  boolean clickable;
  boolean mouse_over;
  boolean pressed;
  UI_Err_Mmg_Box_button_enum button_enum;
  UI_Err_Mmg_Box_Button(UI_Err_Mmg_Box_button_enum button_enum, String text, int x, int y, int w, int h) {
    set(button_enum, text, x, y, w, h, true);
  }
  UI_Err_Mmg_Box_Button(UI_Err_Mmg_Box_button_enum button_enum, String text, int x, int y, int w, int h, boolean clickable) {
    set(button_enum, text, x, y, w, h, clickable);
  }

  private void set(UI_Err_Mmg_Box_button_enum button_enum, String text, int x, int y, int w, int h, boolean clickable) {
    this.button_enum = button_enum;
    this.text = text;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.clickable = clickable;
    this.mouse_over = false;
    this.pressed = false;
  }

  public void set_text(String text) {
    this.text = text;
  }
}
