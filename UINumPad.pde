//final static boolean PRINT_UI_NUM_PAD_ZOOM_DBG = true; 
final static boolean PRINT_UI_NUM_PAD_ZOOM_DBG = false;

//final static boolean PRINT_UI_NUM_PAD_ROTATE_DBG = true; 
final static boolean PRINT_UI_NUM_PAD_ROTATE_DBG = false;

//final static boolean PRINT_UI_NUM_PAD_MIRROR_DBG = true; 
final static boolean PRINT_UI_NUM_PAD_MIRROR_DBG = false;

//final static boolean PRINT_UI_NUM_PAD_RESET_DBG = true; 
final static boolean PRINT_UI_NUM_PAD_RESET_DBG = false;

/*
static color C_UI_NUM_PAD_NORMAL = #FFFFFF; // White
static color C_UI_NUM_PAD_HIGHLIGHT = #C0C0C0; //
static color C_UI_NUM_PAD_TEXT = #000000; // Black
static color C_UI_NUM_PAD_BOX = #000000; // Black
static int W_UI_NUM_PAD_BOX = 1; // Black
*/
static color C_UI_NUM_PAD_NORMAL = 0xA0000000; // White
static color C_UI_NUM_PAD_HIGHLIGHT = 0xA0404040; //
static color C_UI_NUM_PAD_TEXT = 0xA0FFFFFF; // Black
static color C_UI_NUM_PAD_BOX = 0xA0FFFFFF; // Black
static int W_UI_NUM_PAD_BOX = 1; // Black

static boolean UI_Num_Pad_enabled = false;

static enum UI_Num_Pad_button_enum {
  NUM_0, NUM_1, NUM_2, NUM_3, NUM_4, NUM_5, NUM_6, NUM_7, NUM_8, NUM_9,
  CLEAR, BACK, ENTER, OUTPUT
}

static UI_Num_Pad UI_Num_Pad_handle = null;

void UI_Num_Pad_setup(String title)
{
  UI_Num_Pad_handle = new UI_Num_Pad(title);
  UI_Num_Pad_enabled = true;
}

void UI_NumPad_mouse_pressed()
{
  if (!UI_Num_Pad_enabled) return;

  UI_Num_Pad_handle.mouse_pressed();
}

void UI_NumPad_mouse_released()
{
  if (!UI_Num_Pad_enabled) return;

  UI_Num_Pad_handle.mouse_released();
}

void UI_NumPad_mouse_moved()
{
  if (!UI_Num_Pad_enabled) return;

  UI_Num_Pad_handle.mouse_moved();
}

void UI_NumPad_mouse_dragged()
{
  if (!UI_Num_Pad_enabled) return;

  UI_NumPad_mouse_moved();
}

class UI_Num_Pad {
  LinkedList<UI_Num_Pad_Button> buttons = new LinkedList();
  boolean input_done = false;
  String title;
  int title_x, title_y, title_w, title_h;
  int border_x, border_y, border_w, border_h;
  char input_chars[] = {'_', '_', '_', '_'};
  String input_text = "_ _ _ _";
  int input_index = 0;
  String input_string;
  int input_count;
  boolean input_hide;

  UI_Num_Pad(String title) {
    set(title, 4, true);
  }

  UI_Num_Pad(String title, int input_count) {
    set(title, input_count, true);
  }

  UI_Num_Pad(String title, int input_count, boolean input_hide) {
    set(title, input_count, input_hide);
  }

