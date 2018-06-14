import processing.serial.*;

//final static boolean PRINT_UART_WRITE_DBG = true; 
final static boolean PRINT_UART_WRITE_DBG = false; 
//final static boolean PRINT_UART_WRITE_ERR = true; 
final static boolean PRINT_UART_WRITE_ERR = false; 
//final static boolean PRINT_UART_READ_DBG = true; 
final static boolean PRINT_UART_READ_DBG = false; 
//final static boolean PRINT_UART_READ_ERR = true; 
final static boolean PRINT_UART_READ_ERR = false; 
//final static boolean PRINT_UART_LOAD_DBG = true; 
final static boolean PRINT_UART_LOAD_DBG = false; 
//final static boolean PRINT_UART_LOAD_ERR = true; 
final static boolean PRINT_UART_LOAD_ERR = false; 

static boolean UART_get_take_time_enable = true; 

final static int UART_PS_MAX_BUFFER = 8*1024;

Serial UART_handle = null;  // The handle of UART(serial port)

String UART_port_name = "COM1"; // String: name of the port (COM1 is the default)
int UART_baud_rate = 115200; // int: 9600 is the default
char UART_parity = 'N'; // char: 'N' for none, 'E' for even, 'O' for odd, 'M' for mark, 'S' for space ('N' is the default)
int UART_data_bits = 8; // int: 8 is the default
float UART_stop_bits = 1.0; // float: 1.0, 1.5, or 2.0 (1.0 is the default)

final int UART_CMD_STATE_NONE = 0;
final int UART_CMD_STATE_SENT = 1;
final int UART_CMD_STATE_RECEIVED = 2;
final int UART_CMD_STATE_ERROR = 3;

byte[] UART_inBuffer = null;
int UART_inLength = 0;  // Bytes length by readBytes()
int UART_total = 0; // Init. total received data.
int UART_state = 0; // Init. state machine for getting length data of UDP data format.
int UART_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
int UART_CMD_inLength = 0;
int UART_CMD_state = UART_CMD_STATE_NONE;
int UART_CMD_timeout = 0;
int UART_CMD_start_time;
int UART_CMD_take_time = -1;
static String UART_str_err_last = null;

boolean UART_SCAN_DONE = false;

void interface_UART_reset()
{
  if(PRINT_UART_LOAD_DBG) println("UART reset! " + UART_port_name);
  // Check UART port config changed
  if(UART_handle != null) {
    UART_handle.stop();
    UART_handle = null;
  }
  UART_inBuffer = null;
  UART_inLength = 0;  // Bytes length by readBytes()
  UART_total = 0; // Init. total received data.
  UART_state = 0; // Init. state machine for getting length data of UDP data format.
  UART_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
  UART_CMD_inLength = 0;
  UART_CMD_state = UART_CMD_STATE_NONE;
  UART_CMD_start_time = 0;
  UART_str_err_last = null;
}

void interface_UART_setup()
{
  boolean found = false;
  int timeout;

  Title += "(" + UART_port_name + ":" + UART_baud_rate;
  Title += ":" + UART_data_bits + UART_parity;
  if(int(UART_stop_bits*10.0)%10 == 0)
    Title += int(UART_stop_bits) + ")";
  else
    Title += UART_stop_bits + ")";

  //printArray(Serial.list());

  // Check UART_port_name with the available serial ports
  for( String port : Serial.list() ) {
    if(port.equals(UART_port_name)) {
      found = true;
      break;
    }
  }
  if(!found) {
    if(PRINT_UART_LOAD_ERR) println("Can not find com port error! " + UART_port_name);
    return;
  }

  UART_SCAN_DONE = false;
  timeout = 2 * int(float(UART_PS_MAX_BUFFER) * (1.0 + float(UART_data_bits) + (UART_parity=='N'?0.0:1.0) + UART_stop_bits) / float(UART_baud_rate) * 1000.0);
  UART_config_timeout(timeout);

  try {
    // Open the port you are using at the rate you want:
    UART_handle = new Serial(this, UART_port_name, UART_baud_rate, UART_parity, UART_data_bits, UART_stop_bits);
    UART_handle.clear();
    UART_handle.buffer(1);
  }
  catch (Exception e) {
    UART_handle = null;
  }
}

