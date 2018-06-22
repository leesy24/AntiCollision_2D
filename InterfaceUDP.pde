//final static boolean PRINT_INTERFACES_UDP_ALL_DBG = true;
final static boolean PRINT_INTERFACES_UDP_ALL_DBG = false;
final static boolean PRINT_INTERFACES_UDP_ALL_ERR = true;
//final static boolean PRINT_INTERFACES_UDP_ALL_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_SETUP_DBG = true;
final static boolean PRINT_INTERFACES_UDP_SETUP_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_SETUP_ERR = true;
final static boolean PRINT_INTERFACES_UDP_SETUP_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_RESET_DBG = true;
final static boolean PRINT_INTERFACES_UDP_RESET_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_RESET_ERR = true;
final static boolean PRINT_INTERFACES_UDP_RESET_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_OPEN_DBG = true;
final static boolean PRINT_INTERFACES_UDP_OPEN_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_OPEN_ERR = true;
final static boolean PRINT_INTERFACES_UDP_OPEN_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_CLOSE_DBG = true;
final static boolean PRINT_INTERFACES_UDP_CLOSE_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_CLOSE_ERR = true;
final static boolean PRINT_INTERFACES_UDP_CLOSE_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_SEND_DBG = true;
final static boolean PRINT_INTERFACES_UDP_SEND_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_SEND_ERR = true;
final static boolean PRINT_INTERFACES_UDP_SEND_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_RECV_DBG = true;
final static boolean PRINT_INTERFACES_UDP_P_RECV_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_P_RECV_ERR = true;
final static boolean PRINT_INTERFACES_UDP_P_RECV_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_P_RECV_DBG = true;
final static boolean PRINT_INTERFACES_UDP_RECV_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_RECV_IN_DBG = true;
final static boolean PRINT_INTERFACES_UDP_RECV_IN_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_RECV_ERR = true;
final static boolean PRINT_INTERFACES_UDP_RECV_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_LOAD_DBG = true;
final static boolean PRINT_INTERFACES_UDP_LOAD_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_LOAD_ERR = true;
final static boolean PRINT_INTERFACES_UDP_LOAD_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_SET_DBG = true;
final static boolean PRINT_INTERFACES_UDP_SET_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_SET_ERR = true;
final static boolean PRINT_INTERFACES_UDP_SET_ERR = false;
//final static boolean PRINT_INTERFACES_UDP_GET_DBG = true;
final static boolean PRINT_INTERFACES_UDP_GET_DBG = false;
//final static boolean PRINT_INTERFACES_UDP_GET_ERR = true;
final static boolean PRINT_INTERFACES_UDP_GET_ERR = false;

static boolean UDP_get_take_time_enable = true;

final int INTERFACES_UDP_INSTANCE_MAX = 2;
static Interfaces_UDP Interfaces_UDP_handle = null;

void Interfaces_UDP_setup(int local_port)
{
  if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_SETUP_DBG) println("Interfaces_UDP_setup():");

  if(Interfaces_UDP_handle != null)
  {
    if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_SETUP_DBG) println("Interfaces_UDP_setup():Interfaces_UDP_handle already setup.");
    return;
  }

  //Title += "(" + UDP_remote_ip + ":" + UDP_remote_port;
  Title += ":" + local_port;
  Title += ")";

  Comm_UDP_setup(local_port);

  Interfaces_UDP_handle = new Interfaces_UDP();
  if(Interfaces_UDP_handle == null)
  {
    if(PRINT_INTERFACES_UDP_SETUP_ERR) println("Interfaces_UDP_setup():Interfaces_UDP_handle=null");
    Comm_UDP_reset();
    return;
  }
  Interfaces_UDP_handle.local_port = local_port;
}

void Interfaces_UDP_reset()
{
  if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_RESET_DBG) println("Interfaces_UDP_reset():");

  Comm_UDP_reset();

  if(Interfaces_UDP_handle == null)
  {
    if(PRINT_INTERFACES_UDP_RESET_ERR) println("Interfaces_UDP_reset():Interfaces_UDP_handle already reset.");
    return;
  }
  Interfaces_UDP_handle = null;
}

void Interfaces_UDP_recv(int instance, byte[] data)
{
  if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_RECV_DBG || PRINT_INTERFACES_UDP_RECV_IN_DBG) println("Interfaces_UDP_recv(" + instance + "):data.length=" + data.length);
  if(Interfaces_UDP_handle == null)
  {
    if(PRINT_INTERFACES_UDP_RECV_ERR) println("Interfaces_UDP_recv():Interfaces_UDP_handle=null");
    return;
  }
  Interfaces_UDP_handle.recv(instance, data);
} 

