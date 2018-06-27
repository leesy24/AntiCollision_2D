import java.io.File;

//final static boolean PRINT_UPDATE_DATA_ALL_DBG = true;
final static boolean PRINT_UPDATE_DATA_ALL_DBG = false;

//final static boolean PRINT_UPDATE_DATA_SETUP_DBG = true;
final static boolean PRINT_UPDATE_DATA_SETUP_DBG = false;

final static String UPDATE_DATA_FILES_ZIP_FILE_NAME = "data";
final static String UPDATE_DATA_FILES_ZIP_FILE_EXT = ".zip";

static enum Update_Data_Files_state_enum {
  IDLE,
  ZIP_READY,
  PASSWORD_REQ,
  UNZIP,
  CHECK_UPDATES,
  UPDATE_PERFORM,
  DISPLAY_MESSAGE,
  RESET
}
static Update_Data_Files_state_enum Update_Data_Files_state;
static Update_Data_Files_state_enum Update_Data_Files_state_next;
static String Update_Data_Files_zip_file_password;
static String Update_Data_Files_zip_file_full_name;
static String Update_Data_error;

void Update_Data_setup()
{
  if (PRINT_UPDATE_DATA_ALL_DBG || PRINT_UPDATE_DATA_SETUP_DBG) println("Update_Data_setup():Enter");

  Update_Data_Files_state = Update_Data_Files_state_enum.IDLE;
}

void Update_Data_Files()
{
  //println("Update_Data_Files_state=", Update_Data_Files_state);
  switch (Update_Data_Files_state)
  {
    case IDLE:
      if (!Update_Data_Files_check_new_zip_file_exist())
      {
        break;
      }
      if (!unzip_check_password_protected(Update_Data_Files_zip_file_full_name))
      {
        UI_Message_Box_setup("Error !", "Incorrect Zip file !\nPlease remove the USB drive.", 5000);
        Update_Data_Files_state = Update_Data_Files_state_enum.DISPLAY_MESSAGE;
        Update_Data_Files_state_next = Update_Data_Files_state_enum.IDLE;
        break;
      }
      Update_Data_Files_state = Update_Data_Files_state_enum.ZIP_READY;
      break;
    case ZIP_READY:
      UI_Num_Pad_setup("Input Password");
      Update_Data_Files_state = Update_Data_Files_state_enum.PASSWORD_REQ;
      break;
    case PASSWORD_REQ:
      UI_Num_Pad_handle.draw();
      if (!UI_Num_Pad_handle.input_done())
      {
        break;
      }
      Update_Data_Files_zip_file_password = UI_Num_Pad_handle.input_string;
      Update_Data_Files_state = Update_Data_Files_state_enum.UNZIP;
      break;
    case UNZIP:
      if (!Update_Data_Files_unzip())
      {
        // unzip fail...
        UI_Message_Box_setup("Error !", "Wrong password !\nOr, Zip file currupted !", 5000);
        Update_Data_Files_state = Update_Data_Files_state_enum.DISPLAY_MESSAGE;
        Update_Data_Files_state_next = Update_Data_Files_state_enum.ZIP_READY;
        break;
      }
      // unzip done! Indicate updated.
      Update_Data_Files_state = Update_Data_Files_state_enum.CHECK_UPDATES;
      break;
    case CHECK_UPDATES:
      if (!Update_Data_Files_check_updates())
      {
        // Noting to update...
        UI_Message_Box_setup("Update already done.", "Already updated.\nPlease check Zip file has new configurations !", 5000);
        Update_Data_Files_state = Update_Data_Files_state_enum.DISPLAY_MESSAGE;
        Update_Data_Files_state_next = Update_Data_Files_state_enum.IDLE;
        break;
      }
      // Update available.
      Update_Data_Files_state = Update_Data_Files_state_enum.UPDATE_PERFORM;
      break;
    case UPDATE_PERFORM:
      if (!Update_Data_Files_perform_update())
      {
        // Noting to update...
        UI_Message_Box_setup("Error !", "Somthing wrong.\nPlease check HW and contact engineers !"+"\n"+Update_Data_error, 5000);
        Update_Data_Files_state = Update_Data_Files_state_enum.DISPLAY_MESSAGE;
        Update_Data_Files_state_next = Update_Data_Files_state_enum.IDLE;
        break;
      }
      // Update done! Indicate updated.
      UI_Message_Box_setup("Update done.", "New configuration applied right now .", 3000);
      Update_Data_Files_state = Update_Data_Files_state_enum.DISPLAY_MESSAGE;
      Update_Data_Files_state_next = Update_Data_Files_state_enum.RESET;
      break;
    case DISPLAY_MESSAGE:
      if (UI_Message_Box_handle.draw())
      {
        break;
      }
      Update_Data_Files_state = Update_Data_Files_state_next;
      break;
    case RESET:
      frameCount = -1;
      break;
  }
}

