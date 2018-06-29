import processing.serial.*;

//final static boolean PRINT_RELAY_MODULE_ALL_DBG = true; 
final static boolean PRINT_RELAY_MODULE_ALL_DBG = false; 
final static boolean PRINT_RELAY_MODULE_ALL_ERR = true; 
//final static boolean PRINT_RELAY_MODULE_ALL_ERR = false; 

//final static boolean PRINT_RELAY_MODULE_SETUP_DBG = true; 
final static boolean PRINT_RELAY_MODULE_SETUP_DBG = false; 
//final static boolean PRINT_RELAY_MODULE_SETUP_ERR = true; 
final static boolean PRINT_RELAY_MODULE_SETUP_ERR = false; 

//final static boolean PRINT_RELAY_MODULE_RESET_DBG = true; 
final static boolean PRINT_RELAY_MODULE_RESET_DBG = false; 
//final static boolean PRINT_RELAY_MODULE_RESET_ERR = true; 
final static boolean PRINT_RELAY_MODULE_RESET_ERR = false; 

//final static boolean PRINT_RELAY_MODULE_SET_RELAY_DBG = true; 
final static boolean PRINT_RELAY_MODULE_SET_RELAY_DBG = false; 
//final static boolean PRINT_RELAY_MODULE_SET_RELAY_ERR = true; 
final static boolean PRINT_RELAY_MODULE_SET_RELAY_ERR = false; 

//final static boolean PRINT_RELAY_MODULE_WRITE_DBG = true; 
final static boolean PRINT_RELAY_MODULE_WRITE_DBG = false; 
//final static boolean PRINT_RELAY_MODULE_WRITE_ERR = true; 
final static boolean PRINT_RELAY_MODULE_WRITE_ERR = false; 

//final static boolean PRINT_RELAY_MODULE_READ_DBG = true; 
final static boolean PRINT_RELAY_MODULE_READ_DBG = false; 
//final static boolean PRINT_RELAY_MODULE_READ_ERR = true; 
final static boolean PRINT_RELAY_MODULE_READ_ERR = false; 

//final static boolean PRINT_RELAY_MODULE_LOAD_DBG = true; 
final static boolean PRINT_RELAY_MODULE_LOAD_DBG = false; 
//final static boolean PRINT_RELAY_MODULE_LOAD_ERR = true; 
final static boolean PRINT_RELAY_MODULE_LOAD_ERR = false; 

static color C_RELAY_MODULE_INDICATOR_OFF_FILL = 0xFF000000; // Black
static color C_RELAY_MODULE_INDICATOR_OFF_STROKE = 0xFF404040; // Dark gray

boolean Relay_Module_UART_enabled = true;

Serial Relay_Module_UART_handle = null;  // The handle of UART(serial port)

String Relay_Module_UART_port_name = "NA"; // String: name of the port (COM1 is the default)
int Relay_Module_UART_baud_rate = 115200; // int: 9600 is the default
char Relay_Module_UART_parity = 'N'; // char: 'N' for none, 'E' for even, 'O' for odd, 'M' for mark, 'S' for space ('N' is the default)
int Relay_Module_UART_data_bits = 8; // int: 8 is the default
float Relay_Module_UART_stop_bits = 1.0; // float: 1.0, 1.5, or 2.0 (1.0 is the default)

final static int RELAY_MODULE_NUMBER_OF_RELAYS = 4;

final static int RELAY_MODULE_CHECK_INTERVAL_IDLE = 1000;

static boolean[] Relay_Module_output_val = new boolean[RELAY_MODULE_NUMBER_OF_RELAYS];
static int Relay_Module_output_interval;
static int Relay_Module_output_timer;
LinkedList<UI_Relay_Indicator> Relay_Module_indicators = new LinkedList();