class Interfaces_UDP {
  final static int PS_CMD_BUFFER_MAX = 8*1024;

  final static int PS_CMD_STATE_NONE = 0;
  final static int PS_CMD_STATE_SENT = 1;
  final static int PS_CMD_STATE_RECEIVED = 2;
  final static int PS_CMD_STATE_ERROR = 3;

  int local_port;

  int[] PS_CMD_state = new int[INTERFACES_UDP_INSTANCE_MAX];

  boolean[] PS_CMD_SCAN_DONE = new boolean[INTERFACES_UDP_INSTANCE_MAX];

  byte[][] recv_in_buf = new byte[INTERFACES_UDP_INSTANCE_MAX][];
  int[] recv_live_total = new int[INTERFACES_UDP_INSTANCE_MAX]; // Init. live total received data bytes.
  boolean[] recv_length_received = new boolean[INTERFACES_UDP_INSTANCE_MAX]; // Init. state machine for getting length data of UDP data format.
  int[] recv_length = new int[INTERFACES_UDP_INSTANCE_MAX]; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
  int[] recv_in_length = new int[INTERFACES_UDP_INSTANCE_MAX];
  int[] comm_timeout = new int[INTERFACES_UDP_INSTANCE_MAX];
  int[] comm_start_time = new int[INTERFACES_UDP_INSTANCE_MAX];
  int[] comm_take_time = new int[INTERFACES_UDP_INSTANCE_MAX];

  String[] str_err_last = new String[INTERFACES_UDP_INSTANCE_MAX];

  String[] ip = new String[INTERFACES_UDP_INSTANCE_MAX];
  int[] port = new int[INTERFACES_UDP_INSTANCE_MAX];

  boolean[] instance_opened = new boolean[INTERFACES_UDP_INSTANCE_MAX];

  Interfaces_UDP()
  {
    // Init. handle_opened arrary.
    for (int i = 0; i < INTERFACES_UDP_INSTANCE_MAX; i++)
    {
      PS_CMD_state[i] = PS_CMD_STATE_NONE;

      PS_CMD_SCAN_DONE[i] = true;
      //PS_CMD_SCAN_DONE[i] = false;

      recv_in_buf[i] = null;
      recv_live_total[i] = 0; // Init. live total received data bytes.
      recv_length_received[i] = false; // Init. state machine for getting length data of UDP data format.
      recv_length[i] = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
      recv_in_length[i] = 0;
      comm_timeout[i] = 0;
      comm_start_time[i] = 0;
      comm_take_time[i] = -1;

      str_err_last[i] = null;

      ip[i] = null;
      port[i] = -1;

      instance_opened[i] = false;
    }
  }

  public int open(int instance, String remote_ip, int remote_port)
  {
    if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_OPEN_DBG) println("Interfaces_UDP:open("+instance+"):remote_ip="+remote_ip+",remote_port="+remote_port);
    if(Comm_UDP_handle == null)
    {
      if(PRINT_INTERFACES_UDP_OPEN_ERR) println("Interfaces_UDP:open("+instance+"):Comm_UDP_handle=null");
      return -1;
    }
    if(instance >= INTERFACES_UDP_INSTANCE_MAX)
    {
      println("Interfaces_UDP:open("+instance+"):instance exceed MAX.");
      return -1;
    }
    if(instance_opened[instance] != false)
    {
      println("Interfaces_UDP:open("+instance+"):instance already opended.");
      return -1;
    }

    Comm_UDP_handle.open(instance, remote_ip, remote_port);

    ip[instance] = remote_ip;
    port[instance] = remote_port;
    PS_CMD_SCAN_DONE[instance] = true;
    //PS_CMD_SCAN_DONE[instance] = false;