String interface_UART_get_error()
{
  return UART_str_err_last;
}

int interface_UART_get_take_time()
{
  return UART_CMD_take_time;
}

boolean interface_UART_load()
{
  int err;

  if(UART_handle == null) {
    interface_UART_setup();
    if(UART_handle == null) {
      UART_str_err_last = "Error: UART port busy or not exist! " + UART_port_name;
      if(PRINT_UART_LOAD_ERR) println(UART_str_err_last);
      return false;
    }
  }

  if(UART_SCAN_DONE == false) {
    err = UART_PS_perform_SCAN(1);
    if(err < 0) {
      if(PRINT_UART_LOAD_ERR) println("PS_perform_SCAN() error! " + err);
    }
    else if(err > 0) {
      //println("PS_perform_SCAN() pending! " + err);
    }
    else {
      //println("PS_perform_SCAN() ok! ");
      UART_SCAN_DONE = true;
    }
    return false;
  }
  else {
    err = UART_PS_perform_GSCN(0);
    if(err < 0) {
      if(PRINT_UART_LOAD_ERR) println("PS_perform_GSCN() error! " + err);
      return false;
    }
    else if(err > 0) {
      //println("PS_perform_GSCN() pending! " + err);
      return false;
    }
    else {
      UART_str_err_last = null;
      data_buf = UART_inBuffer;
      //println("PS_perform_GSCN() ok! ");
      return true;
    }
  }
}

void UART_config_timeout(int msec)
{
  UART_CMD_timeout = msec;
  if (PRINT_UART_LOAD_DBG) println("UART_CMD_timeout = " + UART_CMD_timeout + " msec(s)");
}

void UART_clear()
{
  if(UART_handle == null) return;
  UART_handle.clear();
}

void UART_write(byte[] buf)
{
  if(PRINT_UART_WRITE_DBG) println("UART_write() buf.length="+buf.length);
  if(UART_handle == null)
  {
    if(PRINT_UART_WRITE_DBG) println("UDP_write() UDP_handle=null");
    return;
  }
  // Init & Save CMD start end time
  UART_CMD_take_time = -1;
  UART_CMD_start_time = millis();
  UART_handle.write(buf);
}

void UART_prepare_read(int buf_size)
{
  UART_inBuffer = new byte[buf_size * 2];
  UART_inLength = 0;  // Bytes length by readBytes()
  UART_total = 0; // Init. total received data.
  UART_state = 0; // Init. state machine for getting length data of UDP data format.
  UART_len = 0x7fffffff - 12; // 12 = 4bytes Function code + 4bytes length + 4bytes CRC on UDP data format.
}