  private void set(String title, int input_count, boolean input_hide) {
    this.input_count = input_count;
    this.input_hide = input_hide;

    int center_x = SCREEN_width / 2;
    int center_y = SCREEN_height / 2;

    this.title = title;
    textSize(FONT_HEIGHT*2);
    this.title_w = int(textWidth(title)) + TEXT_MARGIN * 2 * 2;
    //this.title_w = base_w * 3 + base_margin * 2;
    this.title_h = (TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN) * 2;
    //println("t_w="+title_w);
    //println("x="+title_x+"y="+title_y+"w="+title_w+"h="+title_h);

    //int base_w = this.title_w / 3 - this.title_w / 3 / 10 + this.title_w / 3 / 10 / 3;
    int base_w = this.title_w * 28 / 3 / 10 / 3 + 1;
    int base_h = base_w;
    int base_margin = this.title_w / 3 / 10;

    //println("b_w="+base_w);
    //println("b_m="+base_margin);

    this.border_w = this.title_w + base_margin * 2;
    this.border_h = this.title_h + (base_h * 5 + base_margin * 4) + base_margin * 3;

    this.title_x = center_x - this.title_w / 2;
    this.title_y = center_y - this.border_h / 2 + base_margin;
    this.border_x = this.title_x - base_margin;
    this.border_y = this.title_y - base_margin;
    //println("x="+title_x+"y="+title_y+"w="+title_w+"h="+title_h);

    int offset_x = this.title_x;
    int offset_y = this.border_y + this.title_h + base_margin * 2;

    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_7, "7",
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 0 + base_margin * 0,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_8, "8",
        offset_x + base_w * 1 + base_margin * 1,
        offset_y + base_h * 0 + base_margin * 0,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_9, "9",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 0 + base_margin * 0,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_4, "4",
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 1 + base_margin * 1,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_5, "5",
        offset_x + base_w * 1 + base_margin * 1,
        offset_y + base_h * 1 + base_margin * 1,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_6, "6",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 1 + base_margin * 1,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_1, "1",
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 2 + base_margin * 2,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_2, "2",
        offset_x + base_w * 1 + base_margin * 1,
        offset_y + base_h * 2 + base_margin * 2,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_3, "3",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 2 + base_margin * 2,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.CLEAR, "Clear",
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 3 + base_margin * 3,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.NUM_0, "0",
        offset_x + base_w * 1 + base_margin * 1,
        offset_y + base_h * 3 + base_margin * 3,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.BACK, "Back",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 3 + base_margin * 3,
        base_w, base_h));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.OUTPUT, input_text,
        offset_x + base_w * 0 + base_margin * 0,
        offset_y + base_h * 4 + base_margin * 4,
        base_w * 2 + base_margin, base_h,
        false));
    buttons.add(
      new UI_Num_Pad_Button(
        UI_Num_Pad_button_enum.ENTER, "Enter",
        offset_x + base_w * 2 + base_margin * 2,
        offset_y + base_h * 4 + base_margin * 4,
        base_w, base_h));
  }

  void draw() {
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(C_UI_NUM_PAD_BOX);
    strokeWeight(W_UI_NUM_PAD_BOX);

    fill(C_UI_NUM_PAD_NORMAL);
    rect(border_x, border_y, border_w, border_h, 3, 3, 3, 3);
    for (UI_Num_Pad_Button button:buttons) {
      if (button.clickable) {
        if (button.pressed) {
          fill(C_UI_NUM_PAD_HIGHLIGHT);
        }
        else {
          fill(C_UI_NUM_PAD_NORMAL);
        }
        rect(button.x, button.y, button.w, button.h, 3, 3, 3, 3);
      }
      else {
        fill(C_UI_NUM_PAD_NORMAL);
        rect(button.x, button.y, button.w, button.h);
      }
    }
    //rect(title_x, title_y, title_w, title_h);

    fill(C_UI_NUM_PAD_TEXT);
    textAlign(CENTER, TOP);
    textSize(FONT_HEIGHT*2);
    text(title, title_x, title_y, title_w, title_h);
    textAlign(CENTER, CENTER);
    textSize(FONT_HEIGHT*1.5);
    for (UI_Num_Pad_Button button:buttons) {
      text(button.text, button.x, button.y, button.w, button.h);
    }
  }

  void set_button_text(UI_Num_Pad_button_enum button_enum, String text) {
    for (UI_Num_Pad_Button button:buttons) {
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
    for (UI_Num_Pad_Button button:buttons) {
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
    for (UI_Num_Pad_Button button:buttons) {
      if (button.mouse_over) {
        //println("button "+button.text+" pressed.");
        button.pressed = true;

        switch(button.button_enum) {
          case ENTER:
            input_string = new String(input_chars);
            //println("input_chars=\""+input_string+"\"");
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
            input_chars[input_index] = '_';
            set_button_text(UI_Num_Pad_button_enum.OUTPUT, input_text);
            break;
          case CLEAR:
            input_index = 0;
            input_text = "_ _ _ _";
            input_chars[0] = input_chars[1] = input_chars[2] = input_chars[3] = '_';
            set_button_text(UI_Num_Pad_button_enum.OUTPUT, input_text);
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
            set_button_text(UI_Num_Pad_button_enum.OUTPUT, input_text);
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
    for (UI_Num_Pad_Button button:buttons) {
      button.pressed = false;
    }
  }

}

class UI_Num_Pad_Button {
  int x, y;
  int w, h;
  String text;
  boolean clickable;
  boolean mouse_over;
  boolean pressed;
  UI_Num_Pad_button_enum button_enum;
  UI_Num_Pad_Button(UI_Num_Pad_button_enum button_enum, String text, int x, int y, int w, int h) {
    set(button_enum, text, x, y, w, h, true);
  }
  UI_Num_Pad_Button(UI_Num_Pad_button_enum button_enum, String text, int x, int y, int w, int h, boolean clickable) {
    set(button_enum, text, x, y, w, h, clickable);
  }

  private void set(UI_Num_Pad_button_enum button_enum, String text, int x, int y, int w, int h, boolean clickable) {
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
