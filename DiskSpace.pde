//final static boolean PRINT_DISK_SPACE_ALL_DBG = true;
final static boolean PRINT_DISK_SPACE_ALL_DBG = false;
final static boolean PRINT_DISK_SPACE_ALL_ERR = true;
//final static boolean PRINT_DISK_SPACE_ALL_ERR = false;

//final static boolean PRINT_DISK_SPACE_FREE_EVENTS_DBG = true;
final static boolean PRINT_DISK_SPACE_FREE_EVENTS_DBG = false;
//final static boolean PRINT_DISK_SPACE_FREE_EVENTS_ERR = true;
final static boolean PRINT_DISK_SPACE_FREE_EVENTS_ERR = false;

final static long DISK_SPACE_FREE_LIMIT = 1L*1024L*1024L*1024L; // 1GB

static boolean Disk_Space_setup_done = false;
static boolean Disk_Space_threads_pause;

void Disk_Space_setup()
{
  //Disk_Space_free_always();
  //Disk_Space_free_events();

  if (Disk_Space_setup_done) return;

  Disk_Space_threads_pause = false;
  thread("Disk_Space_free_always");
  thread("Disk_Space_free_events");
  Disk_Space_setup_done = true;
}

/*
void Disk_Space_free()
{
  Disk_Space_free_events();
}
*/

void Disk_Space_free_events()
{
  String events_dir_full_name = sketchPath("events\\");
  File events_dir_handle = new File(events_dir_full_name);

  delay(FRAME_TIME * 1 / 4);
  do
  {
    delay(FRAME_TIME);

    if (Disk_Space_threads_pause) continue;

    if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():Run"+millis());
    //println("Disk_Space_free_events():Run"+millis());

    if (!events_dir_handle.isDirectory()) {
      if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():events directory is not ready!");
      continue;
    }

    //long free_space = events_dir_handle.getFreeSpace();
    long free_space = events_dir_handle.getUsableSpace();
    if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():check free_space="+free_space+" at "+events_dir_full_name);
    if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():DISK_SPACE_FREE_LIMIT="+DISK_SPACE_FREE_LIMIT);
    if (free_space > DISK_SPACE_FREE_LIMIT) continue;
    if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():have not enough free_space="+free_space+" at "+events_dir_full_name);

    // get files list.
    String[] events_dirs_list = events_dir_handle.list();
    if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():events_dirs_list="+events_dirs_list);
    if (events_dirs_list == null) continue;
    if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():events_dirs_list.length="+events_dirs_list.length);
    //if (events_dirs_list.length <= 10) continue;

    //int delete_start_millis = millis();
    for (String events_subdir_name:events_dirs_list) {
      if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():events_subdir_name="+events_subdir_name);
      File events_subdir_handle = new File(events_dir_full_name+events_subdir_name+"\\");
      if (!events_subdir_handle.isDirectory()) {
        if (PRINT_DISK_SPACE_ALL_ERR || PRINT_DISK_SPACE_FREE_EVENTS_ERR) println("Disk_Space_free_events():not directory! "+events_dir_full_name+events_subdir_name+"\\");
        events_subdir_handle.delete();
        continue;
      }
      String[] events_subdir_files_list = events_subdir_handle.list();
      if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():events_subdir_files_list="+events_subdir_files_list);
      if (events_subdir_files_list == null) {
        if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():no files on sub directory! "+events_dir_full_name+events_subdir_name+"\\");
        events_subdir_handle.delete();
        continue;
      }
      if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():events_subdir_files_list.length="+events_subdir_files_list.length);
      for (String events_file_name:events_subdir_files_list) {
        //println("Disk_Space_free_events():events_file_name="+events_file_name);
        File events_file_handle = new File(events_dir_full_name+events_subdir_name+"\\"+events_file_name);
        if (!events_file_handle.isFile()) {
          if (PRINT_DISK_SPACE_ALL_ERR || PRINT_DISK_SPACE_FREE_EVENTS_ERR) println("Disk_Space_free_events():not file! "+events_dir_full_name+events_subdir_name+"\\"+events_file_name);
          continue;
        }
        events_file_handle.delete();
      }
      events_subdir_handle.delete();
      if (PRINT_DISK_SPACE_ALL_DBG || PRINT_DISK_SPACE_FREE_EVENTS_DBG) println("Disk_Space_free_events():delete done! "+events_subdir_name);
      break;
    }
  } while (true);
}

void Disk_Space_free_always()
{
  delay(FRAME_TIME * 2 / 4);
  do
  {
    delay(FRAME_TIME);
    if (Disk_Space_threads_pause) continue;

    if (PRINT_DISK_SPACE_ALL_DBG) println("Disk_Space_free_always():Run"+millis());
    //println("Disk_Space_free_always():Run"+millis());

    long time_stamp = new Date().getTime();
    //Dbg_Time_logs_handle.add("Date().getTime()");
    String always_dir_full_name = sketchPath("always\\");
    File always_dir_handle = new File(always_dir_full_name);
    //println("time_stamp="+time_stamp+",millis()="+millis());
    if (!always_dir_handle.isDirectory()) continue;

    // get files list to decide delete file.
    String[] always_files_list = always_dir_handle.list();
    if (always_files_list == null) continue;
    for (String always_file_name:always_files_list) {
      long file_time_stamp;
      try {
        file_time_stamp = Long.parseLong(always_file_name.substring(2, always_file_name.length() - 4));
      }
      catch (NumberFormatException e) {
        file_time_stamp = time_stamp - PS_DATA_SAVE_ALWAYS_DURATION*60*60*1000L; // to delete file.
      }
      if (file_time_stamp > time_stamp - PS_DATA_SAVE_ALWAYS_DURATION*60*60*1000L) continue;
      //println(always_file_name+","+file_time_stamp);
      File always_file_handle;
      always_file_handle = new File(always_dir_full_name+always_file_name);
      always_file_handle.delete();
    }
  } while (true);
}