void serialEvent(Serial p)
{
  try {
    if(PRINT_UART_READ_DBG) println("UART serialEvent");
    if(UART_CMD_state == UART_CMD_STATE_SENT) {
      byte[] data;
      int inLength = 0;  // Bytes length by readBytes()
  
      inLength = p.available();
      if(PRINT_UART_READ_DBG) println("UART serialEvent available()=" + inLength);
      if(UART_total + inLength > UART_inBuffer.length) {
        inLength = UART_inBuffer.length - UART_total;
      }
      data = p.readBytes(inLength);
      if(inLength != data.length) {
        UART_str_err_last = "Error: UART read inLength error! " + inLength + "," + data.length;
        if (PRINT_UART_READ_ERR) println(UART_str_err_last);
        UART_CMD_state = UART_CMD_STATE_ERROR;
        return;
      }
      arrayCopy(data, 0, UART_inBuffer, UART_total, inLength);
      UART_total += inLength;
      if (PRINT_UART_READ_DBG) println("Read bytes and total! " + inLength + "," + UART_total);
  
      // If state machine is getting length data.
      if (UART_state == 0) {
        // If total received data is enough to get length data.
        if (UART_total >= 8) {
          // Get length data from network endians data.
          UART_len = get_int32_bytes(UART_inBuffer, 4);
          if (PRINT_UART_READ_DBG) println("Read format Length = " + UART_len);
          if ((UART_len > UART_inBuffer.length - 12) ||
              (UART_len < 4)) {
            UART_str_err_last = "Error: UART read protocol length error! " + UART_len + "," + inLength + "," + UART_total + "," + p.available()/* + "," + UART_inBuffer*/;
            if (PRINT_UART_READ_ERR) println(UART_str_err_last);
            //printArray(UART_inBuffer);
            //printArray(data);
            UART_CMD_state = UART_CMD_STATE_ERROR;
            return;
          }
          UART_state = 1; // Set state machine to other.
        }
      }
      
      // Check received all data
      if(UART_total >= UART_len + 12) {
        UART_CMD_inLength = UART_len + 12;
        //println("Read SCAN state changed to UART_CMD_STATE_RECEIVED! " + UART_total + "," + UART_len);
        UART_CMD_state = UART_CMD_STATE_RECEIVED;

        if(UART_get_take_time_enable)
        {
          // Save CMD take time
          UART_CMD_take_time = millis();
          // Check millis wrap around
          if(UART_CMD_take_time < UART_CMD_start_time)
            UART_CMD_take_time = MAX_INT - UART_CMD_start_time + UART_CMD_take_time;
          else
            UART_CMD_take_time = UART_CMD_take_time - UART_CMD_start_time;
          if (PRINT_UART_READ_DBG) println("Read UART_CMD_take_time=" + UART_CMD_take_time);
        }

        return;
      }
    }
  }
  catch (Exception e) {
    UART_str_err_last = "Error: UART serialEvent() error! " + e;
    if (PRINT_UART_READ_ERR) println(UART_str_err_last);
  }
} 

byte[] UART_PS_make_cmd(String cmd, int param)
{
  byte[] buf = new byte[16];

  // Set function code
  set_str_bytes(buf, 0, cmd);
  // Set data_buf length 4
  set_int32_bytes(buf, 4, 4);
  // Set Scan on(1)
  set_int32_bytes(buf, 8, param);
  // Set CRC
  set_int32_bytes(buf, 12, get_crc32(buf, 0, 12));

  return buf;
}

int UART_PS_perform_SCAN(int on)
{
  byte[] outBuffer;

  if(UART_CMD_state == UART_CMD_STATE_NONE) {
    // Make command buffer
    outBuffer = UART_PS_make_cmd("SCAN", on);
    // Prepare read
    UART_prepare_read(16);
    // Flush buffer
    UART_clear();
    // Prepare UART CMD state
    UART_CMD_state = UART_CMD_STATE_SENT;
    // Write buffer
    UART_write(outBuffer);
    return UART_CMD_state;
  }
  else if(UART_CMD_state == UART_CMD_STATE_SENT) {
    int time_dif;
    // Check time out
    time_dif = millis();
    // Check millis wrap around
    if(time_dif < UART_CMD_start_time)
      time_dif = MAX_INT - UART_CMD_start_time + time_dif;
    else
      time_dif = time_dif - UART_CMD_start_time;
    if(time_dif > UART_CMD_timeout) {
      UART_CMD_state = UART_CMD_STATE_NONE;
      UART_str_err_last = "Error: UART SCAN timeout! " + UART_CMD_inLength + "," + UART_total;
      if(PRINT_UART_LOAD_ERR) println(UART_str_err_last);
      return -1;
    }
    return UART_CMD_state;
  }
  else if(UART_CMD_state == UART_CMD_STATE_RECEIVED) {
    String func;
    int crc, crc_c;

    // Check CRC
    crc = get_int32_bytes(UART_inBuffer, UART_CMD_inLength - 4);
    crc_c = get_crc32(UART_inBuffer, 0, UART_CMD_inLength - 4);
    if(crc != crc_c) {
      UART_CMD_state = UART_CMD_STATE_NONE;
      UART_str_err_last = "Error: UART SCAN CRC error! " + crc + "," + crc_c + "," + UART_CMD_inLength + "," + UART_total;
      if(PRINT_UART_LOAD_ERR) println(UART_str_err_last);
      return -1;
    }
    // Check function code
    func = get_str_bytes(UART_inBuffer, 0, 4);
    if(func.equals("SCAN") == false) {
      // Get error code and return
      int err = get_int32_bytes(UART_inBuffer, 8);
      UART_CMD_state = UART_CMD_STATE_NONE;
      UART_str_err_last = "Error: UART SCAN error return! " + err;
      if(PRINT_UART_LOAD_ERR) println(UART_str_err_last);
      // Get error code and return
      return err;
    }
    UART_CMD_state = UART_CMD_STATE_NONE;
    return 0;
  }
  else if(UART_CMD_state == UART_CMD_STATE_ERROR) {
    UART_CMD_state = UART_CMD_STATE_NONE;
    return -1;
  }

  return UART_CMD_state;
}

