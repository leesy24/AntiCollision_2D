//final static boolean PRINT_CONFIG_ALL_DBG = true;
final static boolean PRINT_CONFIG_ALL_DBG = false;

//final static boolean PRINT_CONFIG_SETUP_DBG = true;
final static boolean PRINT_CONFIG_SETUP_DBG = false;

// Define default binary buf filename and path 
final static String CONFIG_FILE_NAME = "config";
final static String CONFIG_FILE_EXT = ".csv";

static String CONFIG_file_full_name;
// This is for argument passed number of config file.
/*
static String CONFIG_instance_number = null;
*/

void Config_setup()
{
  if (PRINT_CONFIG_ALL_DBG || PRINT_CONFIG_SETUP_DBG) println("Config_setup():Enter");

  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    CONFIG_file_full_name = CONFIG_FILE_NAME + "_" + i + CONFIG_FILE_EXT;
 
    // A Table object
    Table table;

    // Load config file(CSV type) into a Table object
    // "header" option indicates the file has a header row
    table = loadTable(CONFIG_file_full_name, "header");
    // Check loadTable failed.
    if(table == null)
    {
      Config_create();
      return;
    }

    for (TableRow variable : table.rows())
    {
      // You can access the fields via their column name (or index)
      String name = variable.getString("Name");
      if (name.equals("PS_Interface")) {
        for (int j = 0; j < PS_Interface_str.length; j ++) {
          if (PS_Interface_str[j].equals(variable.getString("Value")))
            PS_Interface[i] = j;
        }
      }
      else if (name.equals("ROTATE_FACTOR")) {
        ROTATE_FACTOR[i] = variable.getFloat("Value"); 
      }
      else if (name.equals("MIRROR_ENABLE")) {
        MIRROR_ENABLE[i] = (variable.getString("Value").equals("true"))?true:false; 
      }
      else if (name.equals("ZOOM_FACTOR")) {
        ZOOM_FACTOR[i] = variable.getInt("Value"); 
      }
      else if (name.equals("DRAW_OFFSET_X")) {
        DRAW_OFFSET_X[i] = variable.getInt("Value");
      }
      else if (name.equals("DRAW_OFFSET_Y")) {
        DRAW_OFFSET_Y[i] = variable.getInt("Value");
      }
      else if (name.equals("FILE_name")) {
        FILE_name[i] = variable.getString("Value");
      }
      else if (name.equals("UART_port_name")) {
        UART_port_name = variable.getString("Value");
      }
      else if (name.equals("UART_baud_rate")) {
        UART_baud_rate = variable.getInt("Value");
      }
      else if (name.equals("UART_parity")) {
        UART_parity = variable.getString("Value").charAt(0);
      }
      else if (name.equals("UART_data_bits")) {
        UART_data_bits = variable.getInt("Value");
      }
      else if (name.equals("UART_stop_bits")) {
        UART_stop_bits = variable.getFloat("Value"); 
      }
      else if (name.equals("UDP_remote_ip")) {
        UDP_remote_ip[i] = variable.getString("Value");
      }
      else if (name.equals("UDP_remote_port")) {
        UDP_remote_port[i] = variable.getInt("Value");
      }
      else if (name.equals("UDP_local_port")) {
        UDP_local_port[i] = variable.getInt("Value");
      }
      else if (name.equals("SN_serial_number")){
        SN_serial_number[i] = variable.getInt("Value");
      }
    }
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():PS_Interface["+i+"]="+PS_Interface[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():ROTATE_FACTOR["+i+"]="+ROTATE_FACTOR[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():MIRROR_ENABLE["+i+"]="+MIRROR_ENABLE[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():ZOOM_FACTOR["+i+"]="+ZOOM_FACTOR[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():DRAW_OFFSET_X["+i+"]="+DRAW_OFFSET_X[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():DRAW_OFFSET_Y["+i+"]="+DRAW_OFFSET_Y[i]);
  }
  // This is for argument passed number of config file.
  /*
  if(CONFIG_instance_number != null)
    Title = Title + " #" + CONFIG_instance_number + " - ";
  else
    Title = Title + " #0" + " - ";
  */
  Title = Title + " - ";
}

