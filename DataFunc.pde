//final static boolean PRINT_DATAFUNC_LOAD_DBG = true; 
final static boolean PRINT_DATAFUNC_LOAD_DBG = false;
//final static boolean PRINT_DATAFUNC_LOAD_ERR = true; 
final static boolean PRINT_DATAFUNC_LOAD_ERR = false;

//final static boolean PRINT_DATAFUNC_PARSE_DBG = true; 
final static boolean PRINT_DATAFUNC_PARSE_DBG = false;
//final static boolean PRINT_DATAFUNC_PARSE_ERR = true; 
final static boolean PRINT_DATAFUNC_PARSE_ERR = false;

//final static boolean PRINT_DATAFUNC_DRAW_DBG = true; 
final static boolean PRINT_DATAFUNC_DRAW_DBG = false;

static boolean DATA_draw_params_enable = true;

static color C_DATA_ERR_TEXT = #000000; // Black
static color C_DATA_LINE = #0000FF; // Blue
static color C_DATA_POINT = #FF0000; // Red
static color C_DATA_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
static color C_DATA_RECT_STROKE = #000000; // Black
static color C_DATA_RECT_TEXT = #404040; // Black + 0x40

final static int DATA_INTERFACE_FILE = 0;
final static int DATA_INTERFACE_UART = 1;
final static int DATA_INTERFACE_UDP = 2;
final static int DATA_INTERFACE_SN = 3;

int DATA_interface = DATA_INTERFACE_FILE;

final int DATA_MAX_POINTS = 1000;
final int DATA_POINT_SIZE = 3;

final int DATA_MAX_PULSE_WIDTH = 12000;
final int DATA_MIN_PULSE_WIDTH = 4096;

Data PS_Data;

// Define data_buf array to load binary data_buf
byte[] data_buf; 

// Define old time stamp to check time stamp changed for detecting data_buf changed or not
long old_time_stamp = -1;

void data_setup() {
  // Append interface name to window title
  if(DATA_interface == DATA_INTERFACE_FILE) 
    Title += "File";
  else if(DATA_interface == DATA_INTERFACE_UART)
    Title += "UART";
  else if(DATA_interface == DATA_INTERFACE_UDP)
    Title += "UDP";
  else /*if(DATA_interface == DATA_INTERFACE_SN)*/
    Title += "SN";

  interface_file_reset();
  interface_UART_reset();
  interface_UDP_reset();
  interface_SN_reset();
  if(DATA_interface == DATA_INTERFACE_FILE) {
    interface_file_setup();
  }
  else if(DATA_interface == DATA_INTERFACE_UART) {
    interface_UART_setup();
  }
  else if(DATA_interface == DATA_INTERFACE_UDP) {
    interface_UDP_setup();
  }
  else /*if(DATA_interface == DATA_INTERFACE_SN)*/ {
    interface_SN_setup();
  }

  PS_Data = new Data();
}

// A Data class
class Data {
  String func;
  int len;
  int n_params;
  int i_scan = 0;
  int time_stamp = 0;
  float scan_angle_start = 0;
  float scan_angle_size = 0;
  int n_echos = 0;
  int i_encoder = 0;
  float temperature = 0;
  int status = 0;
  int content = 0;
  int n_points = 0;
  int[] distances = new int[DATA_MAX_POINTS];
  int[] pulse_widths = new int[DATA_MAX_POINTS];
  int crc;
  String parse_err_str = null;
  int parse_err_cnt = 0;
  int load_take_time;
  String load_src_ip = null;
  int load_src_port = -1;

  // Create the Data
  Data()
  {
  }

