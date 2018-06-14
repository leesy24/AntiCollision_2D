//final static boolean PRINT_FILE_LOAD_ERR = true; 
final static boolean PRINT_FILE_LOAD_ERR = false;

// Get OS Name
final String OS = System.getProperty("os.name");

// Define default binary buf filename and path 
final static String FILE_NAME = "data.bin";
static String FILE_name = "";
static long FILE_last_modified_time = 0;
static String FILE_str_err_last = null;

void interface_file_reset()
{
  FILE_last_modified_time = 0;
  FILE_str_err_last = null;
}

void interface_file_setup()
{
  // Check config FILE_name
  if( FILE_name.equals("") == true ||
      FILE_name.equals(FILE_NAME) == true) {
    // Check OS
    if (OS.equals("Linux")) {
      // Define binary data filename and path for Linux OS
      FILE_name = "/tmp/data.bin";
    }
    // Assume Windows OS 
    else {
      // Define binary data filename and path for Windows OS
      //FILE_name = "C:\\work\\git\\PSDemoProgram\\Release-windows\\data.bin";
      FILE_name = "C:\\Temp\\data.bin";
    }
    config_save();
  }
  Title += "(" + FILE_name + ")";
}

String interface_file_get_error()
{
  return FILE_str_err_last;
}

boolean interface_file_load()
{
  String string;

  // Check file exists to avoid exception error on loadBytes().
  File file = new File(FILE_name);
  if (file.exists() != true || file.isDirectory()) {
    FILE_str_err_last = "Error: File not exist! " + FILE_name;
    if(PRINT_FILE_LOAD_ERR) println(FILE_str_err_last);
    return false;
  } // End of load()

  // Check file changed
  if (FILE_last_modified_time == file.lastModified())
  {
    string = "Warning: File not changed!:" + FILE_last_modified_time;
    if(PRINT_FILE_LOAD_ERR) println(string);
    return false;
  }
  
  // Load binary buf.
  data_buf = loadBytes(FILE_name);
  if (PRINT_FILE_LOAD_ERR) println("buf.length = " + data_buf.length);
  // Check binary buf length is valid.
  // Must larger than Function code(4B) + Length(4B) + Number of parameters(4B) + Number of points(4B) + CRC(4B).
  if (data_buf.length < 4 + 4 + 4 + 4 + 4) {
    FILE_str_err_last = "Error: File size is invalid! " + data_buf.length;
    if(PRINT_FILE_LOAD_ERR) println(FILE_str_err_last);
    return false;
  }

  // Update time_last_modified
  FILE_last_modified_time = file.lastModified();
  FILE_str_err_last = null;
  return true;
}