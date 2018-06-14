import hypermedia.net.*;

//final static boolean PRINT_SN_WRITE_DBG = true; 
final static boolean PRINT_SN_WRITE_DBG = false; 
//final static boolean PRINT_SN_WRITE_ERR = true; 
final static boolean PRINT_SN_WRITE_ERR = false; 
//final static boolean PRINT_SN_READ_DBG = true; 
final static boolean PRINT_SN_READ_DBG = false; 
//final static boolean PRINT_SN_READ_ERR = true; 
final static boolean PRINT_SN_READ_ERR = false; 
//final static boolean PRINT_SN_LOAD_DBG = true; 
final static boolean PRINT_SN_LOAD_DBG = false; 
//final static boolean PRINT_SN_LOAD_ERR = true; 
final static boolean PRINT_SN_LOAD_ERR = false; 

static boolean SN_get_take_time_enable = true; 
static boolean SN_get_src_ip_port_enable = false;

final static int SN_PS_MAX_BUFFER = 8*1024;

UDP SN_handle = null;  // The handle of UDP

String SN_local_ip = "localhost";
int SN_serial_number = 886;
String SN_remote_ip = "localhost";
int SN_remote_port = 1024;

final int SN_CMD_STATE_NONE = 0;
final int SN_CMD_STATE_SENT = 1;
final int SN_CMD_STATE_RECEIVED = 2;
final int SN_CMD_STATE_ERROR = 3;

byte[] SN_inBuffer = null;
int SN_inLength = 0;  // Bytes length by readBytes()
int SN_total = 0; // Init. total received data.
int SN_state = 0; // Init. state machine for getting length data of UDP data format.
int SN_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
int SN_CMD_inLength = 0;
int SN_CMD_state = SN_CMD_STATE_NONE;
int SN_CMD_timeout = 0;
int SN_CMD_start_time;
int SN_CMD_take_time = -1;
String SN_CMD_src_ip = null;
int SN_CMD_src_port = -1;
static String SN_str_err_last = null;

boolean SN_SCAN_DONE = false;

void interface_SN_reset()
{
  if(PRINT_SN_LOAD_DBG) println("SN reset! " + SN_serial_number + "," + SN_remote_ip + "," + SN_remote_port);
  // Check UDP config changed
  if(SN_handle != null) {
    SN_handle.close();
    SN_handle = null;
  }
  SN_inBuffer = null;
  SN_inLength = 0;  // Bytes length by readBytes()
  SN_total = 0; // Init. total received data.
  SN_state = 0; // Init. state machine for getting length data of UDP data format.
  SN_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
  SN_CMD_inLength = 0;
  SN_CMD_state = SN_CMD_STATE_NONE;
  SN_CMD_start_time = 0;
  SN_str_err_last = null;
}

void interface_SN_setup()
{
  int SN_local_port;

  Title += "(" + SN_serial_number;
  Title += ")";

  SN_SCAN_DONE = false;

  SN_config_timeout(1000); // timeout 1secs for UDP

  SN_local_port = 10000 + SN_serial_number;

  // Create a new datagram connection on local port
  // and wait for incomming message
  //SN_handle = new UDP(this, SN_local_port);
  SN_handle = new UDP(this, SN_local_port, SN_local_ip);
  //SN_handle.log( true );
  SN_handle.log( false );
  SN_handle.setReceiveHandler("SN_receive_event");
  SN_handle.listen( true );
}

String interface_SN_get_error()
{
  return SN_str_err_last;
}

int interface_SN_get_take_time()
{
  return SN_CMD_take_time;
}

String interface_SN_get_src_ip()
{
  return SN_CMD_src_ip;
}

int interface_SN_get_src_port()
{
  return SN_CMD_src_port;
}

boolean interface_SN_load()
{
  int err;

  if(SN_handle == null) {
    interface_SN_setup();
    if(SN_handle == null) {
      SN_str_err_last = "Error: PS SN local port open error! " + SN_serial_number;
      if(PRINT_SN_LOAD_ERR) println(SN_str_err_last);
      return false;
    }
  }

  if(SN_SCAN_DONE == false) {
    err = SN_PS_perform_SCAN(1);
    if(err < 0) {
      if(PRINT_SN_LOAD_ERR) println("PS_perform_SCAN() error! " + err);
    }
    else if(err > 0) {
      //println("PS_perform_SCAN() pending! " + err);
    }
    else {
      //println("PS_perform_SCAN() ok! ");
      SN_SCAN_DONE = true;
    }
    return false;
  }
  else {
    err = SN_PS_perform_GSCN(0);
    if(err < 0) {
      if(PRINT_SN_LOAD_ERR) println("PS_perform_GSCN() error! " + err);
      return false;
    }
    else if(err > 0) {
      //println("PS_perform_GSCN() pending! " + err);
      return false;
    }
    else {
      SN_str_err_last = null;
      data_buf = SN_inBuffer;
      //println("PS_perform_GSCN() ok! ");
      return true;
    }
  }
}