void Relay_Module_setup()
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_SETUP_DBG) println("Relay_Module_setup():Enter");

  boolean found = false;

  //printArray(Serial.list());

  Relay_Module_output_interval = 0; // to set at initial time.
  Relay_Module_output_timer = millis();
  for (int relay_index = 0; relay_index < RELAY_MODULE_NUMBER_OF_RELAYS; relay_index ++)
  {
    int x, y, w, h, r;
    int stroke_w;
    color on_fill_c;
    color off_fill_c;
    color on_stroke_c;
    color off_stroke_c;
    String on_text = "Relay ON";
    String off_text = "Relay OFF";
    int text_width_max;

    Relay_Module_output_val[relay_index] = false;

    textSize(FONT_HEIGHT * 1.5);
    text_width_max = int(textWidth(on_text));
    text_width_max = int(max(text_width_max, textWidth(off_text)));

    for (int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
    {
      int region_index;
      for (region_index = 0; region_index < Regions_handle.regions_array[instance].size(); region_index ++)
      {
        Region_Data region_data = Regions_handle.regions_array[instance].get(region_index);
        if (region_data.relay_index != relay_index) continue;
        w = int(
              text_width_max
              +
              TEXT_MARGIN * 1.5 * 2);
        h = int(FONT_HEIGHT * 1.5 + TEXT_MARGIN * 1.5 * 2);
        x = int(
              region_data.rect_scr_x
              +
              region_data.rect_scr_width / 2
              -
              ( text_width_max
                +
                TEXT_MARGIN * 1.5 * 2) / 2);
        y = int(TEXT_MARGIN * 1.5 * 2);
        r = int(TEXT_MARGIN * 1.5);
        stroke_w = region_data.marker_stroke_weight;
        on_fill_c = region_data.marker_fill_color;
        off_fill_c = C_RELAY_MODULE_INDICATOR_OFF_FILL;
        on_stroke_c = region_data.marker_stroke_color;
        off_stroke_c = C_RELAY_MODULE_INDICATOR_OFF_STROKE;
        // Check region is overlapped with other regions.
        for (int region_o_index = 0; region_o_index < Regions_handle.regions_array[instance].size(); region_o_index ++)
        {
          Region_Data region_o_data = Regions_handle.regions_array[instance].get(region_o_index);
          if (region_o_data.relay_index == relay_index
              ||
              region_o_data.relay_index < 0)
          {
            continue;
          }
          if (x >= region_o_data.rect_scr_x
              &&
              x + w <= region_o_data.rect_scr_x + region_o_data.rect_scr_width)
          {
            continue;
          }
          if (x >= region_o_data.rect_scr_x
              &&
              x <= region_o_data.rect_scr_x + region_o_data.rect_scr_width)
          {
            x = int(
                  region_o_data.rect_scr_x + region_o_data.rect_scr_width
                  +
                  TEXT_MARGIN * 1.5 * 2);
          }
          if (x + w >= region_o_data.rect_scr_x
              &&
              x + w <= region_o_data.rect_scr_x + region_o_data.rect_scr_width)
          {
            x = int(
                  x
                  -
                  (x + w - region_o_data.rect_scr_x)
                  - TEXT_MARGIN * 1.5 * 2);
          }
        }
        Relay_Module_indicators.add(
          new UI_Relay_Indicator(
            x, y, w, h, r,
            stroke_w,
            on_fill_c, off_fill_c,
            on_stroke_c, off_stroke_c,
            on_text, off_text));
        break;
      }
      if (region_index != Regions_handle.regions_array[instance].size())
        break;
    }
  }

  if (Relay_Module_UART_port_name.equals("NA"))
  {
    Relay_Module_UART_enabled = false;
    return;
  }

  // Check Relay_Module_UART_port_name with the available serial ports
  for (String port:Serial.list())
  {
    if (port.equals(Relay_Module_UART_port_name))
    {
      found = true;
      break;
    }
  }
  if (!found)
  {
    if(PRINT_RELAY_MODULE_ALL_ERR || PRINT_RELAY_MODULE_SETUP_ERR) println("Relay_Module_setup():Can not find com port error! " + Relay_Module_UART_port_name);
    return;
  }

  try
  {
    // Open the port you are using at the rate you want:
    Relay_Module_UART_handle = new Serial(this, Relay_Module_UART_port_name, Relay_Module_UART_baud_rate, Relay_Module_UART_parity, Relay_Module_UART_data_bits, Relay_Module_UART_stop_bits);
    Relay_Module_UART_handle.clear();
    Relay_Module_UART_handle.buffer(1);
  }
  catch (Exception e)
  {
    Relay_Module_UART_handle = null;
  }
}

void Relay_Module_reset()
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_RESET_DBG) println("Relay_Module_reset():Enter");

  // Check UART port config changed
  if (Relay_Module_UART_handle != null)
  {
    Relay_Module_UART_handle.stop();
    Relay_Module_UART_handle = null;
  }
}

