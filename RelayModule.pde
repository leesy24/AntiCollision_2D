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

Serial Relay_Module_UART_handle = null;  // The handle of UART(serial port)

String Relay_Module_UART_port_name = "COM2"; // String: name of the port (COM1 is the default)
int Relay_Module_UART_baud_rate = 115200; // int: 9600 is the default
char Relay_Module_UART_parity = 'N'; // char: 'N' for none, 'E' for even, 'O' for odd, 'M' for mark, 'S' for space ('N' is the default)
int Relay_Module_UART_data_bits = 8; // int: 8 is the default
float Relay_Module_UART_stop_bits = 1.0; // float: 1.0, 1.5, or 2.0 (1.0 is the default)

final static int RELAY_MODULE_NUMBER_OF_RELAYS = 4;

final static int RELAY_MODULE_CHECK_INTERVAL_IDLE = 1000;

static boolean[] Relay_Module_output_val = new boolean[RELAY_MODULE_NUMBER_OF_RELAYS];
static int Relay_Module_output_interval;
static int Relay_Module_output_timer;

void Relay_Module_setup()
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_SETUP_DBG) println("Relay_Module_setup():Enter");

  boolean found = false;

  //printArray(Serial.list());

  Relay_Module_output_interval = 0; // to set at initial time.
  Relay_Module_output_timer = millis();
  for (int i = 0; i < RELAY_MODULE_NUMBER_OF_RELAYS; i ++)
  {
    Relay_Module_output_val[i] = false;
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

void Relay_Module_clear_relay()
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_SET_RELAY_DBG) println("Relay_Module_clear_relay():Enter");

  for (int i = 0; i < RELAY_MODULE_NUMBER_OF_RELAYS; i ++)
  {
    if (Relay_Module_output_val[i] != false)
    {
      Relay_Module_output_val[i] = false;
      Relay_Module_output_interval = 0; // to set relay immidiatelly.
    }
  }
}

void Relay_Module_set_relay(int relay_index, boolean on)
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_SET_RELAY_DBG) println("Relay_Module_set_relay("+relay_index+","+on+"):Enter");
  //println("Relay_Module_set_relay("+relay_index+","+on+"):Enter");

  if (relay_index >= RELAY_MODULE_NUMBER_OF_RELAYS)
  {
    return;
  }

  if (Relay_Module_output_val[relay_index] != on)
  {
    Relay_Module_output_val[relay_index] = on;
    Relay_Module_output_interval = 0; // to set relay immidiatelly.
  }
}

void Relay_Module_output()
{
  if (get_millis_diff(Relay_Module_output_timer) < Relay_Module_output_interval) return;
  Relay_Module_output_timer = millis();
  Relay_Module_output_interval = RELAY_MODULE_CHECK_INTERVAL_IDLE;

  byte[] buf = new byte[4 + 2];
  buf[0] = 'R';
  int cnt = 0;
  for (int i = 0; i < RELAY_MODULE_NUMBER_OF_RELAYS; i ++)
  {
    if (Relay_Module_output_val[i])
    {
      buf[i + 1] = '1';
      cnt ++;
    }
    else
    {
      buf[i + 1] = '0';
    }
  }
  buf[5] = byte('0' + cnt);
  Relay_Module_UART_write(buf);
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
