//final static boolean PRINT_FILE_LOAD_ERR = true; 
final static boolean PRINT_FILE_LOAD_ERR = false;

// Get OS Name
final String OS = System.getProperty("os.name");

// Define default binary buf filename and path 
final static String FILE_NAME = "data.bin";
static long FILE_last_modified_time = 0;
static String[] FILE_str_err_last;

void Interfaces_File_reset()
{
  FILE_last_modified_time = 0;
  if (FILE_str_err_last == null) return;
  for (int i = 0; i < PS_INSTANCE_MAX; i ++) {
    FILE_str_err_last[i] = null;
  }
}

void Interfaces_File_setup()
{
  FILE_str_err_last = new String[PS_INSTANCE_MAX];
  for (int i = 0; i < PS_INSTANCE_MAX; i ++) {
    // Check config FILE_name
    if( FILE_name[i].equals("") == true ||
        FILE_name[i].equals(FILE_NAME) == true) {
      // Check OS
      if (OS.equals("Linux")) {
        // Define binary data filename and path for Linux OS
        FILE_name[i] = "/tmp/data.bin";
      }
      // Assume Windows OS 
      else {
        // Define binary data filename and path for Windows OS
        //FILE_name = "C:\\work\\git\\PSDemoProgram\\Release-windows\\data.bin";
        FILE_name[i] = "C:\\Temp\\data.bin";
      }
      Config_save();
    }
    Title += "(" + FILE_name[i] + ")";
    FILE_str_err_last[i] = null;
  }
}

String Interfaces_File_get_error(int instance)
{
  return FILE_str_err_last[instance];
}

boolean Interfaces_File_load(int instance)
{
  String string;

  // Check file exists to avoid exception error on loadBytes().
  File file = new File(FILE_name[instance]);
  if (file.exists() != true || file.isDirectory()) {
    FILE_str_err_last[instance] = "Error: File not exist! " + FILE_name[instance];
    if(PRINT_FILE_LOAD_ERR) println(FILE_str_err_last[instance]);
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
  PS_Data_buf[instance] = loadBytes(FILE_name[instance]);
  if (PRINT_FILE_LOAD_ERR) println("buf.length = " + PS_Data_buf[instance].length);
  // Check binary buf length is valid.
  // Must larger than Function code(4B) + Length(4B) + Number of parameters(4B) + Number of points(4B) + CRC(4B).
  if (PS_Data_buf[instance].length < 4 + 4 + 4 + 4 + 4) {
    FILE_str_err_last[instance] = "Error: File size is invalid! " + PS_Data_buf[instance].length;
    if(PRINT_FILE_LOAD_ERR) println(FILE_str_err_last[instance]);
    return false;
  }

  // Update time_last_modified
  FILE_last_modified_time = file.lastModified();
  FILE_str_err_last[instance] = null;
  return true;
}