void Config_create()
{
  if (PRINT_CONFIG_ALL_DBG) println("Config_create():");

  TableRow variable;
  
  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    // A Table object
    Table table;

    table = new Table();
    table.addColumn("Name");
    table.addColumn("Value");
    table.addColumn("Comment");

    variable = table.addRow();
    variable.setString("Name", "PS_Interface");
    variable.setString("Value", PS_Interface_str[PS_Interface[i]]);
    variable.setString("Comment", "PS Interface via File or COM or UDP or SN.");

    variable = table.addRow();
    variable.setString("Name", "ROTATE_FACTOR");
    variable.setFloat("Value", ROTATE_FACTOR[i]);
    variable.setString("Comment", "Rotate factor of draws for 45 or 135 or 225 or 315");

    variable = table.addRow();
    variable.setString("Name", "MIRROR_ENABLE");
    variable.setString("Value", ((MIRROR_ENABLE[i])?"true":"false"));
    variable.setString("Comment", "Mirroring or not.(true or false)");

    variable = table.addRow();
    variable.setString("Name", "ZOOM_FACTOR");
    //variable.setFloat("Value", ZOOM_FACTOR);
    variable.setInt("Value", ZOOM_FACTOR[i]);
    variable.setString("Comment", "Zooming factor of draws.(1000 for 50 meter or 100 for 5 meter)");

    variable = table.addRow();
    variable.setString("Name", "DRAW_OFFSET_X");
    variable.setInt("Value", DRAW_OFFSET_X[i]);
    variable.setString("Comment", "X Offset of draws.");

    variable = table.addRow();
    variable.setString("Name", "DRAW_OFFSET_Y");
    variable.setInt("Value", DRAW_OFFSET_Y[i]);
    variable.setString("Comment", "Y Offset of draws.");

    variable = table.addRow();
    variable.setString("Name", "FILE_name");
    variable.setString("Value", FILE_name[i]);
    variable.setString("Comment", "File name of PS Interface File.");

    variable = table.addRow();
    variable.setString("Name", "UART_port_name");
    variable.setString("Value", UART_port_name);
    variable.setString("Comment", "UART port name of PS Interface UART.");

    variable = table.addRow();
    variable.setString("Name", "UART_baud_rate");
    variable.setInt("Value", UART_baud_rate);
    variable.setString("Comment", "UART baud rate of PS Interface UART.");

    variable = table.addRow();
    variable.setString("Name", "UART_parity");
    variable.setString("Value", Character.toString(UART_parity));
    variable.setString("Comment", "UART parity of PS Interface UART.");

    variable = table.addRow();
    variable.setString("Name", "UART_data_bits");
    variable.setInt("Value", UART_data_bits);
    variable.setString("Comment", "UART baud rate of PS Interface UART.");

    variable = table.addRow();
    variable.setString("Name", "UART_stop_bits");
    variable.setFloat("Value", UART_stop_bits);
    variable.setString("Comment", "UART stop bits of PS Interface UART.");

    variable = table.addRow();
    variable.setString("Name", "UDP_remote_ip");
    variable.setString("Value", UDP_remote_ip[i]);
    variable.setString("Comment", "UDP remote IP of PS Interface UDP.");

    variable = table.addRow();
    variable.setString("Name", "UDP_remote_port");
    variable.setInt("Value", UDP_remote_port[i]);
    variable.setString("Comment", "UDP remote port of PS Interface UDP.");

    variable = table.addRow();
    variable.setString("Name", "UDP_local_port");
    variable.setInt("Value", UDP_local_port[i]);
    variable.setString("Comment", "UDP local port of PS Interface UDP.");

    variable = table.addRow();
    variable.setString("Name", "SN_serial_number");
    variable.setInt("Value", SN_serial_number[i]);
    variable.setString("Comment", "Serial Number of PS Interface SN.");

    CONFIG_file_full_name = CONFIG_FILE_NAME + "_" + i + CONFIG_FILE_EXT;
    saveTable(table, "data/" + CONFIG_file_full_name);
  }
}

