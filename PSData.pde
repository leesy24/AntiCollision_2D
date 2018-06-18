//final static boolean PRINT_PS_DATA_ALL_DBG = true; 
final static boolean PRINT_PS_DATA_ALL_DBG = false;
//final static boolean PRINT_PS_DATA_ALL_ERR = true; 
final static boolean PRINT_PS_DATA_ALL_ERR = false;

//final static boolean PRINT_PS_DATA_SETUP_DBG = true; 
final static boolean PRINT_PS_DATA_SETUP_DBG = false;
//final static boolean PRINT_PS_DATA_SETUP_ERR = true; 
final static boolean PRINT_PS_DATA_SETUP_ERR = false;

//final static boolean PRINT_PS_DATA_LOAD_DBG = true; 
final static boolean PRINT_PS_DATA_LOAD_DBG = false;
//final static boolean PRINT_PS_DATA_LOAD_ERR = true; 
final static boolean PRINT_PS_DATA_LOAD_ERR = false;

//final static boolean PRINT_PS_DATA_PARSE_DBG = true; 
final static boolean PRINT_PS_DATA_PARSE_DBG = false;
//final static boolean PRINT_PS_DATA_PARSE_ERR = true; 
final static boolean PRINT_PS_DATA_PARSE_ERR = false;

//final static boolean PRINT_PS_DATA_DRAW_DBG = true; 
final static boolean PRINT_PS_DATA_DRAW_DBG = false;

static boolean PS_DATA_draw_params_enable = true;

final int PS_DATA_INSTANCE_MAX = 2;

static color C_PS_DATA_ERR_TEXT = #000000; // Black
static color C_PS_DATA_LINE = #0000FF; // Blue
static color C_PS_DATA_POINT = #FF0000; // Red
static int W_PS_DATA_LINE_POINT = 1;
static color C_PS_DATA_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
static color C_PS_DATA_RECT_STROKE = #000000; // Black
static int W_PS_DATA_RECT_STROKE = 1;
static color C_PS_DATA_RECT_TEXT = #404040; // Black + 0x40

final static int PS_DATA_POINTS_MAX = 1000;
final static int PS_DATA_POINT_SIZE = 3;

final static int PS_DATA_PULSE_WIDTH_MAX = 12000;
final static int PS_DATA_PULSE_WIDTH_MIN = 4096;

final static int PS_DATA_INTERFACE_FILE = 0;
final static int PS_DATA_INTERFACE_UART = 1;
final static int PS_DATA_INTERFACE_UDP = 2;
final static int PS_DATA_INTERFACE_SN = 3;

int[] PS_DATA_interface;

int UDP_local_port = 1025;
String[] UDP_remote_ip;
int[] UDP_remote_port;

PS_Data PS_Data_handle;

// Define Data buffer array to load binary Data buffer from interfaces
byte[][] PS_Data_buf; 

// Define old time stamp to check time stamp changed for detecting Data buffer changed or not
//long PS_Data_old_time_stamp = -1;

void PS_Data_settings() {
  PS_DATA_interface = new int[PS_DATA_INSTANCE_MAX];
  UDP_remote_ip = new String[PS_DATA_INSTANCE_MAX];
  UDP_remote_port = new int[PS_DATA_INSTANCE_MAX];

  for (int i = 0; i < PS_DATA_INSTANCE_MAX; i++)
  {
    PS_DATA_interface[i] = PS_DATA_INTERFACE_FILE;
    UDP_remote_ip[i] = "10.0.8.86";
    UDP_remote_port[i] = 1024;
  }
  
}

