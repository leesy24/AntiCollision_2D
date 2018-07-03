//final static boolean PRINT_PS_DATA_ALL_DBG = true; 
final static boolean PRINT_PS_DATA_ALL_DBG = false;
final static boolean PRINT_PS_DATA_ALL_ERR = true; 
//final static boolean PRINT_PS_DATA_ALL_ERR = false;

//final static boolean PRINT_PS_DATA_SETTINGS_DBG = true; 
final static boolean PRINT_PS_DATA_SETTINGS_DBG = false;
//final static boolean PRINT_PS_DATA_SETTINGS_ERR = true; 
final static boolean PRINT_PS_DATA_SETTINGS_ERR = false;

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

static color C_PS_DATA_ERR_TEXT = #000000; // Black
static color C_PS_DATA_LINE = #0000FF; // Blue
static color C_PS_DATA_POINT = #FF0000; // Red
static int W_PS_DATA_LINE = 1;
static color C_PS_DATA_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
static color C_PS_DATA_RECT_STROKE = #000000; // Black
static int W_PS_DATA_RECT_STROKE = 1;
static color C_PS_DATA_RECT_TEXT = #404040; // Black + 0x40

static int PS_DATA_SAVE_ALWAYS_DURATION = 2000; // unit is ms.

final static int PS_DATA_SAVE_ALWAYS_DURATION_MIN = 1000; // 1 second
final static int PS_DATA_SAVE_ALWAYS_DURATION_MAX = 24*60*60*1000; // 1 day

final static int PS_DATA_POINTS_MAX = 1000;
final static int PS_DATA_POINT_WEIGHT = 3;

final static int PS_DATA_PULSE_WIDTH_MAX = 12000;
final static int PS_DATA_PULSE_WIDTH_MIN = 4096;

final static int PS_Interface_FILE = 0;
final static int PS_Interface_UART = 1;
final static int PS_Interface_UDP = 2;
final static int PS_Interface_SN = 3;

static boolean PS_Data_draw_points_with_line;

static boolean PS_Data_save_enabled;

static int[] PS_Interface = new int[PS_INSTANCE_MAX];
static String[] PS_Interface_str = {"File", "UART", "UDP", "SN"};

static String[] FILE_name = new String[PS_INSTANCE_MAX];

final static int UDP_TIMEOUT_VAL = 500; // timeout 500ms for UDP
final static int UDP_TIMEOUT_RETRY = 3; // retry count when timeout for UDP

static int[] UDP_local_port = new int[PS_INSTANCE_MAX];
static String[] UDP_remote_ip = new String[PS_INSTANCE_MAX];
static int[] UDP_remote_port = new int[PS_INSTANCE_MAX];

static int[] SN_serial_number = new int[PS_INSTANCE_MAX];

static PS_Data PS_Data_handle;

// Define Data buffer array to load binary Data buffer from interfaces
static byte[][] PS_Data_buf = new byte[PS_INSTANCE_MAX][]; 

static boolean PS_Data_draw_points_all_enabled;

static boolean[] PS_Data_draw_params_enabled = new boolean[PS_INSTANCE_MAX];
static int[] PS_Data_draw_params_timer = new int[PS_INSTANCE_MAX];
static int[] PS_Data_draw_params_x = new int[PS_INSTANCE_MAX];
static int[] PS_Data_draw_params_y = new int[PS_INSTANCE_MAX];

// Define old time stamp to check time stamp changed for detecting Data buffer changed or not
//long PS_Data_old_time_stamp = -1;