int UART_PS_perform_GSCN(int scan_number)
{
  byte[] outBuffer;

  if(UART_CMD_state == UART_CMD_STATE_NONE) {
    // Make command buffer
    outBuffer = UART_PS_make_cmd("GSCN", scan_number);
    // Prepare read
    UART_prepare_read(UART_PS_MAX_BUFFER);
    // Flush buffer
    UART_clear();
    // Prepare UART CMD state
    UART_CMD_state = UART_CMD_STATE_SENT;
    // Write buffer
    UART_write(outBuffer);
    return UART_CMD_state;
  }
  else if(UART_CMD_state == UART_CMD_STATE_SENT) {
    int time_dif;
    // Check time out
    time_dif = millis();
    // Check millis wrap around
    if(time_dif < UART_CMD_start_time)
      time_dif = MAX_INT - UART_CMD_start_time + time_dif;
    else
      time_dif = time_dif - UART_CMD_start_time;
    if(time_dif > UART_CMD_timeout) {
      UART_str_err_last = "Error: UART GSCN timeout! " + UART_CMD_inLength + "," + UART_total;
      if(PRINT_UART_LOAD_ERR) println(UART_str_err_last);
      UART_CMD_state = UART_CMD_STATE_NONE;
      return -1;
    }
    return UART_CMD_state;
  }
  else if(UART_CMD_state == UART_CMD_STATE_RECEIVED) {
    String func;
    int crc, crc_c;

    // Check CRC
    crc = get_int32_bytes(UART_inBuffer, UART_CMD_inLength - 4);
    crc_c = get_crc32(UART_inBuffer, 0, UART_CMD_inLength - 4);
    if(crc != crc_c) {
      UART_CMD_state = UART_CMD_STATE_NONE;
      UART_str_err_last = "Error: UART GSCN CRC error! " + crc + "," + crc_c + "," + UART_CMD_inLength + "," + UART_total;
      if(PRINT_UART_LOAD_ERR) println(UART_str_err_last);
      return -1;
    }
    // Check function code
    func = get_str_bytes(UART_inBuffer, 0, 4);
    if(func.equals("GSCN") == false) {
      // Get error code and return
      int err = get_int32_bytes(UART_inBuffer, 8);
      UART_CMD_state = UART_CMD_STATE_NONE;
      UART_str_err_last = "Error: UART GSCN error return! " + err;
      if(PRINT_UART_LOAD_ERR) println(UART_str_err_last);
      // Get error code and return
      return err;
    }
    UART_CMD_state = UART_CMD_STATE_NONE;
    return 0;
  }
  else if(UART_CMD_state == UART_CMD_STATE_ERROR) {
    UART_CMD_state = UART_CMD_STATE_NONE;
    return -1;
  }

  return UART_CMD_state;
}