void PS_Data_setup() {
  if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_SETUP_DBG) println("PS_Data_setup():");
  // Append interface name to window title

  PS_Data_buf = new byte[PS_DATA_INSTANCE_MAX][];
  //if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_SETUP_DBG) println("PS_Data_setup():PS_Data_buf[0]="+PS_Data_buf[0]+",PS_Data_buf[1]="+PS_Data_buf[1]);
  if(PS_Data_buf == null)
  {
    if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup():PS_Data_buf allocation error!");
    return;
  }
  PS_Data_handle = new PS_Data();
  if(PS_Data_handle == null)
  {
    if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup():PS_Data_handle allocation error!");
    return;
  }

  Interfaces_File_reset();
  Interfaces_UART_reset();
  Interfaces_UDP_reset();
  Interfaces_SN_reset();

  for (int i = 0; i < PS_DATA_INSTANCE_MAX; i ++)
  {
    if(PS_DATA_interface[i] == PS_DATA_INTERFACE_FILE) 
      Title += "File";
    else if(PS_DATA_interface[i] == PS_DATA_INTERFACE_UART)
      Title += "UART";
    else if(PS_DATA_interface[i] == PS_DATA_INTERFACE_UDP)
      Title += "UDP";
    else if(PS_DATA_interface[i] == PS_DATA_INTERFACE_SN)
      Title += "SN";
    else {
      if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup():PS_DATA_interface["+i+"]="+PS_DATA_interface[i]+" error!");
    }      
  }
  
  for (int i = 0; i < PS_DATA_INSTANCE_MAX; i ++)
  {
    if(PS_DATA_interface[i] == PS_DATA_INTERFACE_FILE) {
      Interfaces_File_setup();
    }
    else if(PS_DATA_interface[i] == PS_DATA_INTERFACE_UART) {
      Interfaces_UART_setup();
    }
    else if(PS_DATA_interface[i] == PS_DATA_INTERFACE_UDP) {
      Interfaces_UDP_setup(UDP_local_port);
      Interfaces_UDP_handle.open(i, UDP_remote_ip[i], UDP_remote_port[i]);
      Interfaces_UDP_handle.set_comm_timeout(i, 1000); // timeout 1secs for UDP
    }
    else if(PS_DATA_interface[i] == PS_DATA_INTERFACE_SN) {
      Interfaces_SN_setup();
    }
    else {
      if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup():PS_DATA_interface["+i+"]="+PS_DATA_interface[i]+" error!");
    }
  }
}