void PS_Data_setup()
{
  if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_SETUP_DBG) println("PS_Data_setup():Enter");

  // Append interface name to window title

  //PS_Data_draw_points_with_line = true;
  PS_Data_draw_points_with_line = false;

  PS_Data_save_enabled = true;
  //PS_Data_save_enabled = false;

  //PS_Data_draw_points_all_enabled = true;
  PS_Data_draw_points_all_enabled = false;

  if (PS_DATA_SAVE_ALWAYS_DURATION > PS_DATA_SAVE_ALWAYS_DURATION_MAX) PS_DATA_SAVE_ALWAYS_DURATION = PS_DATA_SAVE_ALWAYS_DURATION_MAX;
  if (PS_DATA_SAVE_ALWAYS_DURATION < PS_DATA_SAVE_ALWAYS_DURATION_MIN) PS_DATA_SAVE_ALWAYS_DURATION = PS_DATA_SAVE_ALWAYS_DURATION_MIN;

  for (int i = 0; i < PS_INSTANCE_MAX; i++)
  {
/*
    PS_Interface[i] = PS_Interface_FILE;
    FILE_name[i] = "";
    UDP_remote_ip[i] = "10.0.8.86";
    UDP_remote_port[i] = 1024;
    SN_serial_number[i] = 886;
*/
    PS_Data_draw_params_enabled[i] = false;
    PS_Data_draw_params_timer[i] = millis();
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

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if(PS_Interface[i] == PS_Interface_FILE) 
      Title += "File";
    else if(PS_Interface[i] == PS_Interface_UART)
      Title += "UART";
    else if(PS_Interface[i] == PS_Interface_UDP)
      Title += "UDP";
    else if(PS_Interface[i] == PS_Interface_SN)
      Title += "SN";
    else {
      if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup():PS_Interface["+i+"]="+PS_Interface[i]+" error!");
    }      
  }
  
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if(PS_Interface[i] == PS_Interface_FILE) {
      Interfaces_File_setup();
      Interfaces_File_handle.open(i, FILE_name[i]);
      PS_Data_handle.file_name[i] = FILE_name[i];
    }
    else if(PS_Interface[i] == PS_Interface_UART) {
      Interfaces_UART_setup();
    }
    else if(PS_Interface[i] == PS_Interface_UDP) {
      Interfaces_UDP_setup(UDP_local_port[i]);
      Interfaces_UDP_handle.open(i, UDP_remote_ip[i], UDP_remote_port[i]);
      Interfaces_UDP_handle.set_comm_timeout(i, UDP_TIMEOUT_VAL, UDP_TIMEOUT_RETRY);
      PS_Data_handle.remote_ip[i] = UDP_remote_ip[i];
      PS_Data_handle.remote_port[i] = UDP_remote_port[i];
    }
    else if(PS_Interface[i] == PS_Interface_SN) {
      String remote_ip = "10.0."+(SN_serial_number[i]/100)+"."+(SN_serial_number[i]%100);
      int remote_port = 1024;

      Interfaces_UDP_setup(UDP_local_port[i]);
      Interfaces_UDP_handle.open(i, remote_ip, remote_port);
      Interfaces_UDP_handle.set_comm_timeout(i, UDP_TIMEOUT_VAL, UDP_TIMEOUT_RETRY);
      PS_Data_handle.serial_number[i] = SN_serial_number[i];
      PS_Data_handle.remote_ip[i] = remote_ip;
      PS_Data_handle.remote_port[i] = remote_port;
    }
    else {
      if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup():PS_Interface["+i+"]="+PS_Interface[i]+" error!");
    }
  }
}