  // Load data_buf
  boolean load()
  {
    String interface_err_str;
    if(DATA_interface == DATA_INTERFACE_FILE) {
      if(interface_file_load() != true) {
        interface_err_str = interface_file_get_error();
        if(interface_err_str != null) {
          draw_error(interface_err_str);
          if (PRINT_DATAFUNC_LOAD_ERR) println("interface_file_load() error!:" + interface_err_str);
        }
        else if(parse_err_str != null) {
          draw_error(parse_err_str);
          if (PRINT_DATAFUNC_LOAD_ERR) println("parse() error!:" + parse_err_str);
        }
        return false;
      }
      // No mean in file interface.
      load_take_time = -1;
      load_src_ip = null;
      load_src_port = -1;
      if (PRINT_DATAFUNC_LOAD_DBG) println("interface_file_load() ok!");
      return true;
    }
    else if(DATA_interface == DATA_INTERFACE_UART) {
      if(interface_UART_load() != true) {
        interface_err_str = interface_UART_get_error();
        if(interface_err_str != null) {
          draw_error(interface_err_str);
          if (PRINT_DATAFUNC_LOAD_ERR) println("interface_UART_load() error!:" + interface_err_str);
        }
        else if(parse_err_str != null) {
          draw_error(parse_err_str);
          if (PRINT_DATAFUNC_LOAD_ERR) println("parse() error!:" + parse_err_str);
        }
        return false;
      }
      load_take_time = interface_UART_get_take_time();
      load_src_ip = null;
      load_src_port = -1;
      if (PRINT_DATAFUNC_LOAD_DBG) println("interface_UART_load() ok!");
      return true;
    }
    else if(DATA_interface == DATA_INTERFACE_UDP) {
      if(interface_UDP_load() != true) {
        interface_err_str = interface_UDP_get_error();
        if(interface_err_str != null) {
          draw_error(interface_err_str);
          if (PRINT_DATAFUNC_LOAD_ERR) println("interface_UDP_load() error!:" + interface_err_str);
        }
        else if(parse_err_str != null) {
          draw_error(parse_err_str);
          if (PRINT_DATAFUNC_LOAD_ERR) println("parse() error!:" + parse_err_str);
        }
        return false;
      }
      load_take_time = interface_UDP_get_take_time();
      load_src_ip = interface_UDP_get_src_ip();
      load_src_port = interface_UDP_get_src_port();
      if (PRINT_DATAFUNC_LOAD_DBG) println("interface_UDP_load() ok!");
      return true;
    }
    else /*if(DATA_interface == DATA_INTERFACE_SN)*/ {
      if(interface_SN_load() != true) {
        interface_err_str = interface_SN_get_error();
        if(interface_err_str != null) {
          draw_error(interface_err_str);
          if (PRINT_DATAFUNC_LOAD_ERR) println("interface_SN_load() error!:" + interface_err_str);
        }
        else if(parse_err_str != null) {
          draw_error(parse_err_str);
          if (PRINT_DATAFUNC_LOAD_ERR) println("parse() error!:" + parse_err_str);
        }
        return false;
      }
      load_take_time = interface_SN_get_take_time();
      load_src_ip = interface_SN_get_src_ip();
      load_src_port = interface_SN_get_src_port();
      if (PRINT_DATAFUNC_LOAD_DBG) println("interface_SN_load() ok!");
      return true;
    }
  }

  // Parsing data_buf
  boolean parse()
  {
    int i = 0; // index for navigating data_buf.
    int crc_c; // calculated CRC
    int t_n_points; // temp n_points

    // Get function code.
    func = get_str_bytes(data_buf, i, 4);
    if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",func=" + func);
    // Check function code is "GSCN".
    if (func.equals("GSCN") != true) {
      parse_err_str = "Error: Function code is invalid! " + func;
      draw_error(parse_err_str);
      if (PRINT_DATAFUNC_PARSE_ERR) println(parse_err_str);
      parse_err_cnt ++;
      return false;
    }
    i = i + 4;