boolean Update_Data_Files_check_new_zip_file_exist()
{
  boolean found = false;
  String drive, source_file_full_name, target_file_full_name;
  File source_file_handle, target_file_handle;
  boolean tartget_file_is_file;

  target_file_full_name = sketchPath("unzip\\") + UPDATE_DATA_FILES_ZIP_FILE_NAME + UPDATE_DATA_FILES_ZIP_FILE_EXT;
  target_file_handle = new File(target_file_full_name);
  // if target zip file exist and same on local.
  tartget_file_is_file = target_file_handle.isFile();
  
  for (char d = 'd'; d <= 'z'; d ++)
  {
    drive = d + ":\\";
    source_file_handle = new File(drive);
    if (!source_file_handle.isDirectory())
    {
      continue;
    }
    //println("Drive "+drive+" found!");

    source_file_full_name = drive + UPDATE_DATA_FILES_ZIP_FILE_NAME + UPDATE_DATA_FILES_ZIP_FILE_EXT;
    source_file_handle = new File(source_file_full_name);
    if (!source_file_handle.isFile())
    {
      continue;
    }

    // if target zip file same with source zip fiel on unzip dir.
    if (tartget_file_is_file
        &&
        is_files_equals(target_file_full_name, source_file_full_name))
    {
      continue;
    }

    Update_Data_Files_zip_file_full_name = source_file_full_name;
    found = true;
    break;
  }

  return found;
}

boolean Update_Data_Files_unzip()
{
  boolean ret = false;
  String source_file_full_name, target_file_full_name;
  File source_file_handle, target_file_handle;

  source_file_handle = new File(Update_Data_Files_zip_file_full_name);
  if (!source_file_handle.isFile())
  {
    return ret;
  }

  target_file_full_name = sketchPath("unzip\\") + UPDATE_DATA_FILES_ZIP_FILE_NAME + UPDATE_DATA_FILES_ZIP_FILE_EXT;
  target_file_handle = new File(target_file_full_name);
  // if zip file exist and same on local.
  if (target_file_handle.isFile()
      &&
      is_files_equals(Update_Data_Files_zip_file_full_name, target_file_full_name))
  {
    return ret;
  }

  target_file_handle.delete();

  if (unzip_perform(
        Update_Data_Files_zip_file_full_name,
        sketchPath("unzip\\"), Update_Data_Files_zip_file_password)
      < 0)
  {
    return ret;
  }

  ret = true;

  return ret;
}

boolean Update_Data_Files_check_updates()
{
  boolean ret = false;
  String source_file_full_name, target_file_full_name;
  File source_file_handle, target_file_handle;

  String[] files_list;
  source_file_handle = new File(sketchPath("unzip\\"));
  files_list = source_file_handle.list();
  for ( String file_full_name:files_list)
  {
    //println("file name:"+file_full_name);
    source_file_full_name = sketchPath("unzip\\") + file_full_name;
    source_file_handle = new File(source_file_full_name);
    if (!source_file_handle.isFile())
    {
      continue;
    }
    target_file_full_name = sketchPath("data\\") + file_full_name;
    target_file_handle = new File(target_file_full_name);
    if (target_file_handle.isFile()
        &&
        is_files_equals(target_file_full_name, source_file_full_name))
    {
      continue;
    }
    ret = true;
  }

  return ret;
}

boolean Update_Data_Files_perform_update()
{
  boolean ret = true;
  String source_file_full_name, target_file_full_name;
  File source_file_handle;

  String[] files_list;
  source_file_handle = new File(sketchPath("unzip\\"));
  files_list = source_file_handle.list();
  for ( String file_full_name:files_list)
  {
    //println("file name:"+file_full_name);
    source_file_full_name = sketchPath("unzip\\") + file_full_name;
    target_file_full_name = sketchPath("data\\") + file_full_name;
    //println("New File found! "+source_file_full_name);
    if (!move_file(
      source_file_full_name,
      target_file_full_name))
    {
      Update_Data_error = "move_file:\n"+source_file_full_name+"\n"+target_file_full_name;
      ret = false;
      continue;
    }

  }

  // Finally, copy new zip file to current zip on unzip dir to indicate update is done.
  target_file_full_name =
    sketchPath(
      "unzip\\"
      +
      UPDATE_DATA_FILES_ZIP_FILE_NAME
      +
      UPDATE_DATA_FILES_ZIP_FILE_EXT);
  if (!copy_file(
    Update_Data_Files_zip_file_full_name,
    target_file_full_name))
  {
    Update_Data_error = "copy_file:\n"+Update_Data_Files_zip_file_full_name+"\n"+target_file_full_name;
    ret = false;
  }

  return ret;
}