void Config_save()
{
  if (PRINT_CONFIG_ALL_DBG) println("Config_save():Enter");

  int value_int;
  float value_float;
  boolean value_boolean;
  String value_string;
  boolean changed = false;

  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    CONFIG_file_full_name = CONFIG_FILE_NAME + "_" + i + CONFIG_FILE_EXT;
 
    // A Table object
    Table table;

    // Load config file(CSV type) into a Table object
    // "header" option indicates the file has a header row
    table = loadTable(CONFIG_file_full_name, "header");
    // Check loadTable failed.
    if(table == null)
    {
      return;
    }

    for (TableRow variable : table.rows()) {
      // You can access the fields via their column name (or index)
      String name = variable.getString("Name");
      if(name.equals("PS_Interface")) {
        value_string = variable.getString("Value");
        if(value_string.equals(PS_Interface_str[PS_Interface[i]]) != true) {
          variable.setString("Value", PS_Interface_str[PS_Interface[i]]);
          changed = true;
        }
      }
      else if(name.equals("ROTATE_FACTOR")) {
        value_float = variable.getFloat("Value");
        if(value_float != ROTATE_FACTOR[i]) {
          variable.setFloat("Value", ROTATE_FACTOR[i]);
          changed = true;
        }
      }
      else if(name.equals("MIRROR_ENABLE")) {
        value_boolean = variable.getString("Value").equals("true")?true:false;
        if(value_boolean != MIRROR_ENABLE[i]) {
          variable.setString("Value", ((MIRROR_ENABLE[i])?"true":"false"));
          changed = true;
        }
      }
      else if(name.equals("ZOOM_FACTOR")) {
        value_float = variable.getFloat("Value");
        if(value_float != ZOOM_FACTOR[i]) {
          //variable.setFloat("Value", ZOOM_FACTOR);
          variable.setInt("Value", ZOOM_FACTOR[i]);
          changed = true;
        }
      }
      else if(name.equals("DRAW_OFFSET_X")) {
        value_int = variable.getInt("Value");
        if(value_int != DRAW_OFFSET_X[i]) {
          variable.setInt("Value", DRAW_OFFSET_X[i]);
          changed = true;
        }
      }
      else if(name.equals("DRAW_OFFSET_Y")) {
        value_int = variable.getInt("Value");
        if(value_int != DRAW_OFFSET_Y[i]) {
          variable.setInt("Value", DRAW_OFFSET_Y[i]);
          changed = true;
        }
      }
      else if(name.equals("FILE_name")) {
        value_string = variable.getString("Value");
        if(value_string.equals(FILE_name[i]) != true) {
          variable.setString("Value", FILE_name[i]);
          changed = true;
        }
      }
      else if(name.equals("UART_port_name")) {
        value_string = variable.getString("Value");
        if(value_string.equals(UART_port_name) != true) {
          variable.setString("Value", UART_port_name);
          changed = true;
        }
      }
      else if(name.equals("UART_baud_rate")) {
        value_int = variable.getInt("Value");
        if(value_int != UART_baud_rate) {
          variable.setInt("Value", UART_baud_rate);
          changed = true;
        }
      }
      else if(name.equals("UART_parity")) {
        value_string = variable.getString("Value");
        if(value_string.charAt(0) != UART_parity) {
          variable.setString("Value", Character.toString(UART_parity));
          changed = true;
        }
      }
      else if(name.equals("UART_data_bits")) {
        value_int = variable.getInt("Value");
        if(value_int != UART_data_bits) {
          variable.setInt("Value", UART_data_bits);
          changed = true;
        }
      }
      else if(name.equals("UART_stop_bits")) {
        value_float = variable.getFloat("Value");
        if(value_float != UART_stop_bits) {
          variable.setFloat("Value", UART_stop_bits);
          changed = true;
        }
      }
      else if(name.equals("UDP_remote_ip")) {
        value_string = variable.getString("Value");
        if(value_string.equals(UDP_remote_ip[i]) != true) {
          variable.setString("Value", UDP_remote_ip[i]);
          changed = true;
        }
      }
      else if(name.equals("UDP_remote_port")) {
        value_int = variable.getInt("Value");
        if(value_int != UDP_remote_port[i]) {
          variable.setInt("Value", UDP_remote_port[i]);
          changed = true;
        }
      }
      else if(name.equals("UDP_local_port")) {
        value_int = variable.getInt("Value");
        if(value_int != UDP_local_port[i]) {
          variable.setInt("Value", UDP_local_port[i]);
          changed = true;
        }
      }
      else if(name.equals("SN_serial_number")) {
        value_int = variable.getInt("Value");
        if(value_int != SN_serial_number[i]) {
          variable.setInt("Value", SN_serial_number[i]);
          changed = true;
        }
      }
    }

    // Check config changed
    if(changed) {
      // Writing the config file(CSV type) back to the same file
      CONFIG_file_full_name = CONFIG_FILE_NAME + "_" + i + CONFIG_FILE_EXT;
      saveTable(table, "data/" + CONFIG_file_full_name);
    }
  }
}