// A PS_Data class
class PS_Data {
  int[] scan_number = new int[PS_INSTANCE_MAX];
  int[] time_stamp = new int[PS_INSTANCE_MAX];
  //long[] time_stamp = new long[PS_INSTANCE_MAX];
  float[] scan_angle_start = new float[PS_INSTANCE_MAX];
  float[] scan_angle_size = new float[PS_INSTANCE_MAX];
  float[] scan_angle_step = new float[PS_INSTANCE_MAX];
  int[] number_of_echoes = new int[PS_INSTANCE_MAX];
  int[] incremental_count = new int[PS_INSTANCE_MAX];
  float[] system_temperature = new float[PS_INSTANCE_MAX];
  int[] system_status = new int[PS_INSTANCE_MAX];
  int[] data_content = new int[PS_INSTANCE_MAX];
  int[] number_of_points = new int[PS_INSTANCE_MAX];
  int[][] distances = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  float[][] angle_degree = new float[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] mi_x = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] mi_y = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] scr_x = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] scr_y = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] pulse_width = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  color[][] pulse_width_color = new color[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  String[] parse_err_str = new String[PS_INSTANCE_MAX];
  int[] parse_err_cnt = new int[PS_DATA_POINTS_MAX];
  int[] load_take_time = new int[PS_INSTANCE_MAX];
  String[] file_name = new String[PS_INSTANCE_MAX];
  String[] remote_ip = new String[PS_INSTANCE_MAX];
  int[] remote_port = new int[PS_INSTANCE_MAX];
  int[] serial_number = new int[PS_INSTANCE_MAX];
  boolean[] time_stamp_reseted = new boolean[PS_INSTANCE_MAX];
  // Test time_stamp wrap-around.
  //int[] time_stamp_offset = new int[PS_INSTANCE_MAX];
  //long[] time_stamp_offset = new long[PS_INSTANCE_MAX];

  // Create the PS_Data
  PS_Data() {
    if (PRINT_PS_DATA_ALL_DBG) println("PS_Data:constructor():");
    // Init. class variables.
    //println("PS_Data_buf[0]="+PS_Data_buf[0]+",PS_Data_buf[1]="+PS_Data_buf[1]);
    for (int i = 0; i < PS_INSTANCE_MAX; i++) {
      scan_number[i] = 0;
      time_stamp[i] = -1;
      scan_angle_start[i] = 0;
      scan_angle_size[i] = 0;
      scan_angle_step[i] = 0;
      number_of_echoes[i] = 0;
      incremental_count[i] = 0;
      system_temperature[i] = 0;
      system_status[i] = 0;
      data_content[i] = 0;
      number_of_points[i] = 0;
      parse_err_str[i] = null;
      parse_err_cnt[i] = 0;
      load_take_time[i] = 0;
      file_name[i] = null;
      remote_ip[i] = null;
      remote_port[i] = MIN_INT;
      serial_number[i] = MIN_INT;
      time_stamp_reseted[i] = false;
      // Test time_stamp wrap-around.
      //time_stamp_offset[i] = -1;
      //time_stamp_last[i] = -1L;
    }
  }

  // Load PS_Data_buf
  boolean load(int instance) {
    String interfaces_err_str;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load("+instance+"):");
    //if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println(""PS_Data:load("+instance+"):PS_Data_buf["+instance+"]="+PS_Data_buf[instance]);

    if(PS_Interface[instance] == PS_Interface_FILE) {
      if(Interfaces_File_handle.load(instance) != true) {
        interfaces_err_str = Interfaces_File_handle.get_error(instance);
        if(interfaces_err_str != null) {
          draw_error(instance, interfaces_err_str);
          if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":error!:" + interfaces_err_str);
        }
        else if(parse_err_str[instance] != null) {
          draw_error(instance, parse_err_str[instance]);
          if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":parse() error!:" + parse_err_str[instance]);
        }
        return false;
      }
      // No mean in file interface.
      load_take_time[instance] = -1;
    }
    else if(PS_Interface[instance] == PS_Interface_UART) {
      if(Interfaces_UART_load() != true) {
        interfaces_err_str = Interfaces_UART_get_error();
        if(interfaces_err_str != null) {
          draw_error(instance, interfaces_err_str);
          if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":error!:" + interfaces_err_str);
        }
        else if(parse_err_str[instance] != null) {
          draw_error(instance, parse_err_str[instance]);
          if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":parse() error!:" + parse_err_str[instance]);
        }
        return false;
      }
      load_take_time[instance] = Interfaces_UART_get_take_time();
    }
    else if(PS_Interface[instance] == PS_Interface_UDP
            ||
            PS_Interface[instance] == PS_Interface_SN) {
      if(Interfaces_UDP_handle.load(instance) != true) {
        interfaces_err_str = Interfaces_UDP_handle.get_error(instance);
        if(interfaces_err_str != null) {
          draw_error(instance, interfaces_err_str);
          if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":error!:" + interfaces_err_str);
        }
        else if(parse_err_str[instance] != null) {
          draw_error(instance, parse_err_str[instance]);
          if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":parse() error!:" + parse_err_str[instance]);
        }
        return false;
      }
      load_take_time[instance] = Interfaces_UDP_handle.get_take_time(instance);
    }
    else {
      if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load("+instance+"):PS_Interface["+instance+"] error! " + PS_Interface[instance]);
      return false;
    }

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":ok!");

    return true;
  }

  int write_count = 0;
  int write_time_sum = 0;
  int delete_count = 0;
  int delete_time_sum = 0;
  void save_always(int instance) {
    // Save always feature will not run when PS Interface is FILE.
    if (PS_Interface[instance] == PS_Interface_FILE) return;
    
    if (!PS_Data_save_enabled) return;

    int save_always_start_millis = millis();

    long time_stamp = new Date().getTime();
    //Dbg_Time_logs_handle.add("Date().getTime()");
    String always_dir_full_name = sketchPath("always\\");
    File always_dir_handle = new File(always_dir_full_name);
    //println("time_stamp="+time_stamp+",millis()="+millis());
    if (!always_dir_handle.isDirectory()) {
      if (!always_dir_handle.mkdir()) {
        if (PRINT_PS_DATA_PARSE_ERR) println("PS_Data:save_always("+instance+"):mkdir() error! "+always_dir_full_name);
        return;
      }
      Dbg_Time_logs_handle.add("PS_Data:mkdir():");
    }
    if (!write_file(PS_Data_buf[instance], always_dir_full_name+instance+"_"+time_stamp+".dat")) {
      if (PRINT_PS_DATA_PARSE_ERR) println("PS_Data:save_always("+instance+"):write_file() error! "+always_dir_full_name+instance+"_"+time_stamp+".dat");
      return;
    }
//    println("PS_Data:save_always("+instance+"):"+"save_bytes_take_time="+get_millis_diff(save_always_start_millis));
    Dbg_Time_logs_handle.add("PS_Data:write_file():avg="+((write_count!=0)?(write_time_sum/write_count):0));
    write_time_sum += Dbg_Time_logs_handle.get_add_diff();
    write_count ++;

    // Check save always operation is too late by frame time.
    if (Dbg_Time_logs_handle.get_diff() >= FRAME_TIME) return;

    // Check save always operation is too late by frame time.
    if (get_millis_diff(save_always_start_millis) >= (FRAME_TIME / 2)) return;

    // get files list to decide delete file.
    String[] always_files_list = always_dir_handle.list();
    if (always_files_list == null) return;
    int cnt = 0;
    for (String always_file_name:always_files_list) {
      long file_time_stamp;
      try {
        file_time_stamp = Long.parseLong(always_file_name.substring(2, always_file_name.length() - 4));
      }
      catch (NumberFormatException e) {
        file_time_stamp = time_stamp - PS_DATA_SAVE_ALWAYS_DURATION; // to delete file.
      }
      if (file_time_stamp > time_stamp - PS_DATA_SAVE_ALWAYS_DURATION) continue;
      //println(always_file_name+","+file_time_stamp);
      File always_file_handle;
      always_file_handle = new File(always_dir_full_name+always_file_name);
      always_file_handle.delete();
      cnt ++;
      Dbg_Time_logs_handle.add("PS_Data:delete_file():"+always_file_name+":cnt="+cnt+",avg="+((delete_count!=0)?(delete_time_sum/delete_count):0));
      delete_time_sum += Dbg_Time_logs_handle.get_add_diff();
      delete_count ++;
      // Check save always operation is too late by frame time.
      if (get_millis_diff(save_always_start_millis) >= (FRAME_TIME / 2)) break;
    }
//    println("PS_Data:save_always("+instance+"):"+"delete_file_take_time="+get_millis_diff(save_always_start_millis));
  }

  // Parsing Data buffer
  boolean parse(int instance) {
    String func;
    int i = 0; // index for navigating Data bufffer.
    int crc_c; // calculated CRC
    int t_n_points; // temp number_of_points
    int len;
    int n_params;
    int crc;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("PS_Data:parse("+instance+"):Enter");

    // Get function code.
    func = get_str_bytes(PS_Data_buf[instance], i, 4);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",func=" + func);
    // Check function code is "GSCN".
    if (func.equals("GSCN") != true) {
      parse_err_str[instance] = "Error: Function code is invalid! " + func;
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get Data buffer length.
    // : size of the following Data buffer record, without the CRC checksum
    len = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",length=" + len);
    // Check Data buffer record length with binary Data buffer length
    if (PS_Data_buf[instance].length < (len + 12)) {
      parse_err_str[instance] = "Error: PS_Data buf length is invalid!:" + PS_Data_buf[instance].length + "," + len;
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get CRC and Calculate CRC
    crc = get_int32_bytes(PS_Data_buf[instance], 4 + 4 + len);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + (4 + 4 + len) + ",crc=" + crc);
    crc_c = get_crc32(PS_Data_buf[instance], 0, 4 + 4 + len);
    // Check CRC ok?
    if(crc != crc_c) {
      parse_err_str[instance] = "Error: PS_Data buf crc error!:" + crc + "," + crc_c;
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }

    // Get number of parameters.
    // : the number of following parameters. Becomes 0 if no scan is available.
    n_params = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number of parameters=" + n_params);
    if (n_params == 0) {
      parse_err_str[instance] = "Error: No scan data is available! n_params = 0";
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get Number of points
    // : the number of measurement points in the scan.
    t_n_points = get_int32_bytes(PS_Data_buf[instance], 4 + 4 + 4 + n_params * 4);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + (4 + 4 + 4 + n_params * 4) + ",number of points=" + t_n_points);
    // Check Number of points
    if (t_n_points > PS_DATA_POINTS_MAX || t_n_points <= 0) {
      parse_err_str[instance] = "Error: Number of points invalid! number_of_points is " + t_n_points;
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    number_of_points[instance] = t_n_points;

    if (n_params >= 1) {
      // Get scan number(index).
      // : the number of the scan (starting with 1), should be the same as in the command request.
      scan_number[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan number=" + scan_number[instance]);
      i = i + 4;
    }

    if (n_params >= 2) {
      if (PS_Interface[instance] == PS_Interface_FILE) {
        time_stamp[instance] = millis();
      }
      else {
        int time_stamp_new;
        int time_stamp_diff;
        //long time_stamp_new;
        // Get time stamp.
        // : time stamp of the first measured point in the scan, given in milliseconds since the last SCAN command.
        //time_stamp[instance] = get_int32_bytes(PS_Data_buf[instance], i);
        time_stamp_new = get_int32_bytes(PS_Data_buf[instance], i);
        time_stamp_diff = get_int_diff(time_stamp_new, time_stamp[instance]);
        if ( time_stamp_diff < 0 && time_stamp_diff > UDP_TIMEOUT_VAL * UDP_TIMEOUT_RETRY) {
          if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_PARSE_ERR) println("PS_Data:parse("+instance+"):time_stamp is big different. PS rebooted! " + time_stamp_new + "," + time_stamp[instance]);
          // time_stamp is big different. PS rebooted!
          time_stamp_reseted[instance] = true;
        }
        time_stamp[instance] = time_stamp_new;
      }

      //time_stamp[instance] = get_long32_bytes(PS_Data_buf[instance], i);
      // Test time_stamp wrap-around.
      /*
      if (time_stamp_offset[instance] == -1) {
      //if (time_stamp_offset[instance] == -1L) {
        time_stamp_offset[instance] = 0xffffffff - time_stamp[instance] - 10000;
        //time_stamp_offset[instance] = 0x7fffffffffffffffL - time_stamp[instance] - 10000;
      }
      time_stamp[instance] += time_stamp_offset[instance];
      */

      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",time stamp=" + time_stamp[instance]);
      i = i + 4;
/*
      // Check time_stamp is changed
      if (PS_Data_old_time_stamp == time_stamp[instance]) {
        parse_err_str[instance] = "Scan Data buffer is not changed!:" + time_stamp[instance];
        draw_error(instance, parse_err_str[instance]);
        if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("Scan Data buffer is not changed!:" + time_stamp[instance]);
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
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan start angle=" + scan_angle_start[instance]);
      i = i + 4;
    }
  
    if (n_params >= 4) {
      // Get Scan angle
      // : the scan angle in the user angle system. Typically 90.000.
      int val = get_int32_bytes(PS_Data_buf[instance], i);
      scan_angle_size[instance] = val / 1000.0;
      scan_angle_step[instance] = float(val) / float(number_of_points[instance]) / 1000.0;
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan range angle=" + scan_angle_size[instance]);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan step angle=" + scan_angle_step[instance]);
      i = i + 4;
    }
  
    if (n_params >= 5) {
      // Get Number of echoes per point
      // : the number of echoes measured for each direction.
      number_of_echoes[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number of echos=" + number_of_echoes[instance]);
      i = i + 4;
    }
  
    if (n_params >= 6) {
      // Get Incremental count
      // : a direction provided by an external incremental encoder.
      incremental_count[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",encoder value=" + incremental_count[instance]);
      i = i + 4;
    }
  
    if (n_params >= 7) {
      // Get system system_temperature
      // : the system_temperature as measured inside of the scanner.
      // : This information can be used to control an optional air condition.
      system_temperature[instance] = get_int32_bytes(PS_Data_buf[instance], i) / 10f;
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",system temperature=" + system_temperature[instance]);
      i = i + 4;
    }
  
    if (n_params >= 8) {
      // Get System status
      // : contains a bit field with about the status of peripheral devices.
      system_status[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",system status=" + system_status[instance]);
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
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",data_content=" + data_content[instance]);
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
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number_of_points[instance]=" + number_of_points[instance]);
    if (number_of_points[instance] > PS_DATA_POINTS_MAX || number_of_points[instance] <= 0) {
      parse_err_str[instance] = "Error: Number of points invalid! number_of_points is " + number_of_points[instance];
      draw_error(instance, parse_err_str[instance]);
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
      angle_degree[instance][j] =
        scan_angle_start[instance] - 45.0
        +
        float(j) * scan_angle_size[instance] / float(number_of_points[instance]);
      // No echo or Noisy
      if (distances[instance][j] == 0x80000000
          ||
          distances[instance][j] == 0x7fffffff) {
        mi_x[instance][j] = MIN_INT;
        mi_y[instance][j] = MIN_INT;
        scr_x[instance][j] = MIN_INT;
        scr_y[instance][j] = MIN_INT;
      }
      else {
        mi_x[instance][j] = int(distances[instance][j] * cos(radians(angle_degree[instance][j])));
        mi_y[instance][j] = int(distances[instance][j] * sin(radians(angle_degree[instance][j])));

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

        if (ROTATE_FACTOR[instance] == 315) {
          scr_x[instance][j] = mi_y[instance][j] / ZOOM_FACTOR[instance];
          scr_y[instance][j] = mi_x[instance][j] / ZOOM_FACTOR[instance];
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle_degree=" + angle_degree[instance][j] + ",scr_x=" + scr_x[instance][j] + ",scr_y=", scr_y[instance][j]);
          scr_x[instance][j] += offset_x;
          if (MIRROR_ENABLE[instance])
            scr_y[instance][j] += offset_y;
          else
            scr_y[instance][j] = offset_y - scr_y[instance][j];
        }
        else if (ROTATE_FACTOR[instance] == 45) {
          scr_x[instance][j] = mi_x[instance][j] / ZOOM_FACTOR[instance];
          scr_y[instance][j] = mi_y[instance][j] / ZOOM_FACTOR[instance];
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle_degree=" + angle_degree[instance][j] + ",scr_x=" + scr_x[instance][j] + ",scr_y=", scr_y[instance][j]);
          if (MIRROR_ENABLE[instance])
            scr_x[instance][j] = offset_x - scr_x[instance][j];
          else
            scr_x[instance][j] += offset_x;
          scr_y[instance][j] += offset_y;
        }
        else if (ROTATE_FACTOR[instance] == 135) {
          scr_x[instance][j] = mi_y[instance][j] / ZOOM_FACTOR[instance];
          scr_y[instance][j] = mi_x[instance][j] / ZOOM_FACTOR[instance];
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle_degree=" + angle_degree[instance][j] + ",scr_x=" + scr_x[instance][j] + ",scr_y=", scr_y[instance][j]);
          scr_x[instance][j] = offset_x - scr_x[instance][j];
          if (MIRROR_ENABLE[instance])
            scr_y[instance][j] = offset_y - scr_y[instance][j];
          else
            scr_y[instance][j] += offset_y;
        }
        else /*if (ROTATE_FACTOR[instance] == 225)*/ {
          scr_x[instance][j] = mi_x[instance][j] / ZOOM_FACTOR[instance];
          scr_y[instance][j] = mi_y[instance][j] / ZOOM_FACTOR[instance];
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",angle_degree=" + angle_degree[instance][j] + ",scr_x=" + scr_x[instance][j] + ",scr_y=", scr_y[instance][j]);
          if (MIRROR_ENABLE[instance])
            scr_x[instance][j] += offset_x;
          else
            scr_x[instance][j] = offset_x - scr_x[instance][j];
          scr_y[instance][j] = offset_y - scr_y[instance][j];
        }
        scr_x[instance][j] += DRAW_OFFSET_X[instance];
        scr_y[instance][j] += DRAW_OFFSET_Y[instance];

        //println("PS_Data:parse("+instance+"):"+"j="+j+",mi_x="+mi_x[instance][j]+",mi_y="+mi_y[instance][j]);
        //println("PS_Data:parse("+instance+"):"+"j="+j+",scr_x="+scr_x[instance][j]+",scr_y="+scr_y[instance][j]);
      }
      i = i + 4;

      // Check pulse width exist
      if (data_content[instance] != 4) {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_width[instance][j] = get_int32_bytes(PS_Data_buf[instance], i);
        //println("index=" + i + ",point=", j, ",pulse width=" + pulse_width);

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

        colorMode(HSB, point_line_color_HSB_max_const);

        //print("[" + j + "]=" + pulse_width[instance][j] + " ");
        if(pulse_width[instance][j] > PS_DATA_PULSE_WIDTH_MAX)
        {
          pulse_width_color[instance][j] =
            color(
              point_color_H_max_const,
              point_line_color_HSB_max_const,
              point_line_color_HSB_max_const);
        }
        else if(pulse_width[instance][j] < PS_DATA_PULSE_WIDTH_MIN)
        {
          pulse_width_color[instance][j] =
            color(
              point_color_H_min_const,
              point_line_color_HSB_max_const,
              point_line_color_HSB_max_const);
        }
        else
        {
          pulse_width_color[instance][j] =
            color(
              (PS_DATA_PULSE_WIDTH_MAX + int(point_line_color_H_offset_const - pulse_width[instance][j])) % point_line_color_H_modular_const,
              point_line_color_HSB_max_const,
              point_line_color_HSB_max_const);
        }

        colorMode(RGB, 255);

        i = i + 4;
      }
      else {
        pulse_width[instance][j] = -1;
        pulse_width_color[instance][j] = C_PS_DATA_POINT;
      }
    }