void SN_config_timeout(int msec)
{
  SN_CMD_timeout = msec;
  if (PRINT_SN_LOAD_DBG) println("SN_CMD_timeout = " + SN_CMD_timeout + " msec(s)");
}

void SN_write(byte[] buf)
{
  if(PRINT_SN_WRITE_DBG) println("SN_write() buf.length="+buf.length);
  if(SN_handle == null)
  {
    if(PRINT_SN_WRITE_DBG) println("SN_write() SN_handle=null");
    return;
  }
  // Init CMD source ip and port
  SN_CMD_src_ip = null;
  SN_CMD_src_port = -1;
  // Init & Save CMD start end time
  SN_CMD_take_time = -1;
  SN_CMD_start_time = millis();
  SN_handle.send(buf, SN_remote_ip, SN_remote_port);
}

void SN_prepare_read(int buf_size)
{
  SN_inBuffer = new byte[buf_size * 2];
  SN_inLength = 0;  // Bytes length by readBytes()
  SN_total = 0; // Init. total received data.
  SN_state = 0; // Init. state machine for getting length data of UDP data format.
  SN_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
}

void SN_receive_event(byte[] data, String ip, int port)
{
  try {
    if(PRINT_SN_READ_DBG) println("SN_receive_event data.length=" + data.length);
    if(SN_CMD_state == SN_CMD_STATE_SENT) {
      int inLength = 0;  // Bytes length by readBytes()
  
      inLength = data.length;
      if(SN_total + inLength > SN_inBuffer.length) {
        inLength = SN_inBuffer.length - SN_total;
      }
      arrayCopy(data, 0, SN_inBuffer, SN_total, inLength);
      SN_total += inLength;
      if (PRINT_SN_READ_DBG) println("Read bytes and total! " + inLength + "," + SN_total);
  
      // If state machine is getting length data.
      if (SN_state == 0) {
        // If total received data is enough to get length data.
        if (SN_total >= 8) {
          // Get length data from network endians data.
          SN_len = get_int32_bytes(SN_inBuffer, 4);
          if (PRINT_SN_READ_DBG) println("Read format Length = " + SN_len);
          if ((SN_len > SN_inBuffer.length - 12) ||
              (SN_len < 4)) {
            SN_str_err_last = "Error: PS SN read protocol length error! " + SN_len + "," + inLength + "," + SN_total/* + "," + SN_inBuffer*/;
            if (PRINT_SN_READ_ERR) println(SN_str_err_last);
            //printArray(SN_inBuffer);
            //printArray(data);
            SN_CMD_state = SN_CMD_STATE_ERROR;
            return;
          }
          SN_state = 1; // Set state machine to other.
        }
      }
      
      // Check received all data
      if(SN_total >= SN_len + 12) {
        SN_CMD_inLength = SN_len + 12;
        //println("Read SCAN state changed to SN_CMD_STATE_RECEIVED! " + SN_total + "," + SN_len);
        SN_CMD_state = SN_CMD_STATE_RECEIVED;

        if(SN_get_src_ip_port_enable)
        {
          SN_CMD_src_ip = ip;
          SN_CMD_src_port = port;
        }

        if(SN_get_take_time_enable)
        {
          // Save CMD take time
          SN_CMD_take_time = millis();
          // Check millis wrap around
          if(SN_CMD_take_time < SN_CMD_start_time)
            SN_CMD_take_time = MAX_INT - SN_CMD_start_time + SN_CMD_take_time;
          else
            SN_CMD_take_time = SN_CMD_take_time - SN_CMD_start_time;
          if (PRINT_SN_READ_DBG) println("Read SN_CMD_take_time=" + SN_CMD_take_time);
        }

        return;
      }
    }
  }
  catch (Exception e) {
    SN_str_err_last = "Error: SN_receive_event() error! " + e;
    if (PRINT_SN_READ_ERR) println(SN_str_err_last);
  }
} 

byte[] SN_PS_make_cmd(String cmd, int param)
{
  byte[] buf = new byte[18];

  // Append SN(Serial Number)
  buf[0] = byte(SN_serial_number / 100);
  buf[1] = byte(SN_serial_number % 100);
  // Set function code
  set_str_bytes(buf, 2, cmd);
  // Set data_buf length 4
  set_int32_bytes(buf, 6, 4);
  // Set Scan on(1)
  set_int32_bytes(buf, 10, param);
  // Set CRC
  set_int32_bytes(buf, 14, get_crc32(buf, 2, 12));

  return buf;
}