    // Get data_buf length.
    // : size of the following data_buf record, without the CRC checksum
    len = get_int32_bytes(data_buf, i);
    if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",length=" + len);
    // Check data_buf record length with binary data_buf length
    if (data_buf.length < (len + 12)) {
      parse_err_str = "Error: Data buf length is invalid!:" + data_buf.length + "," + len;
      draw_error(parse_err_str);
      if (PRINT_DATAFUNC_PARSE_ERR) println(parse_err_str);
      parse_err_cnt ++;
      return false;
    }
    i = i + 4;

    // Get CRC and Calculate CRC
    crc = get_int32_bytes(data_buf, 4 + 4 + len);
    if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + (4 + 4 + len) + ",crc=" + crc);
    crc_c = get_crc32(data_buf, 0, 4 + 4 + len);
    // Check CRC ok?
    if(crc != crc_c) {
      parse_err_str = "Error: Data buf crc error!:" + crc + "," + crc_c;
      draw_error(parse_err_str);
      if (PRINT_DATAFUNC_PARSE_ERR) println(parse_err_str);
      parse_err_cnt ++;
      return false;
    }

    // Get number of parameters.
    // : the number of following parameters. Becomes 0 if no scan is available.
    n_params = get_int32_bytes(data_buf, i);
    if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",number of parameters=" + n_params);
    if (n_params == 0) {
      parse_err_str = "Error: No scan data is available! n_params = 0";
      draw_error(parse_err_str);
      if (PRINT_DATAFUNC_PARSE_ERR) println(parse_err_str);
      parse_err_cnt ++;
      return false;
    }
    i = i + 4;

    // Get Number of points
    // : the number of measurement points in the scan.
    t_n_points = get_int32_bytes(data_buf, 4 + 4 + 4 + n_params * 4);
    if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + (4 + 4 + 4 + n_params * 4) + ",number of points=" + t_n_points);
    // Check Number of points
    if (t_n_points > DATA_MAX_POINTS || t_n_points <= 0) {
      parse_err_str = "Error: Number of points invalid! n_points is " + t_n_points;
      draw_error(parse_err_str);
      if (PRINT_DATAFUNC_PARSE_ERR) println(parse_err_str);
      parse_err_cnt ++;
      return false;
    }
    n_points = t_n_points;

    if (n_params >= 1) {
      // Get scan number(index).
      // : the number of the scan (starting with 1), should be the same as in the command request.
      i_scan = get_int32_bytes(data_buf, i);
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",scan number=" + i_scan);
      i = i + 4;
    }

    if (n_params >= 2) {
      // Get time stamp.
      // : time stamp of the first measured point in the scan, given in milliseconds since the last SCAN command.
      time_stamp = get_int32_bytes(data_buf, i);
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",time stamp=" + time_stamp);
      i = i + 4;