// Skip the get CRC. this already done above.
/*
    // Get CRC
    // : Checksum
    crc = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",crc=" + crc);
    i = i + 4;
*/  

    // Clear parse error string and count
    parse_err_str[instance] = null;
    parse_err_cnt[instance] = 0;

    return true;
  } // End of parse()

  final static int DRAW_PARAMS_TIMEOUT = 10000; // 10 seconds

  // Draw params of parsed Data buffer
  void draw_params(int instance) {
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_params("+instance+"):");

    if(!PS_Data_draw_params_enabled[instance]) return;

    if(get_millis_diff(PS_Data_draw_params_timer[instance]) >= DRAW_PARAMS_TIMEOUT) {
      PS_Data_draw_params_enabled[instance] = false;
    }

    LinkedList<String> strings = new LinkedList<String>();

    strings.add("Interface:" + PS_Interface_str[PS_Interface[instance]]);
    if(file_name[instance] != null)
      strings.add("File name:" + file_name[instance]);;
    if(serial_number[instance] != MIN_INT)
      strings.add("Serial Number:" + serial_number[instance]);;
    if(remote_ip[instance] != null)
      strings.add("IP:" + remote_ip[instance]);
    if(remote_port[instance] != MIN_INT)
      strings.add("Port:" + remote_port[instance]);
    if(load_take_time[instance] != -1)
      strings.add("Reponse time:" + load_take_time[instance] + "ms");
    strings.add("Scan number:" + scan_number[instance]);
    strings.add("Time stamp:" + time_stamp[instance]);
    strings.add("Scan start direction:" + scan_angle_start[instance] + "°");
    strings.add("Scan angle size:" + scan_angle_size[instance] + "°");
    strings.add("Number of echoes:" + number_of_echoes[instance]);
    strings.add("Encoder count:" + incremental_count[instance]);
    strings.add("System temp.:" + system_temperature[instance] + "°C");
    strings.add("System status:" + system_status[instance]);
    strings.add("Data content:" + data_content[instance]);
    strings.add("Number of points:" + number_of_points[instance]);
    strings.add("Time-out:" + ((DRAW_PARAMS_TIMEOUT + 1000 - get_millis_diff(PS_Data_draw_params_timer[instance]))/1000) + "s");

    // Get max string width
    textSize(FONT_HEIGHT);
    int witdh_max = 0;
    for (String string:strings) {
      witdh_max = max(witdh_max, int(textWidth(string)));    
    }

    int rect_w, rect_h;
    int rect_x, rect_y;
    int rect_tl = 5, rect_tr = 5, rect_br = 5, rect_bl = 5;
    if (ROTATE_FACTOR[instance] == 315) {
      if (MIRROR_ENABLE[instance]) { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance];
        rect_y = PS_Data_draw_params_y[instance];
        rect_tl = 0;
      }
      else { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance];
        rect_y = PS_Data_draw_params_y[instance] - rect_h - 1;
        rect_bl = 0;
      }
    }
    else if (ROTATE_FACTOR[instance] == 45) {
      if (MIRROR_ENABLE[instance]) { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance] - rect_w - 1;
        rect_y = PS_Data_draw_params_y[instance];
        rect_tr = 0;
      }
      else { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance];
        rect_y = PS_Data_draw_params_y[instance];
        rect_tl = 0;
      }
    }
    else if (ROTATE_FACTOR[instance] == 135) {
      if (MIRROR_ENABLE[instance]) { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance] - rect_w - 1;
        rect_y = PS_Data_draw_params_y[instance] - rect_h - 1;
        rect_br = 0;
      }
      else { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance] - rect_w - 1;
        rect_y = PS_Data_draw_params_y[instance];
        rect_tr = 0;
      }
    }
    else /*if (ROTATE_FACTOR[instance] == 225)*/ {
      if (MIRROR_ENABLE[instance]) { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance];
        rect_y = PS_Data_draw_params_y[instance] - rect_h - 1;
        rect_bl = 0;
      }
      else { // OK
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance] - rect_w - 1;
        rect_y = PS_Data_draw_params_y[instance] - rect_h - 1;
        rect_br = 0;
      }
    }

    // Draw rect
    fill(C_PS_DATA_RECT_FILL);
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(C_PS_DATA_RECT_STROKE);
    strokeWeight(W_PS_DATA_RECT_STROKE);
    rect(rect_x, rect_y, rect_w, rect_h, rect_tl, rect_tr, rect_br, rect_bl);

    // Sets the color used to draw lines and borders around shapes.
    fill(C_PS_DATA_RECT_TEXT);
    stroke(C_PS_DATA_RECT_TEXT);
    textAlign(LEFT, BASELINE);
    final int str_x = rect_x + TEXT_MARGIN;
    final int str_y = rect_y + TEXT_MARGIN - 1;
    int cnt = 0;
    for( String string:strings) {
      text(string, str_x, str_y + FONT_HEIGHT * (1 + cnt++));
    }
  } // End of draw_params()
  
  // Draw points of parsed Data buffer
  void draw_points(int instance)
  {
    int distance;
    int mi_x, mi_y;
    int point_x_curr, point_y_curr;
    int point_size_curr = PS_DATA_POINT_WEIGHT; // Set weight of point rect
    color point_color_curr = C_PS_DATA_POINT;
    boolean point_is_contains_curr;
    int point_x_prev = MIN_INT, point_y_prev = MIN_INT;
    int point_size_prev = PS_DATA_POINT_WEIGHT; // Set weight of point rect
    boolean point_is_contains_prev = false;
    color point_color_prev = C_PS_DATA_POINT;
    color line_color = C_PS_DATA_LINE;
    final int point_line_color_HSB_max_const = PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):Enter");

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):number_of_points="+number_of_points[instance]);

    // Sets the weight used to draw lines and rect borders around shapes.
    strokeWeight(W_PS_DATA_LINE);

    // Check pulse width exist than color mode set to HSB.
    if (data_content[instance] != 4) {
      colorMode(HSB, point_line_color_HSB_max_const);
    }

    if (time_stamp_reseted[instance]) {
      ROI_Data_handle.clear_objects(instance);
      time_stamp_reseted[instance] = false;
    }
    ROI_Data_handle.clear_points(instance);
    ROI_Data_handle.set_time_stamp(instance, time_stamp[instance]);
    ROI_Data_handle.set_angle_step(instance, scan_angle_step[instance]);

    for (int j = 0; j < number_of_points[instance]; j++) {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distance = this.distances[instance][j];
      mi_x = this.mi_x[instance][j];
      mi_y = this.mi_y[instance][j];
      point_x_curr = this.scr_x[instance][j];
      point_y_curr = this.scr_y[instance][j];

      if (point_x_curr == MIN_INT && point_y_curr == MIN_INT) {
        //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + "No echo");
        point_x_prev = MIN_INT;
        point_y_prev = MIN_INT;
        point_color_prev = -1;
        point_is_contains_prev = false;
      }
      else {
        /*
        int region_index = Regions_check_point_contains(instance, mi_x, mi_y);
        if (region_index >= 0) {
          ROI_Data_handle.add_point(instance, region_index, mi_x, mi_y, point_x_curr, point_y_curr);
          point_is_contains_curr = true;
          if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):"+Regions_handle.get_region_name(instance, region_index)+":x="+mi_x+",y="+mi_y);
        }
        */
        LinkedList<Integer> region_indexes = Regions_handle.get_region_indexes_contains_point(instance, mi_x, mi_y);
        if (region_indexes.size() > 0) {
          ROI_Data_handle.add_point(instance, region_indexes, mi_x, mi_y, point_x_curr, point_y_curr);
          point_is_contains_curr = true;
          if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):"+Regions_handle.get_region_name(instance, region_indexes.get(0))+":x="+mi_x+",y="+mi_y);
        }
        else {
          point_is_contains_curr = false;
        }

        if (point_is_contains_curr
            ||
            PS_Data_draw_points_all_enabled) {
          // Check pulse width exist
          if (data_content[instance] != 4) {
            point_color_curr = pulse_width_color[instance][j];
            if(point_color_prev != -1) {
              line_color = (point_color_curr + point_color_prev) / 2;
            }
          }
          else {
            point_color_curr = C_PS_DATA_POINT;
            point_color_prev = C_PS_DATA_POINT;
            line_color = C_PS_DATA_LINE;
          }

          if (Bubble_Info_enabled) {
            final int mouse_over_range =
              (ZOOM_FACTOR[instance] < 50)
              ?
              (PS_DATA_POINT_WEIGHT + (50 - ZOOM_FACTOR[instance]) / 10)
              :
              PS_DATA_POINT_WEIGHT; // Range for mouse over point rect. Adjust mouse over range by ZOOM_FACTOR.
            final int mouse_over_x_min = mouseX - mouse_over_range;
            final int mouse_over_x_max = mouseX + mouse_over_range;
            final int mouse_over_y_min = mouseY - mouse_over_range;
            final int mouse_over_y_max = mouseY + mouse_over_range;

            // Check mouse pointer over point rect.
            if( BUBBLE_INFO_AVAILABLE != true
                &&
                (point_x_curr > mouse_over_x_min && point_x_curr < mouse_over_x_max)
                &&
                (point_y_curr > mouse_over_y_min && point_y_curr < mouse_over_y_max)
              ) {
              //println("point=" + j + ",distance=" + (float(distance)/10000.0) + "m(" + (mi_x/10000.0) + "," + (mi_y/10000.0) + ")" + ",pulse width=" + pulse_width[instance][j]);
              BUBBLE_INFO_AVAILABLE = true;
              BUBBLE_INFO_POINT = j;
              BUBBLE_INFO_DISTANCE = float(distance/10)/1000.0;
              BUBBLE_INFO_COR_X = float(mi_x/10)/1000.0;
              BUBBLE_INFO_COR_Y = float(mi_y/10)/1000.0;
              BUBBLE_INFO_BOX_X = point_x_curr;
              BUBBLE_INFO_BOX_Y = point_y_curr;
              BUBBLE_INFO_ANGLE = float(int(angle_degree[instance][j]*100.0))/100.0;
              BUBBLE_INFO_PULSE_WIDTH = pulse_width[instance][j];
              point_size_curr = BUBBLE_INFO_POINT_WH;
            }
            else {
              // Reset width and height point rect
              point_size_curr = PS_DATA_POINT_WEIGHT;
            }
          }
        }

        // Draw first a previous point if possible.
        if (point_x_prev != MIN_INT && point_y_prev != MIN_INT) {
          if (point_is_contains_prev
              ||
              PS_Data_draw_points_all_enabled) {
            if (PS_Data_draw_points_with_line
                &&
                ( point_is_contains_curr
                  ||
                  PS_Data_draw_points_all_enabled)) {
              fill(line_color);
              stroke(line_color);
              // Sets the weight used to draw line.
              strokeWeight(W_PS_DATA_LINE);
              line(point_x_prev, point_y_prev, point_x_curr, point_y_curr);
            }
            fill(point_color_prev);
            stroke(point_color_prev);
            // Sets the weight used to rect borders around shapes.
            strokeWeight(1);
            //point(point_x_prev + DRAW_OFFSET_X[instance], point_y_prev + DRAW_OFFSET_Y[instance]);
            rect( point_x_prev - point_size_prev / 2,
                  point_y_prev - point_size_prev / 2,
                  point_size_prev,
                  point_size_prev );
          }
        }

        // And than, Draw current point if possible.
        if (point_is_contains_curr
            ||
            PS_Data_draw_points_all_enabled) {
          fill(point_color_curr);
          stroke(point_color_curr);
          // Sets the weight used to rect borders around shapes.
          strokeWeight(1);
          //point(point_x_curr + DRAW_OFFSET_X[instance], point_y_curr + DRAW_OFFSET_Y[instance]);
          rect( point_x_curr - point_size_curr / 2,
                point_y_curr - point_size_curr / 2,
                point_size_curr,
                point_size_curr );
          // Save point data for drawing line between previous and current points. 
          point_x_prev = point_x_curr;
          point_y_prev = point_y_curr;
          point_color_prev = point_color_curr;
          point_size_prev = point_size_curr;
          point_is_contains_prev = point_is_contains_curr;
        }
        else {
          point_x_prev = MIN_INT;
          point_y_prev = MIN_INT;
          point_color_prev = -1;
          point_is_contains_prev = false;
        }
      }
    } // End of for (int j = 0; j < number_of_points[instance]; j++)

    ROI_Data_handle.detect_objects(instance);

    // Check pulse width exist than color mode back to RGB.
    if (data_content[instance] != 4) {
      colorMode(RGB, 255);
    }

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):Exit");
  } // End of draw_points()
  
  void draw_error(int instance, String message)
  {
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_error("+instance+"):");

    // Sets the color used to draw lines and borders around shapes.
    fill(C_PS_DATA_ERR_TEXT);
    stroke(C_PS_DATA_ERR_TEXT);
    textSize(FONT_HEIGHT*2);
    textAlign(CENTER, CENTER);
    text( message,
          Grid_scr_x_min[instance],
          Grid_scr_y_min[instance],
          Grid_scr_x_max[instance] - Grid_scr_x_min[instance],
          Grid_scr_y_max[instance] - Grid_scr_y_min[instance]);
  }
}