int SN_PS_perform_SCAN(int on)
{
  byte[] outBuffer;

  if(SN_CMD_state == SN_CMD_STATE_NONE) {
    // Make command buffer
    outBuffer = SN_PS_make_cmd("SCAN", on);
    // Prepare read
    SN_prepare_read(16);
    // Prepare UDP CMD state
    SN_CMD_state = SN_CMD_STATE_SENT;
    // Write buffer
    SN_write(outBuffer);
    return SN_CMD_state;
  }
  else if(SN_CMD_state == SN_CMD_STATE_SENT) {
    int time_dif;
    // Check time out
    time_dif = millis();
    // Check millis wrap around
    if(time_dif < SN_CMD_start_time)
      time_dif = MAX_INT - SN_CMD_start_time + time_dif;
    else
      time_dif = time_dif - SN_CMD_start_time;
    if(time_dif > SN_CMD_timeout) {
      SN_CMD_state = SN_CMD_STATE_NONE;
      SN_str_err_last = "Error: PS SN SCAN timeout! " + SN_CMD_inLength + "," + SN_total;
      if(PRINT_SN_LOAD_ERR) println(SN_str_err_last);
      return -1;
    }
    return SN_CMD_state;
  }
  else if(SN_CMD_state == SN_CMD_STATE_RECEIVED) {
    String func;
    int crc, crc_c;

    // Check CRC
    crc = get_int32_bytes(SN_inBuffer, SN_CMD_inLength - 4);
    crc_c = get_crc32(SN_inBuffer, 0, SN_CMD_inLength - 4);
    if(crc != crc_c) {
      SN_CMD_state = SN_CMD_STATE_NONE;
      SN_str_err_last = "Error: PS SN SCAN CRC error! " + crc + "," + crc_c + "," + SN_CMD_inLength + "," + SN_total;
      if(PRINT_SN_LOAD_ERR) println(SN_str_err_last);
      return -1;
    }
    // Check function code
    func = get_str_bytes(SN_inBuffer, 0, 4);
    if(func.equals("SCAN") == false) {
      // Get error code and return
      int err = get_int32_bytes(SN_inBuffer, 8);
      SN_CMD_state = SN_CMD_STATE_NONE;
      SN_str_err_last = "Error: PS SN SCAN error return! " + err;
      if(PRINT_SN_LOAD_ERR) println(SN_str_err_last);
      // Get error code and return
      return err;
    }
    SN_CMD_state = SN_CMD_STATE_NONE;
    return 0;
  }
  else if(SN_CMD_state == SN_CMD_STATE_ERROR) {
    SN_CMD_state = SN_CMD_STATE_NONE;
    return -1;
  }

  return SN_CMD_state;
}

int SN_PS_perform_GSCN(int scan_number)
{
  byte[] outBuffer;

  if(SN_CMD_state == SN_CMD_STATE_NONE) {
    // Make command buffer
    outBuffer = SN_PS_make_cmd("GSCN", scan_number);
    // Prepare read
    SN_prepare_read(SN_PS_MAX_BUFFER);
    // Flush buffer
    // Prepare UDP CMD state
    SN_CMD_state = SN_CMD_STATE_SENT;
    // Write buffer
    SN_write(outBuffer);
    return SN_CMD_state;
  }
  else if(SN_CMD_state == SN_CMD_STATE_SENT) {
    int time_dif;
    // Check time out
    time_dif = millis();
    // Check millis wrap around
    if(time_dif < SN_CMD_start_time)
      time_dif = MAX_INT - SN_CMD_start_time + time_dif;
    else
      time_dif = time_dif - SN_CMD_start_time;
    if(time_dif > SN_CMD_timeout) {
      SN_str_err_last = "Error: PS SN GSCN timeout! " + SN_CMD_inLength + "," + SN_total;
      if(PRINT_SN_LOAD_ERR) println(SN_str_err_last);
      SN_CMD_state = SN_CMD_STATE_NONE;
      return -1;
    }
    return SN_CMD_state;
  }
  else if(SN_CMD_state == SN_CMD_STATE_RECEIVED) {
    String func;
    int crc, crc_c;

    // Check CRC
    crc = get_int32_bytes(SN_inBuffer, SN_CMD_inLength - 4);
    crc_c = get_crc32(SN_inBuffer, 0, SN_CMD_inLength - 4);
    if(crc != crc_c) {
      SN_CMD_state = SN_CMD_STATE_NONE;
      SN_str_err_last = "Error: PS SN GSCN CRC error! " + crc + "," + crc_c + "," + SN_CMD_inLength + "," + SN_total;
      if(PRINT_SN_LOAD_ERR) println(SN_str_err_last);
      return -1;
    }
    // Check function code
    func = get_str_bytes(SN_inBuffer, 0, 4);
    if(func.equals("GSCN") == false) {
      // Get error code and return
      int err = get_int32_bytes(SN_inBuffer, 8);
      SN_CMD_state = SN_CMD_STATE_NONE;
      SN_str_err_last = "Error: PS SN GSCN error return! " + err;
      if(PRINT_SN_LOAD_ERR) println(SN_str_err_last);
      // Get error code and return
      return err;
    }
    SN_CMD_state = SN_CMD_STATE_NONE;
    return 0;
  }
  else if(SN_CMD_state == SN_CMD_STATE_ERROR) {
    SN_CMD_state = SN_CMD_STATE_NONE;
    return -1;
  }

  return SN_CMD_state;
}