    instance_opened[instance] = true;
    return 0;
  }

  public int close(int instance)
  {
    if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_CLOSE_DBG) println("Interfaces_UDP:close("+instance+"):");
    if(UDP_handle == null)
    {
      if(PRINT_INTERFACES_UDP_CLOSE_ERR) println("Interfaces_UDP:close("+instance+"):UDP_handle=null");
      return -1;
    }
    if(instance >= INTERFACES_UDP_INSTANCE_MAX)
    {
      println("Interfaces_UDP:close("+instance+"):instance exceed MAX.");
      return -1;
    }
    if(instance_opened[instance] != true)
    {
      println("Interfaces_UDP:close("+instance+"):instance already closed.");
      return -1;
    }

    Comm_UDP_handle.close(instance);

    ip[instance] = null;
    port[instance] = -1;
    instance_opened[instance] = false;
    return 0;
  }

  public String get_error(int instance)
  {
    if (PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_GET_DBG) println("Interfaces_UDP:get_error("+instance+"):str_err_last="+str_err_last[instance]);
    return str_err_last[instance];
  }

  public int get_take_time(int instance)
  {
    if (PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_GET_DBG) println("Interfaces_UDP:get_take_time("+instance+"):comm_take_time="+comm_take_time[instance]);
    return comm_take_time[instance];
  }

  public String get_remote_ip(int instance)
  {
    if (PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_GET_DBG) println("Interfaces_UDP:get_remote_ip("+instance+"):ip="+ip[instance]);
    return ip[instance];
  }

  public int get_remote_port(int instance)
  {
    if (PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_GET_DBG) println("Interfaces_UDP:get_remote_port("+instance+"):port="+port[instance]);
    return port[instance];
  }

  public boolean load(int instance)
  {
    int err;

    if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_LOAD_DBG) println("Interfaces_UDP:load("+instance+"):");