/*
      // Check time_stamp is changed
      if (old_time_stamp == time_stamp) {
        parse_err_str = "Scan data_buf is not changed!:" + time_stamp;
        draw_error(parse_err_str);
        if (PRINT_DATAFUNC_PARSE_DBG) println("Scan data_buf is not changed!:" + time_stamp);
        //parse_err_cnt ++;
        //return false;
      }
      old_time_stamp = time_stamp;
*/
    }

    if (n_params >= 3) {
      // Get Scan start direction.
      // : direction to the first measured point, given in the user angle system (typical unit is 0,001 deg)
      scan_angle_start = get_int32_bytes(data_buf, i) / 1000.0;
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",scan start angle=" + scan_angle_start);
      i = i + 4;
    }
  
    if (n_params >= 4) {
      // Get Scan angle
      // : the scan angle in the user angle system. Typically 90.000.
      scan_angle_size = get_int32_bytes(data_buf, i) / 1000.0;
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",scan range angle=" + scan_angle_size);
      i = i + 4;
    }
  
    if (n_params >= 5) {
      // Get Number of echoes per point
      // : the number of echoes measured for each direction.
      n_echos = get_int32_bytes(data_buf, i);
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",number of echos=" + n_echos);
      i = i + 4;
    }
  
    if (n_params >= 6) {
      // Get Incremental count
      // : a direction provided by an external incremental encoder.
      i_encoder = get_int32_bytes(data_buf, i);
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",encoder value=" + i_encoder);
      i = i + 4;
    }
  
    if (n_params >= 7) {
      // Get system temperature
      // : the temperature as measured inside of the scanner.
      // : This information can be used to control an optional air condition.
      temperature = get_int32_bytes(data_buf, i) / 10f;
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",system temperature=" + temperature);
      i = i + 4;
    }
  
    if (n_params >= 8) {
      // Get System status
      // : contains a bit field with about the status of peripheral devices.
      status = get_int32_bytes(data_buf, i);
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",system status=" + status);
      i = i + 4;
    }
  
    if (n_params >= 9) {
      // Get Data content
      // : This parameter is built by the size of a single measurement record.
      // : It defines the content of the data_buf section:
      //    o 4 Bytes: distances in 1/10 mm only.
      //    o 8 Bytes: distances in 1/10 mm and pulse widths in picoseconds
      //    o Any other value than 4 be read as "8 Bytes".
      content = get_int32_bytes(data_buf, i);
      if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",data content=" + content);
      i = i + 4;
    }
  
    // Check number of parameters is larger than 9 such as unknown parameters.
    if (n_params > 9) {
      // Skip index for remained unknown parameters.
      i = i + 4 * (n_params - 9);
    }
  
// Skip the get Number of points. this already done above.
/*
    // Get Number of points
    // : the number of measurement points in the scan.
    n_points = get_int32_bytes(data_buf, i);
    if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",number of points=" + n_points);
    if (n_points > DATA_MAX_POINTS || n_points <= 0) {
      parse_err_str = "Error: Number of points invalid! n_points is " + n_points;
      draw_error(parse_err_str);
      if (PRINT_DATAFUNC_PARSE_ERR) println(parse_err_str);
      parse_err_cnt ++;
      return false;
    }
*/
    i = i + 4;

    for (int j = 0; j < n_points; j++) {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distances[j] = get_int32_bytes(data_buf, i);
      i = i + 4;

      // Check pulse width exist
      if (content != 4) {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_widths[j] = get_int32_bytes(data_buf, i);
        //println("index=" + i + ",point=", j, ",pulse width=" + pulse_width);
        i = i + 4;
      }
    }

