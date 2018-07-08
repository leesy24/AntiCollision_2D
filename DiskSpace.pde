//final static boolean PRINT_DISK_SPACE_ALL_DBG = true;
final static boolean PRINT_DISK_SPACE_ALL_DBG = false;
final static boolean PRINT_DISK_SPACE_ALL_ERR = true;
//final static boolean PRINT_DISK_SPACE_ALL_ERR = false;

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

    if (PRINT_DISK_SPACE_ALL_DBG) println("Disk_Space_free_events():Run"+millis());
    //println("Disk_Space_free_events():Run"+millis());

    long free_space = events_dir_handle.getFreeSpace();
    if (PRINT_DISK_SPACE_ALL_DBG) println("Disk_Space_free_events():Disk free space is "+free_space+" at "+events_dir_full_name);
    //println("Disk_Space_free_events():Disk free space is "+free_space+" at "+events_dir_full_name);
    if (free_space > DISK_SPACE_FREE_LIMIT) continue;

    // get files list.
    String[] events_dirs_list = events_dir_handle.list();
    if (events_dirs_list == null) continue;
    //println("events_dirs_list.length="+events_dirs_list.length);
    //if (events_dirs_list.length <= 10) continue;

    //int delete_start_millis = millis();
    for (String events_dir_name:events_dirs_list) {
      //println("events_dir_name="+events_dir_full_name);
      events_dir_handle = new File(events_dir_full_name+events_dir_name+"\\");
      String[] events_files_list = events_dir_handle.list();
      if (events_files_list != null) {
        //println("events_files_list.length="+events_files_list.length);
        for (String events_file_name:events_files_list) {
          //println("events_file_name="+events_file_name);
          File events_file_handle = new File(events_dir_full_name+events_dir_name+"\\"+events_file_name);
          events_file_handle.delete();
          // Check delete operation is too late by frame time.
          //if (get_millis_diff(delete_start_millis) >= (FRAME_TIME / 2)) break;
        }
      }
      // Check delete operation is too late by frame time.
      //if (get_millis_diff(delete_start_millis) >= (FRAME_TIME / 2)) break;
      events_dir_handle.delete();
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
        file_time_stamp = time_stamp - PS_DATA_SAVE_ALWAYS_DURATION; // to delete file.
      }
      if (file_time_stamp > time_stamp - PS_DATA_SAVE_ALWAYS_DURATION) continue;
      //println(always_file_name+","+file_time_stamp);
      File always_file_handle;
      always_file_handle = new File(always_dir_full_name+always_file_name);
      always_file_handle.delete();
    }
  } while (true);
}