// A PS_Data class
class PS_Data {
  int[] scan_number = new int[PS_DATA_INSTANCE_MAX];
  int[] time_stamp = new int[PS_DATA_INSTANCE_MAX];
  float[] scan_angle_start = new float[PS_DATA_INSTANCE_MAX];
  float[] scan_angle_size = new float[PS_DATA_INSTANCE_MAX];
  int[] number_of_echoes = new int[PS_DATA_INSTANCE_MAX];
  int[] incremental_count = new int[PS_DATA_INSTANCE_MAX];
  float[] system_temperature = new float[PS_DATA_INSTANCE_MAX];
  int[] system_status = new int[PS_DATA_INSTANCE_MAX];
  int[] data_content = new int[PS_DATA_INSTANCE_MAX];
  int[] number_of_points = new int[PS_DATA_INSTANCE_MAX];
  int[][] distances = new int[PS_DATA_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] pulse_widths = new int[PS_DATA_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  String[] parse_err_str = new String[PS_DATA_INSTANCE_MAX];
  int[] parse_err_cnt = new int[PS_DATA_POINTS_MAX];
  int[] load_take_time = new int[PS_DATA_INSTANCE_MAX];
  String[] load_remote_ip = new String[PS_DATA_INSTANCE_MAX];
  int[] load_remote_port = new int[PS_DATA_INSTANCE_MAX];

  // Create the PS_Data
  PS_Data()
  {
    if (PRINT_PS_DATA_ALL_DBG) println("PS_Data:constructor():");
    // Init. class variables.
    //println("PS_Data_buf[0]="+PS_Data_buf[0]+",PS_Data_buf[1]="+PS_Data_buf[1]);
    for (int i = 0; i < PS_DATA_INSTANCE_MAX; i++)
    {
      scan_number[i] = 0;
      time_stamp[i] = 0;
      scan_angle_start[i] = 0;
      scan_angle_size[i] = 0;
      number_of_echoes[i] = 0;
      incremental_count[i] = 0;
      system_temperature[i] = 0;
      system_status[i] = 0;
      data_content[i] = 0;
      number_of_points[i] = 0;
      parse_err_str[i] = null;
      parse_err_cnt[i] = 0;
      load_take_time[i] = 0;
      load_remote_ip[i] = null;
      load_remote_port[i] = -1;
    }
  }

  // Load PS_Data_buf
  boolean load(int instance)
  {
    String interfaces_err_str;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load("+instance+"):");
    //if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println(""PS_Data:load("+instance+"):PS_Data_buf["+instance+"]="+PS_Data_buf[instance]);

    if(PS_DATA_interface[instance] == PS_DATA_INTERFACE_FILE) {
      if(Interfaces_File_load() != true) {
        interfaces_err_str = Interfaces_File_get_error();
        if(interfaces_err_str != null) {
          draw_error(interfaces_err_str);
          if (PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load():File:error!:" + interfaces_err_str);
        }
        else if(parse_err_str[instance] != null) {
          draw_error(parse_err_str[instance]);
          if (PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load():File:parse() error!:" + parse_err_str[instance]);
        }
        return false;
      }
      // No mean in file interface.
      load_take_time[instance] = -1;
      load_remote_ip[instance] = null;
      load_remote_port[instance] = -1;
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load():File:ok!");
      return true;
    }
    else if(PS_DATA_interface[instance] == PS_DATA_INTERFACE_UART) {
      if(Interfaces_UART_load() != true) {
        interfaces_err_str = Interfaces_UART_get_error();
        if(interfaces_err_str != null) {
          draw_error(interfaces_err_str);
          if (PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load():UART:error!:" + interfaces_err_str);
        }
        else if(parse_err_str[instance] != null) {
          draw_error(parse_err_str[instance]);
          if (PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load():UART:parse() error!:" + parse_err_str[instance]);
        }
        return false;
      }
      load_take_time[instance] = Interfaces_UART_get_take_time();
      load_remote_ip[instance] = null;
      load_remote_port[instance] = -1;
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load():UART:ok!");
      return true;
    }
    else if(PS_DATA_interface[instance] == PS_DATA_INTERFACE_UDP) {
      if(Interfaces_UDP_handle.load(instance) != true) {
        interfaces_err_str = Interfaces_UDP_handle.get_error(instance);
        if(interfaces_err_str != null) {
          draw_error(interfaces_err_str);
          if (PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load():UDP:error!:" + interfaces_err_str);
        }
        else if(parse_err_str[instance] != null) {
          draw_error(parse_err_str[instance]);
          if (PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load():UDP:parse() error!:" + parse_err_str[instance]);
        }
        return false;
      }
      load_take_time[instance] = Interfaces_UDP_handle.get_take_time(instance);
      load_remote_ip[instance] = Interfaces_UDP_handle.get_remote_ip(instance);
      load_remote_port[instance] = Interfaces_UDP_handle.get_remote_port(instance);
      if (PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load():UDP:ok!");
      return true;
    }
    else /*if(PS_DATA_interface[instance] == PS_DATA_INTERFACE_SN)*/ {
      if(Interfaces_SN_load() != true) {
        interfaces_err_str = Interfaces_SN_get_error();
        if(interfaces_err_str != null) {
          draw_error(interfaces_err_str);
          if (PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load():SN:error!:" + interfaces_err_str);
        }
        else if(parse_err_str[instance] != null) {
          draw_error(parse_err_str[instance]);
          if (PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load():SN:error!:" + parse_err_str[instance]);
        }
        return false;
      }
      load_take_time[instance] = Interfaces_SN_get_take_time();
      load_remote_ip[instance] = Interfaces_SN_get_src_ip();
      load_remote_port[instance] = Interfaces_SN_get_src_port();
      if (PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load():SN:ok!");
      return true;
    }
  }

  // Parsing Data buffer
  boolean parse(int instance)
  {
    String func;
    int i = 0; // index for navigating Data bufffer.
    int crc_c; // calculated CRC
    int t_n_points; // temp number_of_points
    int len;
    int n_params;
    int crc;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("PS_Data:parse("+instance+"):");

    // Get function code.
    func = get_str_bytes(PS_Data_buf[instance], i, 4);
    if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",func=" + func);
    // Check function code is "GSCN".
    if (func.equals("GSCN") != true) {
      parse_err_str[instance] = "Error: Function code is invalid! " + func;
      draw_error(parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get Data buffer length.
    // : size of the following Data buffer record, without the CRC checksum
    len = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",length=" + len);
    // Check Data buffer record length with binary Data buffer length
    if (PS_Data_buf[instance].length < (len + 12)) {
      parse_err_str[instance] = "Error: PS_Data buf length is invalid!:" + PS_Data_buf[instance].length + "," + len;
      draw_error(parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get CRC and Calculate CRC
    crc = get_int32_bytes(PS_Data_buf[instance], 4 + 4 + len);
    if (PRINT_PS_DATA_PARSE_DBG) println("index=" + (4 + 4 + len) + ",crc=" + crc);
    crc_c = get_crc32(PS_Data_buf[instance], 0, 4 + 4 + len);
    // Check CRC ok?
    if(crc != crc_c) {
      parse_err_str[instance] = "Error: PS_Data buf crc error!:" + crc + "," + crc_c;
      draw_error(parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }

    // Get number of parameters.
    // : the number of following parameters. Becomes 0 if no scan is available.
    n_params = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number of parameters=" + n_params);
    if (n_params == 0) {
      parse_err_str[instance] = "Error: No scan data is available! n_params = 0";
      draw_error(parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get Number of points
    // : the number of measurement points in the scan.
    t_n_points = get_int32_bytes(PS_Data_buf[instance], 4 + 4 + 4 + n_params * 4);
    if (PRINT_PS_DATA_PARSE_DBG) println("index=" + (4 + 4 + 4 + n_params * 4) + ",number of points=" + t_n_points);
    // Check Number of points
    if (t_n_points > PS_DATA_POINTS_MAX || t_n_points <= 0) {
      parse_err_str[instance] = "Error: Number of points invalid! number_of_points[instance] is " + t_n_points;
      draw_error(parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    number_of_points[instance] = t_n_points;

    if (n_params >= 1) {
      // Get scan number(index).
      // : the number of the scan (starting with 1), should be the same as in the command request.
      scan_number[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan number=" + scan_number[instance]);
      i = i + 4;
    }

    if (n_params >= 2) {
      // Get time stamp.
      // : time stamp of the first measured point in the scan, given in milliseconds since the last SCAN command.
      time_stamp[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",time stamp=" + time_stamp[instance]);
      i = i + 4;
/*
      // Check time_stamp is changed
      if (PS_Data_old_time_stamp == time_stamp[instance]) {
        parse_err_str[instance] = "Scan Data buffer is not changed!:" + time_stamp[instance];
        draw_error(parse_err_str[instance]);
        if (PRINT_PS_DATA_PARSE_DBG) println("Scan Data buffer is not changed!:" + time_stamp[instance]);
        //parse_err_cnt[instance] ++;
        //return false;
      }
      PS_Data_old_time_stamp = time_stamp[instance];
*/
    }

    if (n_params >= 3) {
      // Get Scan start direction.
      // : direction to the first measured point, given in the user angle system (typical unit is 0,001 deg)
      scan_angle_start[instance] = get_int32_bytes(PS_Data_buf[instance], i) / 1000.0;
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan start angle=" + scan_angle_start[instance]);
      i = i + 4;
    }
  
    if (n_params >= 4) {
      // Get Scan angle
      // : the scan angle in the user angle system. Typically 90.000.
      scan_angle_size[instance] = get_int32_bytes(PS_Data_buf[instance], i) / 1000.0;
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan range angle=" + scan_angle_size[instance]);
      i = i + 4;
    }
  
    if (n_params >= 5) {
      // Get Number of echoes per point
      // : the number of echoes measured for each direction.
      number_of_echoes[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number of echos=" + number_of_echoes[instance]);
      i = i + 4;
    }
  
    if (n_params >= 6) {
      // Get Incremental count
      // : a direction provided by an external incremental encoder.
      incremental_count[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",encoder value=" + incremental_count[instance]);
      i = i + 4;
    }
  
    if (n_params >= 7) {
      // Get system system_temperature
      // : the system_temperature as measured inside of the scanner.
      // : This information can be used to control an optional air condition.
      system_temperature[instance] = get_int32_bytes(PS_Data_buf[instance], i) / 10f;
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",system temperature=" + system_temperature[instance]);
      i = i + 4;
    }
  
    if (n_params >= 8) {
      // Get System status
      // : contains a bit field with about the status of peripheral devices.
      system_status[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",system status=" + system_status[instance]);
      i = i + 4;
    }
  
    if (n_params >= 9) {
      // Get data data_content
      // : This parameter is built by the size of a single measurement record.
      // : It defines the data_content of the Data buffer section:
      //    o 4 Bytes: distances in 1/10 mm only.
      //    o 8 Bytes: distances in 1/10 mm and pulse widths in picoseconds
      //    o Any other value than 4 be read as "8 Bytes".
      data_content[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",data_content=" + data_content[instance]);
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
    number_of_points[instance] = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number_of_points[instance]=" + number_of_points[instance]);
    if (number_of_points[instance] > PS_DATA_POINTS_MAX || number_of_points[instance] <= 0) {
      parse_err_str[instance] = "Error: Number of points invalid! number_of_points is " + number_of_points[instance];
      draw_error(parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
*/
    i = i + 4;

    for (int j = 0; j < number_of_points[instance]; j++) {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distances[instance][j] = get_int32_bytes(PS_Data_buf[instance], i);
      i = i + 4;

      // Check pulse width exist
      if (data_content[instance] != 4) {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_widths[instance][j] = get_int32_bytes(PS_Data_buf[instance], i);
        //println("index=" + i + ",point=", j, ",pulse width=" + pulse_width);
        i = i + 4;
      }
    }

// Skip the get CRC. this already done above.
/*
    // Get CRC
    // : Checksum
    crc = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",crc=" + crc);
    i = i + 4;
*/  

    // Clear parse error string and count
    parse_err_str[instance] = null;
    parse_err_cnt[instance] = 0;

    return true;
  } // End of parse()
  
  // Draw params of parsed Data buffer
  void draw_params(int instance)
  {
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_params("+instance+"):");

    if(!PS_DATA_draw_params_enable) return;

    String[] strings = new String[13];
    int cnt;

    // Set to blank string at the end of array to avoid adding string null check code below.
    strings[strings.length-1] = "";
    strings[strings.length-2] = "";
    strings[strings.length-3] = "";
    cnt = 0;
    if(load_remote_ip[instance] != null)
      strings[cnt++] = "Source IP:" + load_remote_ip[instance];
    if(load_remote_port[instance] != -1)
      strings[cnt++] = "Source port:" + load_remote_port[instance];
    if(load_take_time[instance] != -1)
      strings[cnt++] = "Reponse time:" + load_take_time[instance] + "ms";
    strings[cnt++] = "Scan number:" + scan_number[instance];
    strings[cnt++] = "Time stamp:" + time_stamp[instance];
    strings[cnt++] = "Scan start direction:" + scan_angle_start[instance] + "°";
    strings[cnt++] = "Scan angle size:" + scan_angle_size[instance] + "°";
    strings[cnt++] = "Number of echoes:" + number_of_echoes[instance];
    strings[cnt++] = "Encoder count:" + incremental_count[instance];
    strings[cnt++] = "System temp.:" + system_temperature[instance] + "°C";
    strings[cnt++] = "System status:" + system_status[instance];
    strings[cnt++] = "Data content:" + data_content[instance];
    strings[cnt++] = "Number of points:" + number_of_points[instance];

    // Get max string width
    int witdh_max = 0;
    for( String string:strings)
    {
      //if(string != null)
        witdh_max = max(witdh_max, int(textWidth(string)));    
    }

    // Draw rect
    fill(C_PS_DATA_RECT_FILL);
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(C_PS_DATA_RECT_STROKE);
    strokeWeight(W_PS_DATA_RECT_STROKE);
    rect(FONT_HEIGHT * 3, TEXT_MARGIN*2 + FONT_HEIGHT * 1, witdh_max + TEXT_MARGIN*2, FONT_HEIGHT * cnt + TEXT_MARGIN*2, 5, 5, 5, 5);

    // Sets the color used to draw lines and borders around shapes.
    fill(C_PS_DATA_RECT_TEXT);
    stroke(C_PS_DATA_RECT_TEXT);
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
  
  // Draw points of parsed Data buffer
  void draw_points(int instance)
  {
    int distance;
    int pulse_width_curr = -1, pulse_width_prev = -1;
    int x_curr, y_curr;
    int point_size_curr = PS_DATA_POINT_SIZE; // Set size of point rect
    int point_size_prev = PS_DATA_POINT_SIZE; // Set size of point rect
    float cx, cy;
    float angle, radians;
    int x_prev = MIN_INT, y_prev = MIN_INT;
    color point_color_curr = C_PS_DATA_POINT, point_color_prev = C_PS_DATA_POINT;
    color line_color = C_PS_DATA_LINE;
    final int mouse_over_range =
      (ZOOM_FACTOR[instance] < 50)
      ?
      (PS_DATA_POINT_SIZE + (50 - ZOOM_FACTOR[instance]) / 10)
      :
      PS_DATA_POINT_SIZE; // Range for mouse over point rect. Adjust mouse over range by ZOOM_FACTOR.
    final int offset_x =
      (ROTATE_FACTOR[instance] == 315)
      ?
      (TEXT_MARGIN + FONT_HEIGHT / 2)
      :
      (
        (ROTATE_FACTOR[instance] == 135)
        ?
        (SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT / 2))
        :
        (SCREEN_width / 2)
      );
    final int offset_y =
      (ROTATE_FACTOR[instance] == 45)
      ?
      (TEXT_MARGIN + FONT_HEIGHT / 2)
      :
      (
        (ROTATE_FACTOR[instance] == 225)
        ?
        (SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT / 2))
        :
        (SCREEN_height / 2)
      );
    final int point_color_H_max_const =
      (
        PS_DATA_PULSE_WIDTH_MAX
        +
        int(float(PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN) * 5.0 / 6.0)
        -
        PS_DATA_PULSE_WIDTH_MAX
      )
      %
      (PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN + 1);
    final int point_color_H_min_const =
      (
        PS_DATA_PULSE_WIDTH_MAX
        +
        int(float(PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN) * 5.0 / 6.0)
        -
        PS_DATA_PULSE_WIDTH_MIN
      )
      %
      (PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN + 1);
    final float point_line_color_H_offset_const = float(PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN) * 5.0 / 6.0;
    final int point_line_color_H_modular_const = PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN + 1;
    final int point_line_color_HSB_max_const = PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN;
    final int mouse_over_x_min = mouseX - mouse_over_range;
    final int mouse_over_x_max = mouseX + mouse_over_range;
    final int mouse_over_y_min = mouseY - mouse_over_range;
    final int mouse_over_y_max = mouseY + mouse_over_range;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):");

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):number_of_points="+number_of_points[instance]);

    // Sets the weight used to draw lines and borders around shapes.
    strokeWeight(W_PS_DATA_LINE_POINT);

    // Check pulse width exist than color mode set to HSB.
    if (data_content[instance] != 4)
    {
      colorMode(HSB, point_line_color_HSB_max_const);
    }

    for (int j = 0; j < number_of_points[instance]; j++)
    {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distance = distances[instance][j];
      // Check No echo
      if (distance == 0x80000000)
      {
        //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + "No echo");
        x_prev = MIN_INT;
        y_prev = MIN_INT;
        pulse_width_prev = -1;
      }
      // Check Noisy
      else if (distance == 0x7fffffff)
      {
        //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + "Noise");
        x_prev = MIN_INT;
        y_prev = MIN_INT;
        pulse_width_prev = -1;
      }
      else
      {
        //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance);
        angle = scan_angle_start[instance] - 45.0 + float(j) * scan_angle_size[instance] / float(number_of_points[instance]);
        radians = radians(angle);
        if (ROTATE_FACTOR[instance] == 315)
        {
          cx = float(distance) * sin(radians);
          cy = float(distance) * cos(radians);
          x_curr = int(cx / ZOOM_FACTOR[instance]);
          y_curr = int(cy / ZOOM_FACTOR[instance]);
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start[instance] + float(j) * scan_angle_size[instance] / float(number_of_points[instance])) + ",x_curr=" + x_curr + ",y_curr=", y_curr);
          x_curr += offset_x;
          if (MIRROR_ENABLE[instance])
            y_curr += offset_y;
          else
            y_curr = offset_y - y_curr;
        }
        else if (ROTATE_FACTOR[instance] == 45)
        {
          cx = float(distance) * cos(radians);
          cy = float(distance) * sin(radians);
          x_curr = int(cx / ZOOM_FACTOR[instance]);
          y_curr = int(cy / ZOOM_FACTOR[instance]);
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start[instance] + float(j) * scan_angle_size[instance] / float(number_of_points[instance])) + ",x_curr=" + x_curr + ",y_curr=", y_curr);
          if (MIRROR_ENABLE[instance])
            x_curr = offset_x - x_curr;
          else
            x_curr += offset_x;
          y_curr += offset_y;
        }
        else if (ROTATE_FACTOR[instance] == 135)
        {
          cx = float(distance) * sin(radians);
          cy = float(distance) * cos(radians);
          x_curr = int(cx / ZOOM_FACTOR[instance]);
          y_curr = int(cy / ZOOM_FACTOR[instance]);
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start[instance] + float(j) * scan_angle_size[instance] / float(number_of_points[instance])) + ",x_curr=" + x_curr + ",y_curr=", y_curr);
          x_curr = offset_x - x_curr;
          if (MIRROR_ENABLE[instance])
            y_curr = offset_y - y_curr;
          else
            y_curr += offset_y;
        }
        else /*if (ROTATE_FACTOR[instance] == 225)*/
        {
          cx = float(distance) * cos(radians);
          cy = float(distance) * sin(radians);
          x_curr = int(cx / ZOOM_FACTOR[instance]);
          y_curr = int(cy / ZOOM_FACTOR[instance]);
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle=" + (scan_angle_start[instance] + float(j) * scan_angle_size[instance] / float(number_of_points[instance])) + ",x_curr=" + x_curr + ",y_curr=", y_curr);
          if (MIRROR_ENABLE[instance])
            x_curr += offset_x;
          else
            x_curr = offset_x - x_curr;
          y_curr = offset_y - y_curr;
        }

        x_curr += DRAW_OFFSET_X[instance];
        y_curr += DRAW_OFFSET_Y[instance];

        // Check pulse width exist
        if (data_content[instance] != 4)
        {
          pulse_width_curr = pulse_widths[instance][j];
          //print("[" + j + "]=" + pulse_widths[instance][j] + " ");
          if(pulse_width_curr > PS_DATA_PULSE_WIDTH_MAX)
          {
            point_color_curr =
              color(
                point_color_H_max_const,
                point_line_color_HSB_max_const,
                point_line_color_HSB_max_const);
          }
          else if(pulse_width_curr < PS_DATA_PULSE_WIDTH_MIN)
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
                (PS_DATA_PULSE_WIDTH_MAX + int(point_line_color_H_offset_const - pulse_width_curr)) % point_line_color_H_modular_const,
                point_line_color_HSB_max_const,
                point_line_color_HSB_max_const);
          }
          if(pulse_width_prev != -1)
          {
            line_color =
              color(
                (PS_DATA_PULSE_WIDTH_MAX + int(point_line_color_H_offset_const - (float(pulse_width_curr + pulse_width_prev) / 2.0))) % point_line_color_H_modular_const,
                point_line_color_HSB_max_const,
                point_line_color_HSB_max_const);
          }
        }
        else
        {
          point_color_curr = C_PS_DATA_POINT;
          point_color_prev = C_PS_DATA_POINT;
          line_color = C_PS_DATA_LINE;
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
          point_size_curr = PS_DATA_POINT_SIZE;
        }

        if (x_prev != MIN_INT && y_prev != MIN_INT)
        {
          //print(j + ":" + pulse_width_prev + "," + pulse_width_curr + " ");
          fill(line_color);
          stroke(line_color);
          line(x_prev, y_prev, x_curr, y_curr);
          fill(point_color_prev);
          stroke(point_color_prev);
          //point(x_prev + DRAW_OFFSET_X[instance], y_prev + DRAW_OFFSET_Y[instance]);
          rect(x_prev - point_size_prev / 2, y_prev - point_size_prev / 2, point_size_prev, point_size_prev );
        }
        fill(point_color_curr);
        stroke(point_color_curr);
        //point(x_curr + DRAW_OFFSET_X[instance], y_curr + DRAW_OFFSET_Y[instance]);
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
      if (data_content[instance] != 4)
      {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_width_curr = pulse_widths[instance][j];
        if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",pulse width=" + pulse_width_curr);
      }
*/
    } // End of for (int j = 0; j < number_of_points[instance]; j++)

    // Check pulse width exist than color mode back to RGB.
    if (data_content[instance] != 4)
    {
      colorMode(RGB, 255);
    }
  } // End of draw_points()
  
  void draw_error(String message)
  {
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_error():");

    // Sets the color used to draw lines and borders around shapes.
    fill(C_PS_DATA_ERR_TEXT);
    stroke(C_PS_DATA_ERR_TEXT);
    textSize(FONT_HEIGHT*3);
    text(message, SCREEN_width / 2 - int(textWidth(message) / 2.0), SCREEN_height / 2 - FONT_HEIGHT);
    textSize(FONT_HEIGHT);
  }
}
