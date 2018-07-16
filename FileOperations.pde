//final static boolean PRINT_FILE_OPERATIONS_ALL_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_ALL_DBG = false;
final static boolean PRINT_FILE_OPERATIONS_ALL_ERR = true;
//final static boolean PRINT_FILE_OPERATIONS_ALL_ERR = false;

//final static boolean PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG = false;
//final static boolean PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR = true;
final static boolean PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR = false;

//final static boolean PRINT_FILE_OPERATIONS_SAVE_EVENTS_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_SAVE_EVENTS_DBG = false;
//final static boolean PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR = true;
final static boolean PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR = false;

final static long FILE_OPERATIONS_FREE_LIMIT = 1L*1024L*1024L*1024L; // 1GB

static boolean File_Operations_setup_done = false;
static boolean File_Operations_free_threads_pause;

static boolean File_Operations_always_dir_ready;
static boolean File_Operations_events_dir_ready;

static boolean[] File_Operations_save_events_started = new boolean[PS_INSTANCE_MAX];
static boolean[] File_Operations_save_events_write_events_done = new boolean[PS_INSTANCE_MAX];
static boolean[] File_Operations_save_events_done = new boolean[PS_INSTANCE_MAX];
static long[] File_Operations_save_events_event_date_time = new long[PS_INSTANCE_MAX];
static long[] File_Operations_save_events_start_date_time = new long[PS_INSTANCE_MAX];
static long[] File_Operations_save_events_end_date_time = new long[PS_INSTANCE_MAX];
static String[] File_Operations_save_events_dir_full_name = new String[PS_INSTANCE_MAX];
static enum File_Operations_save_events_state_enum {
  IDLE,
  COPY_ALWAYS_TO_EVENTS,
  WAIT_WRITE_EVENTS_DONE,
  DONE,
  MAX
}
static File_Operations_save_events_state_enum[] File_Operations_save_events_state = new File_Operations_save_events_state_enum[PS_INSTANCE_MAX];

void File_Operations_setup()
{
  //File_Operations_free_always();
  //File_Operations_free_events();

  String always_dir_full_name = sketchPath("always\\");
  File always_dir_handle = new File(always_dir_full_name);
  //println("data_time="+data_time+",millis()="+millis());
  // Check exists the always directory.
  if (!always_dir_handle.isDirectory())
  {
    if (!always_dir_handle.mkdir())
    {
      if (PRINT_FILE_OPERATIONS_ALL_ERR) println("File_Operations_setup():mkdir() error! "+always_dir_full_name);
      File_Operations_always_dir_ready = false;
    }
  }
  else
  {
    File_Operations_always_dir_ready = true;
  }

  String events_dir_full_name = sketchPath("events\\");
  File events_dir_handle = new File(events_dir_full_name);
  //println("data_time="+data_time+",millis()="+millis());
  // Check exists the always directory.
  if (!events_dir_handle.isDirectory())
  {
    if (!events_dir_handle.mkdir())
    {
      if (PRINT_FILE_OPERATIONS_ALL_ERR) println("File_Operations_setup():mkdir() error! "+events_dir_full_name);
      File_Operations_events_dir_ready = false;
    }
  }
  else
  {
    File_Operations_events_dir_ready = true;
  }

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    File_Operations_save_events_state[i] = File_Operations_save_events_state_enum.IDLE;
  }

  if (File_Operations_setup_done) return;

  File_Operations_free_threads_pause = false;
  thread("File_Operations_free_always");
  thread("File_Operations_free_events");
  thread("File_Operations_save_events");
  File_Operations_setup_done = true;
}

/*
void File_Operations_free()
{
  File_Operations_free_events();
}
*/