// Skip the get CRC. this already done above.
/*
    // Get CRC
    // : Checksum
    crc = get_int32_bytes(data_buf, i);
    if (PRINT_DATAFUNC_PARSE_DBG) println("index=" + i + ",crc=" + crc);
    i = i + 4;
*/  

    // Clear parse error string and count
    parse_err_str = null;
    parse_err_cnt = 0;

    return true;
  } // End of parse()
  
  // Draw params of parsed data_buf
  void draw_params()
  {
    if(!DATA_draw_params_enable) return;

    String[] strings = new String[13];
    int cnt;

    // Set to blank string at the end of array to avoid adding string null check code below.
    strings[strings.length-1] = "";
    strings[strings.length-2] = "";
    strings[strings.length-3] = "";
    cnt = 0;
    if(load_src_ip != null)
      strings[cnt++] = "Source IP:" + load_src_ip;
    if(load_src_port != -1)
      strings[cnt++] = "Source port:" + load_src_port;
    if(load_take_time != -1)
      strings[cnt++] = "Reponse time:" + load_take_time + "ms";
    strings[cnt++] = "Scan number:" + i_scan;
    strings[cnt++] = "Time stamp:" + time_stamp;
    strings[cnt++] = "Scan start direction:" + scan_angle_start + "°";
    strings[cnt++] = "Scan angle size:" + scan_angle_size + "°";
    strings[cnt++] = "Number of echoes:" + n_echos;
    strings[cnt++] = "Encoder count:" + i_encoder;
    strings[cnt++] = "System temp.:" + temperature + "°C";
    strings[cnt++] = "System status:" + status;
    strings[cnt++] = "Data content:" + content;
    strings[cnt++] = "Number of points:" + n_points;

    // Get max string width
    int witdh_max = 0;
    for( String string:strings)
    {
      //if(string != null)
        witdh_max = max(witdh_max, int(textWidth(string)));    
    }

    // Draw rect
    fill(C_DATA_RECT_FILL);
    stroke(C_DATA_RECT_STROKE);
    rect(FONT_HEIGHT * 3, TEXT_MARGIN*2 + FONT_HEIGHT * 1, witdh_max + TEXT_MARGIN*2, FONT_HEIGHT * cnt + TEXT_MARGIN*2, 5, 5, 5, 5);

    // Sets the color used to draw lines and borders around shapes.
    fill(C_DATA_RECT_TEXT);
    stroke(C_DATA_RECT_TEXT);
    cnt = 0;
    final int str_x = FONT_HEIGHT * 3 + TEXT_MARGIN;
    final int offset_y = TEXT_MARGIN*2 + FONT_HEIGHT * 1 + TEXT_MARGIN - 1;
    for( String string:strings)
    {
      //if(string != null)
      {
        text(string, str_x, offset_y + FONT_HEIGHT * (1 + cnt));
        cnt ++;
      }
    }
  } // End of draw_params()
  
  // Draw points of parsed data_buf
  void draw_points()
  {
    int distance;
    int pulse_width_curr = -1, pulse_width_prev = -1;
    int x_curr, y_curr;
    int point_size_curr = DATA_POINT_SIZE; // Set size of point rect
    int point_size_prev = DATA_POINT_SIZE; // Set size of point rect
    float cx, cy;
    float angle, radians;
    int x_prev = MIN_INT, y_prev = MIN_INT;
    color point_color_curr = C_DATA_POINT, point_color_prev = C_DATA_POINT;
    color line_color = C_DATA_LINE;
    final int mouse_over_range =
      (ZOOM_FACTOR < 50)
      ?
      (DATA_POINT_SIZE + (50 - ZOOM_FACTOR) / 10)
      :
      DATA_POINT_SIZE; // Range for mouse over point rect. Adjust mouse over range by ZOOM_FACTOR.
    final int offset_x =
      (ROTATE_FACTOR == 315)
      ?
      (TEXT_MARGIN + FONT_HEIGHT / 2)
      :
      (
        (ROTATE_FACTOR == 135)
        ?
        (SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT / 2))
        :
        (SCREEN_width / 2)
      );
    final int offset_y =
      (ROTATE_FACTOR == 45)
      ?
      (TEXT_MARGIN + FONT_HEIGHT / 2)
      :
      (
        (ROTATE_FACTOR == 225)
        ?
        (SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT / 2))
        :
        (SCREEN_height / 2)
      );
    final int point_color_H_max_const =
      (
        DATA_MAX_PULSE_WIDTH
        +
        int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0)
        -
        DATA_MAX_PULSE_WIDTH
      )
      %
      (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1);
    final int point_color_H_min_const =
      (
        DATA_MAX_PULSE_WIDTH
        +
        int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0)
        -
        DATA_MIN_PULSE_WIDTH
      )
      %
      (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1);
    final float point_line_color_H_offset_const = float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0;
    final int point_line_color_H_modular_const = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1;
    final int point_line_color_HSB_max_const = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH;
    final int mouse_over_x_min = mouseX - mouse_over_range;
    final int mouse_over_x_max = mouseX + mouse_over_range;
    final int mouse_over_y_min = mouseY - mouse_over_range;
    final int mouse_over_y_max = mouseY + mouse_over_range;

    // Check pulse width exist than color mode set to HSB.
    if (content != 4)
    {
      colorMode(HSB, point_line_color_HSB_max_const);
    }

    for (int j = 0; j < n_points; j++)
    {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distance = distances[j];
      // Check No echo
      if (distance == 0x80000000)
      {
        //if (PRINT_DATAFUNC_DRAW_DBG) println("point=", j, ",distance=" + "No echo");
        x_prev = MIN_INT;
        y_prev = MIN_INT;
        pulse_width_prev = -1;
      }
      // Check Noisy
      else if (distance == 0x7fffffff)
      {
        //if (PRINT_DATAFUNC_DRAW_DBG) println("point=", j, ",distance=" + "Noise");
        x_prev = MIN_INT;
        y_prev = MIN_INT;
        pulse_width_prev = -1;
      }
      else
      {
        //if (PRINT_DATAFUNC_DRAW_DBG) println("point=", j, ",distance=" + distance);
        angle = scan_angle_start - 45.0 + float(j) * scan_angle_size / float(n_points);
        radians = radians(angle);
        if (ROTATE_FACTOR == 315)
        {
          cx = float(distance) * sin(radians);
          cy = float(distance) * cos(radians);
          x_curr = int(cx / ZOOM_FACTOR);
          y_curr = int(cy / ZOOM_FACTOR);
          //if (PRINT_DATAFUNC_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x_curr=" + x_curr + ",y_curr=", y_curr);
          x_curr += offset_x;
          if (MIRROR_ENABLE)
            y_curr += offset_y;
          else
            y_curr = offset_y - y_curr;
        }
        else if (ROTATE_FACTOR == 45)
        {
          cx = float(distance) * cos(radians);
          cy = float(distance) * sin(radians);
          x_curr = int(cx / ZOOM_FACTOR);
          y_curr = int(cy / ZOOM_FACTOR);
          //if (PRINT_DATAFUNC_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x_curr=" + x_curr + ",y_curr=", y_curr);
          if (MIRROR_ENABLE)
            x_curr = offset_x - x_curr;
          else
            x_curr += offset_x;
          y_curr += offset_y;
        }
        else if (ROTATE_FACTOR == 135)
        {
          cx = float(distance) * sin(radians);
          cy = float(distance) * cos(radians);
          x_curr = int(cx / ZOOM_FACTOR);
          y_curr = int(cy / ZOOM_FACTOR);
          //if (PRINT_DATAFUNC_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x_curr=" + x_curr + ",y_curr=", y_curr);
          x_curr = offset_x - x_curr;
          if (MIRROR_ENABLE)
            y_curr = offset_y - y_curr;
          else
            y_curr += offset_y;
        }
        else /*if (ROTATE_FACTOR == 225)*/
        {
          cx = float(distance) * cos(radians);
          cy = float(distance) * sin(radians);
          x_curr = int(cx / ZOOM_FACTOR);
          y_curr = int(cy / ZOOM_FACTOR);
          //if (PRINT_DATAFUNC_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start + float(j) * scan_angle_size / float(n_points)) + ",x_curr=" + x_curr + ",y_curr=", y_curr);
          if (MIRROR_ENABLE)
            x_curr += offset_x;
          else
            x_curr = offset_x - x_curr;
          y_curr = offset_y - y_curr;
        }

        x_curr += GRID_OFFSET_X;
        y_curr += GRID_OFFSET_Y;

        // Check pulse width exist
        if (content != 4)
        {
          pulse_width_curr = pulse_widths[j];
          //print("[" + j + "]=" + pulse_widths[j] + " ");
          if(pulse_width_curr > DATA_MAX_PULSE_WIDTH)
          {
            point_color_curr =
              color(
                point_color_H_max_const,
                point_line_color_HSB_max_const,
                point_line_color_HSB_max_const);
          }
          else if(pulse_width_curr < DATA_MIN_PULSE_WIDTH)
          {
            point_color_curr =
              color(
                point_color_H_min_const,
                point_line_color_HSB_max_const,
                point_line_color_HSB_max_const);
          }
          else
          {
            point_color_curr =
              color(
                (DATA_MAX_PULSE_WIDTH + int(point_line_color_H_offset_const - pulse_width_curr)) % point_line_color_H_modular_const,
                point_line_color_HSB_max_const,
                point_line_color_HSB_max_const);
          }
          if(pulse_width_prev != -1)
          {
            line_color =
              color(
                (DATA_MAX_PULSE_WIDTH + int(point_line_color_H_offset_const - (float(pulse_width_curr + pulse_width_prev) / 2.0))) % point_line_color_H_modular_const,
                point_line_color_HSB_max_const,
                point_line_color_HSB_max_const);
          }
        }
        else
        {
          point_color_curr = C_DATA_POINT;
          point_color_prev = C_DATA_POINT;
          line_color = C_DATA_LINE;
        }

        // Check mouse pointer over point rect.
        if( BUBBLEINFO_AVAILABLE != true
            &&
            (x_curr > mouse_over_x_min && x_curr < mouse_over_x_max)
            &&
            (y_curr > mouse_over_y_min && y_curr < mouse_over_y_max)
          )
        {
          //println("point=" + j + ",distance=" + (float(distance)/10000.0) + "m(" + (cx/10000.0) + "," + (cy/10000.0) + ")" + ",pulse width=" + pulse_width_curr);
          BUBBLEINFO_AVAILABLE = true;
          BUBBLEINFO_POINT = j;
          BUBBLEINFO_DISTANCE = float(distance/10)/1000.0;
          BUBBLEINFO_COR_X = (int(cx/10.0)/1000.0);
          BUBBLEINFO_COR_Y = (int(cy/10.0)/1000.0);
          BUBBLEINFO_BOX_X = x_curr;
          BUBBLEINFO_BOX_Y = y_curr;
          BUBBLEINFO_ANGLE = float(int(angle*100.0))/100.0;
          BUBBLEINFO_PULSE_WIDTH = pulse_width_curr;
          point_size_curr = BUBBLEINFO_POINT_WH;
        }
        else
        {
          // Reset width and height point rect
          point_size_curr = DATA_POINT_SIZE;
        }

        if (x_prev != MIN_INT && y_prev != MIN_INT)
        {
          //print(j + ":" + pulse_width_prev + "," + pulse_width_curr + " ");
          fill(line_color);
          stroke(line_color);
          line(x_prev, y_prev, x_curr, y_curr);
          fill(point_color_prev);
          stroke(point_color_prev);
          //point(x_prev + GRID_OFFSET_X, y_prev + GRID_OFFSET_Y);
          rect(x_prev - point_size_prev / 2, y_prev - point_size_prev / 2, point_size_prev, point_size_prev );
        }
        fill(point_color_curr);
        stroke(point_color_curr);
        //point(x_curr + GRID_OFFSET_X, y_curr + GRID_OFFSET_Y);
        rect(x_curr - point_size_curr / 2, y_curr - point_size_curr / 2, point_size_curr, point_size_curr );

        // Save data for drawing line between previous and current points. 
        x_prev = x_curr;
        y_prev = y_curr;
        point_color_prev = point_color_curr;
        point_size_prev = point_size_curr;
        pulse_width_prev = pulse_width_curr;
      }
/*
      // Check pulse width exist
      if (content != 4)
      {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_width_curr = pulse_widths[j];
        if (PRINT_DATAFUNC_DRAW_DBG) println("point=", j, ",pulse width=" + pulse_width_curr);
      }
*/
    } // End of for (int j = 0; j < n_points; j++)

    // Check pulse width exist than color mode back to RGB.
    if (content != 4)
    {
      colorMode(RGB, 255);
    }

  } // End of draw_points()
  
  void draw_error(String message)
  {
    // Sets the color used to draw lines and borders around shapes.
    fill(C_DATA_ERR_TEXT);
    stroke(C_DATA_ERR_TEXT);
    textSize(FONT_HEIGHT*3);
    text(message, SCREEN_width / 2 - int(textWidth(message) / 2.0), SCREEN_height / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
  }
}