void Relay_Module_output()
{
  boolean updated = false;

  for (int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    boolean output;
    for (int region_index = 0; region_index < Regions_handle.get_regions_size_for_index(instance); region_index ++)
    {
      int relay_index;
      output = Regions_handle.get_region_has_object(instance, region_index);
      relay_index = Regions_handle.get_region_relay_index(instance, region_index);
      //println("relay_index="+relay_index);
      if (relay_index < 0 || relay_index >= RELAY_MODULE_NUMBER_OF_RELAYS)
      {
        continue;
      }
      if (output != Relay_Module_output_val[relay_index])
      {
        Relay_Module_output_val[relay_index] = output;
        updated = true;
      }
    }
  }

  Relay_Module_draw_indicator();

  if (!updated
      &&
      get_millis_diff(Relay_Module_output_timer) < Relay_Module_output_interval)
  {
    return;
  }
  Relay_Module_output_timer = millis();
  Relay_Module_output_interval = RELAY_MODULE_CHECK_INTERVAL_IDLE;

  Relay_Module_set_relay();
}

private void Relay_Module_set_relay()
{
  if (!Relay_Module_UART_enabled) return;

  byte[] buf = new byte[4 + 2];
  buf[0] = 'R';
  int cnt = 0;
  for (int relay_index = 0; relay_index < RELAY_MODULE_NUMBER_OF_RELAYS; relay_index ++)
  {
    if (Relay_Module_output_val[relay_index])
    {
      buf[relay_index + 1] = '1';
      cnt ++;
    }
    else
    {
      buf[relay_index + 1] = '0';
    }
  }
  buf[5] = byte('0' + cnt);
  Relay_Module_UART_write(buf);
}

private void Relay_Module_draw_indicator()
{
  for (int relay_index = 0; relay_index < RELAY_MODULE_NUMBER_OF_RELAYS; relay_index ++)
  {
    UI_Relay_Indicator indicator = Relay_Module_indicators.get(relay_index);
    indicator.draw(Relay_Module_output_val[relay_index]);
  }
}

void Relay_Module_UART_clear()
{
  if(Relay_Module_UART_handle == null) return;
  Relay_Module_UART_handle.clear();
}

void Relay_Module_UART_write(byte[] buf)
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_WRITE_DBG) println("Relay_Module_UART_write():buf.length="+buf.length);
  if (Relay_Module_UART_handle == null)
  {
    if (PRINT_RELAY_MODULE_ALL_ERR || PRINT_RELAY_MODULE_WRITE_ERR) println("Relay_Module_UART_write():Relay_Module_UART_handle=null");
    return;
  }
  Relay_Module_UART_handle.write(buf);
}

void Relay_Module_UART_prepare_read(int buf_size)
{
}

void Relay_Module_UART_read(byte[] buf)
{
} 

class UI_Relay_Indicator {
  int x, y;
  int w, h;
  int r;
  int stroke_w;
  color on_fill_c;
  color off_fill_c;
  color on_stroke_c;
  color off_stroke_c;
  String on_text;
  String off_text;

  UI_Relay_Indicator(int x, int y, int w, int h, int r, int stroke_w, color on_fill_c, color of_fill_c, color on_stroke_c, color off_stroke_c, String on_text, String off_text) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.r = r;
    this.stroke_w = stroke_w;
    this.on_fill_c = on_fill_c;
    this.off_fill_c = off_fill_c;
    this.on_stroke_c = on_stroke_c;
    this.off_stroke_c = off_stroke_c;
    this.on_text = on_text;
    this.off_text = off_text;
    //println("UI_Relay_Indicator():constructor():"+"x="+x+",y="+y+",w="+w+",h="+h);
  }

  void draw(boolean on) {
    // Sets the color and weight used to draw lines and borders around shapes.
    if (on) {
      stroke(on_stroke_c);
      fill(on_fill_c);
    }
    else {
      stroke(off_stroke_c);
      fill(off_fill_c);
    }
    strokeWeight(stroke_w);
    rect(x, y, w, h, r, r, r, r);

    textAlign(CENTER, TOP);
    textSize(FONT_HEIGHT*1.5);
    if (on) {
      fill(on_stroke_c);
      text(on_text, x, y, w, h);
    }
    else {
      fill(off_stroke_c);
      text(off_text, x, y, w, h);
    }
  }
}