void File_Operations_free_events()
{
  String events_dir_full_name = sketchPath("events\\");
  File events_dir_handle = new File(events_dir_full_name);

  delay(FRAME_TIME * 1 / 4);
  do
  {
    delay(FRAME_TIME);

    if (File_Operations_free_threads_pause) continue;

    if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():Run"+millis());
    //println("File_Operations_free_events():Run"+millis());

    if (!events_dir_handle.isDirectory()) {
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():events directory is not ready!");
      continue;
    }

    //long free_space = events_dir_handle.getFreeSpace();
    long free_space = events_dir_handle.getUsableSpace();
    if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():check free_space="+free_space+" at "+events_dir_full_name);
    if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():FILE_OPERATIONS_FREE_LIMIT="+FILE_OPERATIONS_FREE_LIMIT);
    if (free_space > FILE_OPERATIONS_FREE_LIMIT) continue;
    if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():have not enough free_space="+free_space+" at "+events_dir_full_name);

    // get files list.
    String[] events_dirs_list = events_dir_handle.list();
    if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():events_dirs_list="+events_dirs_list);
    if (events_dirs_list == null) continue;
    if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():events_dirs_list.length="+events_dirs_list.length);
    //if (events_dirs_list.length <= 10) continue;

    //int delete_start_millis = millis();
    for (String events_subdir_name:events_dirs_list) {
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():events_subdir_name="+events_subdir_name);
      File events_subdir_handle = new File(events_dir_full_name+events_subdir_name+"\\");
      if (!events_subdir_handle.isDirectory()) {
        if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR) println("File_Operations_free_events():not directory! "+events_dir_full_name+events_subdir_name+"\\");
        events_subdir_handle.delete();
        delay(1);
        continue;
      }
      String[] events_subdir_files_list = events_subdir_handle.list();
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():events_subdir_files_list="+events_subdir_files_list);
      if (events_subdir_files_list == null) {
        if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():no files on sub directory! "+events_dir_full_name+events_subdir_name+"\\");
        events_subdir_handle.delete();
        delay(1);
        continue;
      }
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():events_subdir_files_list.length="+events_subdir_files_list.length);
      for (String events_file_name:events_subdir_files_list) {
        //println("File_Operations_free_events():events_file_name="+events_file_name);
        File events_file_handle = new File(events_dir_full_name+events_subdir_name+"\\"+events_file_name);
        if (!events_file_handle.isFile()) {
          if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR) println("File_Operations_free_events():not file! "+events_dir_full_name+events_subdir_name+"\\"+events_file_name);
          continue;
        }
        events_file_handle.delete();
        delay(1);
      }
      events_subdir_handle.delete();
      delay(1);
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():delete done! "+events_subdir_name);
      break;
    }
  } while (true);
}

void File_Operations_free_always()
{
  delay(FRAME_TIME * 2 / 4);
  do
  {
    delay(FRAME_TIME);
    if (File_Operations_free_threads_pause) continue;

    if (PRINT_FILE_OPERATIONS_ALL_DBG) println("File_Operations_free_always():Run"+millis());
    //println("File_Operations_free_always():Run"+millis());

    long date_time = new Date().getTime();
    //Dbg_Time_logs_handle.add("Date().getTime()");
    String always_dir_full_name = sketchPath("always\\");
    File always_dir_handle = new File(always_dir_full_name);
    //println("date_time="+date_time+",millis()="+millis());
    if (!always_dir_handle.isDirectory()) continue;

    // get files list to decide delete file.
    String[] always_files_list = always_dir_handle.list();
    if (always_files_list == null) continue;
    for (String always_file_name:always_files_list) {
      long file_date_time;
      try {
        file_date_time = Long.parseLong(always_file_name.substring(2, always_file_name.length() - 4));
      }
      catch (NumberFormatException e) {
        file_date_time = date_time - PS_DATA_SAVE_ALWAYS_DURATION*60*60*1000L; // to delete file.
      }
      if (file_date_time > date_time - PS_DATA_SAVE_ALWAYS_DURATION*60*60*1000L) continue;
      //println(always_file_name+","+file_date_time);
      File always_file_handle;
      always_file_handle = new File(always_dir_full_name+always_file_name);
      always_file_handle.delete();
      delay(1);
    }
  } while (true);
}