/*
    if(Interfaces_UDP_handle == null) {
      Interfaces_UDP_setup(local_port);
      if(Interfaces_UDP_handle == null) {
        str_err_last[instance] = "Error: UDP local port open error! " + local_port;
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println(str_err_last[instance]);
        return false;
      }
    }
*/

    if(PS_CMD_SCAN_DONE[instance] == false) {
      err = PS_CMD_perform_SCAN(instance, 1);
      if(err < 0) {
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println("PS_perform_SCAN() error! " + err);
      }
      else if(err > 0) {
        //println("PS_perform_SCAN() pending! " + err);
      }
      else {
        //println("PS_perform_SCAN() ok! ");
        PS_CMD_SCAN_DONE[instance] = true;
      }
      return false;
    }
    else {
      err = PS_CMD_perform_GSCN(instance, 0);
      if(err < 0) {
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println("PS_perform_GSCN() error! " + err);
        return false;
      }
      else if(err > 0) {
        //println("PS_perform_GSCN() pending! " + err);
        return false;
      }
      else {
        str_err_last[instance] = null;
        //if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_P_RECV_DBG) println("Interfaces_UDP:load("+instance+"):recv_in_buf="+recv_in_buf[instance]);
        //if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_P_RECV_DBG) println("Interfaces_UDP:load("+instance+"):PS_Data_buf="+PS_Data_buf[instance]);
        PS_Data_buf[instance] = recv_in_buf[instance];
        //println("PS_perform_GSCN() ok! ");
        return true;
      }
    }
  }

  public void set_comm_timeout(int instance, int msec)
  {
    comm_timeout[instance] = msec;
    if (PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_SET_DBG) println("Interfaces_UDP:set_comm_timeout("+instance+"):comm_timeout = " + comm_timeout[instance] + " msec(s)");
  }

  public void send(int instance, byte[] buf)
  {
    if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_SEND_DBG) println("Interfaces_UDP:send("+instance+"):buf.length="+buf.length);
    if(Interfaces_UDP_handle == null)
    {
      if(PRINT_INTERFACES_UDP_SEND_ERR) println("Interfaces_UDP:send() Interfaces_UDP_handle=null");
      return;
    }

    // Init & Save CMD start end time
    comm_take_time[instance] = -1;
    comm_start_time[instance] = millis();
    Comm_UDP_handle.send(instance, buf);
  }

  public void prepare_recv(int instance, int buf_size)
  {
    if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_P_RECV_DBG) println("Interfaces_UDP:prepare_recv("+instance+"):buf_size="+buf_size);

    //recv_in_buf[instance] = new byte[buf_size * 2];
    recv_in_buf[instance] = new byte[buf_size];
    //if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_P_RECV_DBG) println("Interfaces_UDP:prepare_recv("+instance+"):recv_in_buf="+recv_in_buf[instance]);
    if (recv_in_buf[instance] == null)
    {
      if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_ALL_ERR || PRINT_INTERFACES_UDP_P_RECV_ERR) println("Interfaces_UDP:prepare_recv("+instance+"):recv_in_buf["+instance+"]=null");
    }

    recv_live_total[instance] = 0; // Init. total received data.
    recv_length_received[instance] = false; // Init. state machine for getting length data of UDP data format.
    recv_length[instance] = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
  }

  public void recv(int instance, byte[] data)
  {
    if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_RECV_DBG || PRINT_INTERFACES_UDP_RECV_IN_DBG) println("Interfaces_UDP:recv("+instance+"):data.length=" + data.length);
    if (data.length > PS_CMD_BUFFER_MAX)
    {
      if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_ALL_ERR || PRINT_INTERFACES_UDP_RECV_ERR) println("Interfaces_UDP:recv("+instance+"):data.length max error! " + data.length);
    }
    try {
      if(PS_CMD_state[instance] == PS_CMD_STATE_SENT) {
        int inLength = 0;  // Bytes length by readBytes()
    
        inLength = data.length;
        if(recv_live_total[instance] + inLength > recv_in_buf[instance].length) {
          inLength = recv_in_buf[instance].length - recv_live_total[instance];
        }
        arrayCopy(data, 0, recv_in_buf[instance], recv_live_total[instance], inLength);
        recv_live_total[instance] += inLength;
        if (PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_RECV_DBG) println("Read bytes and total! " + inLength + "," + recv_live_total[instance]);
    
        // If state machine is getting length data.
        if (recv_length_received[instance] == false) {
          // If total received data is enough to get length data.
          if (recv_live_total[instance] >= 8) {
            // Get length data from network endians data.
            recv_length[instance] = get_int32_bytes(recv_in_buf[instance], 4);
            if (PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_RECV_DBG) println("Read format Length = " + recv_length[instance]);
            if ((recv_length[instance] > recv_in_buf[instance].length - 12) ||
                (recv_length[instance] < 4)) {
              str_err_last[instance] = "Error: UDP read protocol length error! " + recv_length[instance] + "," + inLength + "," + recv_live_total[instance]/* + "," + recv_in_buf*/;
              if (PRINT_INTERFACES_UDP_RECV_ERR) println(str_err_last[instance]);
              //printArray(recv_in_buf);
              //printArray(data);
              PS_CMD_state[instance] = PS_CMD_STATE_ERROR;
              return;
            }
            recv_length_received[instance] = true; // Set state machine to other.
          }
        }
        
        // Check received all data
        if(recv_live_total[instance] >= recv_length[instance] + 12) {
          recv_in_length[instance] = recv_length[instance] + 12;
          //println("Read SCAN state changed to PS_CMD_STATE_RECEIVED! " + recv_live_total + "," + recv_length);
          PS_CMD_state[instance] = PS_CMD_STATE_RECEIVED;

          if(UDP_get_take_time_enable)
          {
            // Save CMD take time
            comm_take_time[instance] = millis();
            // Check millis wrap around
            if(comm_take_time[instance] < comm_start_time[instance])
              comm_take_time[instance] = MAX_INT - comm_start_time[instance] + comm_take_time[instance];
            else
              comm_take_time[instance] = comm_take_time[instance] - comm_start_time[instance];
            if (PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_RECV_DBG) println("Read comm_take_time=" + comm_take_time[instance]);
          }

          return;
        }
      }
    }
    catch (Exception e) {
      str_err_last[instance] = "Error: Interfaces_UDP_recv() error! " + e;
      if (PRINT_INTERFACES_UDP_RECV_ERR) println(str_err_last[instance]);
    }
  } 

  byte[] PS_CMD_make_cmd(String cmd, int param)
  {
    byte[] buf = new byte[16];

    //if(PRINT_INTERFACES_UDP_ALL_DBG || PRINT_INTERFACES_UDP_P_RECV_DBG) println("Interfaces_UDP:PS_CMD_make_cmd():buf_size="+buf_size);

    // Set function code
    set_str_bytes(buf, 0, cmd);
    // Set Data bufffer length 4
    set_int32_bytes(buf, 4, 4);
    // Set Scan on(1)
    set_int32_bytes(buf, 8, param);
    // Set CRC
    set_int32_bytes(buf, 12, get_crc32(buf, 0, 12));

    return buf;
  }

  private int PS_CMD_perform_SCAN(int instance, int on)
  {
    byte[] outBuffer;

    if(PS_CMD_state[instance] == PS_CMD_STATE_NONE) {
      // Make command buffer
      outBuffer = PS_CMD_make_cmd("SCAN", on);
      // Prepare read
      prepare_recv(instance, 16);
      // Prepare UDP CMD state
      PS_CMD_state[instance] = PS_CMD_STATE_SENT;
      // Write buffer
      send(instance, outBuffer);
      return PS_CMD_state[instance];
    }
    else if(PS_CMD_state[instance] == PS_CMD_STATE_SENT) {
      int time_dif;
      // Check time out
      time_dif = millis();
      // Check millis wrap around
      if(time_dif < comm_start_time[instance])
        time_dif = MAX_INT - comm_start_time[instance] + time_dif;
      else
        time_dif = time_dif - comm_start_time[instance];
      if(time_dif > comm_timeout[instance]) {
        PS_CMD_state[instance] = PS_CMD_STATE_NONE;
        str_err_last[instance] = "Error: UDP SCAN timeout! " + recv_in_length[instance] + "," + recv_live_total[instance];
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println(str_err_last[instance]);
        return -1;
      }
      return PS_CMD_state[instance];
    }
    else if(PS_CMD_state[instance] == PS_CMD_STATE_RECEIVED) {
      String func;
      int crc, crc_c;

      // Check CRC
      crc = get_int32_bytes(recv_in_buf[instance], recv_in_length[instance] - 4);
      crc_c = get_crc32(recv_in_buf[instance], 0, recv_in_length[instance] - 4);
      if(crc != crc_c) {
        PS_CMD_state[instance] = PS_CMD_STATE_NONE;
        str_err_last[instance] = "Error: UDP SCAN CRC error! " + crc + "," + crc_c + "," + recv_in_length[instance] + "," + recv_live_total[instance];
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println(str_err_last[instance]);
        return -1;
      }
      // Check function code
      func = get_str_bytes(recv_in_buf[instance], 0, 4);
      if(func.equals("SCAN") == false) {
        // Get error code and return
        int err = get_int32_bytes(recv_in_buf[instance], 8);
        PS_CMD_state[instance] = PS_CMD_STATE_NONE;
        str_err_last[instance] = "Error: UDP SCAN error return! " + err;
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println(str_err_last[instance]);
        // Get error code and return
        return err;
      }
      PS_CMD_state[instance] = PS_CMD_STATE_NONE;
      return 0;
    }
    else if(PS_CMD_state[instance] == PS_CMD_STATE_ERROR) {
      PS_CMD_state[instance] = PS_CMD_STATE_NONE;
      return -1;
    }

    return PS_CMD_state[instance];
  }

  private int PS_CMD_perform_GSCN(int instance, int scan_number)
  {
    byte[] outBuffer;

    if(PS_CMD_state[instance] == PS_CMD_STATE_NONE) {
      // Make command buffer
      outBuffer = PS_CMD_make_cmd("GSCN", scan_number);
      // Prepare read
      prepare_recv(instance, PS_CMD_BUFFER_MAX);
      // Flush buffer
      // Prepare UDP CMD state
      PS_CMD_state[instance] = PS_CMD_STATE_SENT;
      // Write buffer
      send(instance, outBuffer);
      return PS_CMD_state[instance];
    }
    else if(PS_CMD_state[instance] == PS_CMD_STATE_SENT) {
      int time_dif;
      // Check time out
      time_dif = millis();
      // Check millis wrap around
      if(time_dif < comm_start_time[instance])
        time_dif = MAX_INT - comm_start_time[instance] + time_dif;
      else
        time_dif = time_dif - comm_start_time[instance];
      if(time_dif > comm_timeout[instance]) {
        str_err_last[instance] = "Error: UDP GSCN timeout! " + recv_in_length[instance] + "," + recv_live_total[instance];
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println(str_err_last[instance]);
        PS_CMD_state[instance] = PS_CMD_STATE_NONE;
        return -1;
      }
      return PS_CMD_state[instance];
    }
    else if(PS_CMD_state[instance] == PS_CMD_STATE_RECEIVED) {
      String func;
      int crc, crc_c;

      // Check CRC
      crc = get_int32_bytes(recv_in_buf[instance], recv_in_length[instance] - 4);
      crc_c = get_crc32(recv_in_buf[instance], 0, recv_in_length[instance] - 4);
      if(crc != crc_c) {
        PS_CMD_state[instance] = PS_CMD_STATE_NONE;
        str_err_last[instance] = "Error: UDP GSCN CRC error! " + crc + "," + crc_c + "," + recv_in_length[instance] + "," + recv_live_total[instance];
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println(str_err_last[instance]);
        return -1;
      }
      // Check function code
      func = get_str_bytes(recv_in_buf[instance], 0, 4);
      if(func.equals("GSCN") == false) {
        // Get error code and return
        int err = get_int32_bytes(recv_in_buf[instance], 8);
        PS_CMD_state[instance] = PS_CMD_STATE_NONE;
        str_err_last[instance] = "Error: UDP GSCN error return! " + err;
        if(PRINT_INTERFACES_UDP_LOAD_ERR) println(str_err_last[instance]);
        // Get error code and return
        return err;
      }
      PS_CMD_state[instance] = PS_CMD_STATE_NONE;
      return 0;
    }
    else if(PS_CMD_state[instance] == PS_CMD_STATE_ERROR) {
      PS_CMD_state[instance] = PS_CMD_STATE_NONE;
      return -1;
    }

    return PS_CMD_state[instance];
  }
}