void File_Operations_save_events()
{
  String always_dir_full_name = sketchPath("always\\");
  File always_dir_handle;
  always_dir_handle = new File(always_dir_full_name);
  String[][] always_files_list = new String[PS_INSTANCE_MAX][];
  int[] always_files_list_index = new int[PS_INSTANCE_MAX];

  delay(FRAME_TIME * 3 / 4);
  do
  {
    for (int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
    {
      if (File_Operations_save_events_state[instance] == File_Operations_save_events_state_enum.IDLE)
      {
        delay(FRAME_TIME);
        if (!File_Operations_save_events_started[instance])
        {
          continue;
        }

        if (File_Operations_save_events_done[instance])
        {
          continue;
        }
      }
      else if (File_Operations_save_events_state[instance] != File_Operations_save_events_state_enum.COPY_ALWAYS_TO_EVENTS)
      {
        delay(FRAME_TIME);
      }

      //println("File_Operations_save_events():"+":File_Operations_save_events_state["+instance+"]="+File_Operations_save_events_state[instance]);
      switch (File_Operations_save_events_state[instance])
      {
        case IDLE:
          // Set pause state of Disk Space free threads to save events files.
          File_Operations_free_threads_pause = true;

          // get files list.
          always_files_list[instance] = always_dir_handle.list();
          if (always_files_list[instance] == null)
          {
            if (PRINT_FILE_OPERATIONS_ALL_ERR) println("File_Operations_save_events("+instance+"):always_files_list[instance] = null! "+always_dir_full_name);
            // Reset pause state of Disk Space free threads to save events files.
            File_Operations_free_threads_pause = false;
            break;
          }

          File_Operations_save_events_state[instance] = File_Operations_save_events_state_enum.COPY_ALWAYS_TO_EVENTS;
          always_files_list_index[instance] = 0;
          break;

        case COPY_ALWAYS_TO_EVENTS:
          int copy_count = 0;
          int copy_start_millis = millis();
          int i;
          for (i = always_files_list_index[instance]; i < always_files_list[instance].length; i ++)
          {
            String always_file_name = always_files_list[instance][i];
            // Check file is for this instance.
            //println("File_Operations_save_events("+instance+"):always_file_name="+always_file_name+",substring="+always_file_name.substring(0, 2));
            if (!always_file_name.substring(0, 2).equals(instance+"_")) continue;

            // Get date time of always file.
            long always_file_date_time;
            try
            {
              always_file_date_time = Long.parseLong(always_file_name.substring(2, always_file_name.length() - 4));
            }
            catch (NumberFormatException e)
            {
              // File name error.
              // Set always_file_date_time value to skip data file copy.
              always_file_date_time = File_Operations_save_events_start_date_time[instance] - 1;
            }
            // Check date time of always file is older than expected date time to skip.
            if (always_file_date_time < File_Operations_save_events_start_date_time[instance]) continue;
            // Check date time of always file is new than expected date time to skip.
            if (always_file_date_time > File_Operations_save_events_event_date_time[instance]) continue;
            // Copy data file.
            if (!copy_file(
                  always_dir_full_name + always_file_name,
                  File_Operations_save_events_dir_full_name[instance] + always_file_name,
                  new CopyOption[] {StandardCopyOption.COPY_ATTRIBUTES}))
            {
              if (PRINT_FILE_OPERATIONS_ALL_ERR) println("File_Operations_save_events():" + instance + ":copy_file() error!" + "\n\t" + always_dir_full_name + always_file_name + "->" + "\n\t" + File_Operations_save_events_dir_full_name[instance] + always_file_name + "\n\t" + copy_file_error);
              break;
            }
            //delay(1);
            /*
            Dbg_Time_logs_handle.add("File_Operations_save_events("+instance+"):copy_file():avg="+((copy_count!=0)?(copy_time_sum/copy_count):0));
            copy_time_sum += Dbg_Time_logs_handle.get_add_diff();
            copy_count ++;
            */
            copy_count ++;
            // Check copy operation is too late by frame time.
            if (get_millis_diff(copy_start_millis) >= FRAME_TIME) break;
          }
          if (i != always_files_list[instance].length)
          {
            always_files_list_index[instance] = i + 1;
          }
          else
          {
            File_Operations_save_events_state[instance] = File_Operations_save_events_state_enum.WAIT_WRITE_EVENTS_DONE;
            // Reset pause state of Disk Space free threads to save events files.
            File_Operations_free_threads_pause = false;
          }
          break;

        case WAIT_WRITE_EVENTS_DONE:
          if (!File_Operations_save_events_write_events_done[instance]) break;
          File_Operations_save_events_state[instance] = File_Operations_save_events_state_enum.DONE;
          break;

        case DONE:
          File_Operations_save_events_done[instance] = true;
          File_Operations_save_events_state[instance] = File_Operations_save_events_state_enum.IDLE;
          break;
      }
    }
  } while (true);
}
