import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.util.concurrent.ConcurrentLinkedQueue;

//final static boolean PRINT_FILE_OPERATIONS_ALL_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_ALL_DBG = false;
final static boolean PRINT_FILE_OPERATIONS_ALL_ERR = true;
//final static boolean PRINT_FILE_OPERATIONS_ALL_ERR = false;

//final static boolean PRINT_FILE_OPERATIONS_SETUP_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_SETUP_DBG = false;
//final static boolean PRINT_FILE_OPERATIONS_SETUP_ERR = true;
final static boolean PRINT_FILE_OPERATIONS_SETUP_ERR = false;

//final static boolean PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG = false;
//final static boolean PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR = true;
final static boolean PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR = false;

//final static boolean PRINT_FILE_OPERATIONS_FREE_ALWAYS_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_FREE_ALWAYS_DBG = false;
//final static boolean PRINT_FILE_OPERATIONS_FREE_ALWAYS_ERR = true;
final static boolean PRINT_FILE_OPERATIONS_FREE_ALWAYS_ERR = false;

//final static boolean PRINT_FILE_OPERATIONS_SAVE_EVENTS_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_SAVE_EVENTS_DBG = false;
//final static boolean PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR = true;
final static boolean PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR = false;

//final static boolean PRINT_FILE_OPERATIONS_SAVE_ALWAYS_DBG = true;
final static boolean PRINT_FILE_OPERATIONS_SAVE_ALWAYS_DBG = false;
//final static boolean PRINT_FILE_OPERATIONS_SAVE_ALWAYS_ERR = true;
final static boolean PRINT_FILE_OPERATIONS_SAVE_ALWAYS_ERR = false;

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

static class File_Operations_save_always_data {
  private int instance;
  private byte[] data_buf;
  private long date_time;
  private String save_events_dir_full_name;

  File_Operations_save_always_data(int instance, byte[] data_buf, long date_time, String save_events_dir_full_name) {
    this.instance = instance;
    this.data_buf = data_buf;
    this.date_time = date_time;
    this.save_events_dir_full_name = save_events_dir_full_name;
  }
}
static ConcurrentLinkedQueue<File_Operations_save_always_data> File_Operations_save_always_queue = new ConcurrentLinkedQueue<File_Operations_save_always_data>();

void File_Operations_setup()
{
  String always_dir_full_name;
  if (OS_is_Windows)
  {
    always_dir_full_name = sketchPath() + "\\always\\";
  }
  else
  {
    always_dir_full_name = sketchPath() + "/always/";
  }
  File always_dir_handle = new File(always_dir_full_name);
  //println("data_time="+data_time+",millis()="+millis());
  // Check exists the always directory.
  File_Operations_always_dir_ready = true;
  if (!always_dir_handle.isDirectory())
  {
    if (!always_dir_handle.mkdir())
    {
      if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SETUP_ERR) println("File_Operations_setup():mkdir() error! "+always_dir_full_name);
      SYSTEM_logger.severe("File_Operations_setup():mkdir() error! "+always_dir_full_name);
      File_Operations_always_dir_ready = false;
    }
  }

  String events_dir_full_name;
  if (OS_is_Windows)
  {
    events_dir_full_name = sketchPath() + "\\events\\";
  }
  else
  {
    events_dir_full_name = sketchPath() + "/events/";
  }
  File events_dir_handle = new File(events_dir_full_name);
  //println("data_time="+data_time+",millis()="+millis());
  // Check exists the always directory.
  File_Operations_events_dir_ready = true;
  if (!events_dir_handle.isDirectory())
  {
    if (!events_dir_handle.mkdir())
    {
      if (PRINT_FILE_OPERATIONS_ALL_ERR) println("File_Operations_setup():mkdir() error! "+events_dir_full_name);
      File_Operations_events_dir_ready = false;
      SYSTEM_logger.severe("File_Operations_setup():mkdir() error! "+events_dir_full_name);
    }
  }

  if (File_Operations_setup_done) return;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    File_Operations_save_events_state[i] = File_Operations_save_events_state_enum.IDLE;
  }

  File_Operations_free_threads_pause = false;
  thread("File_Operations_free_events");
  thread("File_Operations_free_always");
  thread("File_Operations_save_events");
  thread("File_Operations_save_always");
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
  String events_dir_full_name;
  if (OS_is_Windows)
  {
    events_dir_full_name = sketchPath() + "\\events\\";
  }
  else
  {
    events_dir_full_name = sketchPath() + "/events/";
  }
  File events_dir_handle = new File(events_dir_full_name);
  Path events_dir_full_path = Paths.get(events_dir_full_name);
  DirectoryStream<Path> events_dirs_list;

  delay(FRAME_TIME * 1 / 4);
  do
  {
    delay(1000); // 1s

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

    // Get dirs list.
    try
    {
      events_dirs_list = Files.newDirectoryStream(events_dir_full_path);
    }
    catch (IOException e) {
      // An I/O problem has occurred
      if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR) println("File_Operations_free_events():Files.newDirectoryStream err!"+"\n\t"+e.toString());
      SYSTEM_logger.severe("File_Operations_free_events():Files.newDirectoryStream err!"+"\n\t"+e.toString());
      continue;
    }

    for (Path events_subdir_path:events_dirs_list)
    {
      String events_subdir_name = events_subdir_path.getFileName().toString();
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():events_subdir_name="+events_subdir_name);

      String events_subdir_full_name;
      if (OS_is_Windows)
      {
        events_subdir_full_name = events_dir_full_name+events_subdir_name+"\\";
      }
      else
      {
        events_subdir_full_name = events_dir_full_name+events_subdir_name+"/";
      }

      File events_subdir_handle;
      events_subdir_handle = new File(events_subdir_full_name);
      if (!events_subdir_handle.isDirectory()) {
        if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR) println("File_Operations_free_events():Directory not exist or not a directory!:"+events_dir_full_name+events_subdir_name+"/");
        SYSTEM_logger.severe("File_Operations_free_events():Directory not exist or not a directory!:"+events_dir_full_name+events_subdir_name+"/");
        events_subdir_handle.delete();
        delay(1);
        continue;
      }

      // Get files list on subdir.
      DirectoryStream<Path> events_subdir_files_list;
      try
      {
        events_subdir_files_list = Files.newDirectoryStream(Paths.get(events_subdir_full_name));
      }
      catch (IOException e) {
        // An I/O problem has occurred
        if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR) println("File_Operations_free_events():Files.newDirectoryStream err!"+"\n\t"+e.toString());
        SYSTEM_logger.severe("File_Operations_free_events():Files.newDirectoryStream err!"+"\n\t"+e.toString());
        //if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():no files on sub directory! "+events_dir_full_name+events_subdir_name+"/");
        events_subdir_handle.delete();
        delay(1);
        continue;
      }

      int delete_start_millis = millis();
      //int delete_count = 0;

      for (Path events_file_path:events_subdir_files_list)
      {
        String events_file_name = events_file_path.getFileName().toString();
        //if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():events_file_name="+events_file_name);
        File events_file_handle = new File(events_subdir_full_name+events_file_name);
        if (!events_file_handle.isFile()) {
          if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR) println("File_Operations_free_events():File not exist or not a file!:"+events_dir_full_name+events_subdir_name+"/"+events_file_name);
          SYSTEM_logger.severe("File_Operations_free_events():File not exist or not a file!:"+events_dir_full_name+events_subdir_name+"/"+events_file_name);
          continue;
        }
        events_file_handle.delete();
        //delete_count ++;

        // Check delete operation is too late by frame time.
        if (get_millis_diff(delete_start_millis) > FRAME_TIME)
        {
          //SYSTEM_logger.warning("File_Operations_free_events():delete operation take long time!:"+delete_count+","+get_millis_diff(delete_start_millis));
          delay(FRAME_TIME);
          delete_start_millis = millis();
          //delete_count = 0;
        }
      } // End of for (Path events_file_path:events_subdir_files_list)

      // Close list of DirectoryStream.
      try
      {
        events_subdir_files_list.close();
      }
      catch (IOException e) {
        // An I/O problem has occurred
        if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR) println("File_Operations_free_events():DirectoryStream events_subdir_files_list.close() err!"+"\n\t"+e.toString());
        SYSTEM_logger.severe("File_Operations_free_events():DirectoryStream events_subdir_files_list.close() err!"+"\n\t"+e.toString());
      }
      events_subdir_files_list = null;

      events_subdir_handle.delete();
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_EVENTS_DBG) println("File_Operations_free_events():delete done! "+events_subdir_name);
      break;
    } // End of for (Path events_subdir_path:events_dirs_list)

    // Close list of DirectoryStream.
    try
    {
      events_dirs_list.close();
    }
    catch (IOException e) {
      // An I/O problem has occurred
      if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_EVENTS_ERR) println("File_Operations_free_events():DirectoryStream events_dirs_list.close() err!"+"\n\t"+e.toString());
      SYSTEM_logger.severe("File_Operations_free_events():DirectoryStream events_dirs_list.close() err!"+"\n\t"+e.toString());
    }
    events_dirs_list = null;

  } while (true);
}

void File_Operations_free_always()
{
  String always_dir_full_name;
  if (OS_is_Windows)
  {
    always_dir_full_name = sketchPath() + "\\always\\";
  }
  else
  {
    always_dir_full_name = sketchPath() + "/always/";
  }
  File always_dir_handle = new File(always_dir_full_name);
  Path always_dir_full_path = Paths.get(always_dir_full_name);
  DirectoryStream<Path> always_files_list;
  
  delay(FRAME_TIME * 2 / 4);
  do
  {
    delay(1000); // 1s

    if (File_Operations_free_threads_pause) continue;

    if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_ALWAYS_DBG) println("File_Operations_free_always():Run"+millis());
    //println("File_Operations_free_always():Run"+millis());

    if (!always_dir_handle.isDirectory()) {
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_FREE_ALWAYS_DBG) println("File_Operations_free_always():always directory is not ready!");
      continue;
    }

    // Get files list to decide delete file.
    try
    {
      always_files_list = Files.newDirectoryStream(always_dir_full_path);
    }
    catch (IOException e) {
      // An I/O problem has occurred
      if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_ALWAYS_ERR) println("File_Operations_free_always():Files.newDirectoryStream err!"+"\n\t"+e.toString());
      SYSTEM_logger.severe("File_Operations_free_always():Files.newDirectoryStream err!"+"\n\t"+e.toString());
      continue;
    }

    // Get target date time for delete always file.
    long target_date_time =
      new Date().getTime()
      -
      PS_DATA_SAVE_ALWAYS_DURATION*60*60*1000L;
    //Dbg_Time_logs_handle.add("Date().getTime()");

    int delete_start_millis = millis();
    //int delete_count = 0;

    for (Path always_file_path:always_files_list)
    {
      String always_file_name = always_file_path.getFileName().toString();
      //println("File_Operations_free_always():always_file_name="+always_file_name);

      long file_date_time;
      try {
        file_date_time = Long.parseLong(always_file_name.substring(2, always_file_name.length() - 4));
      }
      catch (NumberFormatException e) {
        file_date_time = target_date_time; // to delete file.
      }
      if (file_date_time > target_date_time) continue;
      //println(always_file_name+","+file_date_time);

      File always_file_handle;
      always_file_handle = new File(always_dir_full_name+always_file_name);
      if (!always_file_handle.isFile()) {
        if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_ALWAYS_ERR) println("File_Operations_free_always():File not exist or not a file!:"+always_dir_full_name+always_file_name);
        SYSTEM_logger.severe("File_Operations_free_always():File not exist or not a file!:"+always_dir_full_name+always_file_name);
        continue;
      }
      always_file_handle.delete();
      //delete_count ++;

      // Check delete operation is too late by frame time.
      if (get_millis_diff(delete_start_millis) > FRAME_TIME)
      {
        //SYSTEM_logger.warning("File_Operations_free_always():delete operation take long time!:"+delete_count+","+get_millis_diff(delete_start_millis));
        delay(FRAME_TIME);
        delete_start_millis = millis();
        //delete_count = 0;
      }
    } // End of for (Path always_file_path:always_files_list)

    // Close list of DirectoryStream.
    try
    {
      always_files_list.close();
    }
    catch (IOException e) {
      // An I/O problem has occurred
      if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_FREE_ALWAYS_ERR) println("File_Operations_free_always():DirectoryStream events_dirs_list.close() err!"+"\n\t"+e.toString());
      SYSTEM_logger.severe("File_Operations_free_always():DirectoryStream events_dirs_list.close() err!"+"\n\t"+e.toString());
    }
    always_files_list = null;

  } while (true);
}

void File_Operations_save_events()
{
  String data_dir_full_name;
  String always_dir_full_name;
  if (OS_is_Windows)
  {
    data_dir_full_name = sketchPath() + "\\data\\";
    always_dir_full_name = sketchPath() + "\\always\\";
  }
  else
  {
    data_dir_full_name = sketchPath() + "/data/";
    always_dir_full_name = sketchPath() + "/always/";
  }

  Path always_dir_full_path = Paths.get(always_dir_full_name);
  DirectoryStream<Path>[] always_files_list = new DirectoryStream[PS_INSTANCE_MAX];
  Iterator<Path>[] always_files_list_iterator = new Iterator[PS_INSTANCE_MAX];

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
      else
      {
        delay(1);
      }

      //println("File_Operations_save_events():"+":File_Operations_save_events_state["+instance+"]="+File_Operations_save_events_state[instance]);
      switch (File_Operations_save_events_state[instance])
      {
        case IDLE:
          // Set pause state of Disk Space free threads to save events files.
          File_Operations_free_threads_pause = true;

          SYSTEM_logger.info("File_Operations_save_events():"+instance+":save events start!");  

          // Make save events dir.
          File save_events_dir_handle;
          save_events_dir_handle = new File(File_Operations_save_events_dir_full_name[instance]);
          if (!save_events_dir_handle.isDirectory())
          {
            if (!save_events_dir_handle.mkdirs())
            {
              if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR) println("File_Operations_save_events():" + instance + ":mkdirs() error! " + File_Operations_save_events_dir_full_name[instance]);
              SYSTEM_logger.severe("File_Operations_save_events():" + instance + ":mkdirs() error! " + File_Operations_save_events_dir_full_name[instance]);
              // Reset pause state of Disk Space free threads to save events files.
              File_Operations_free_threads_pause = false;
              break;
            }
          }

          // Get always files list of instance to copy.
          try
          {
            always_files_list[instance] = Files.newDirectoryStream(always_dir_full_path, instance+"_*.dat");
          }
          catch (IOException e) {
            // An I/O problem has occurred
            if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR) println("File_Operations_save_events():" + instance + ":Files.newDirectoryStream err!"+"\n\t"+e.toString());
            SYSTEM_logger.severe("File_Operations_save_events():" + instance + ":Files.newDirectoryStream err!"+"\n\t"+e.toString());
            // Reset pause state of Disk Space free threads to save events files.
            File_Operations_free_threads_pause = false;
            break;
          }

          // Get list iterator.
          always_files_list_iterator[instance] = always_files_list[instance].iterator();

          // Copy config files on data dir to events dir.
          ArrayList<String> data_files_list = new ArrayList<String>();

          // Set files on data dir to copy.
          data_files_list.add(CONST_FILE_NAME + CONST_FILE_EXT);
          data_files_list.add(CONFIG_FILE_NAME + "_" + instance + CONFIG_FILE_EXT);
          data_files_list.add(REGIONS_FILE_NAME + "_" + instance + REGIONS_FILE_EXT);
          data_files_list.add(RELAY_MODULE_RELAYS_FILE_NAME + RELAY_MODULE_RELAYS_FILE_EXT);
          data_files_list.add(BG_IMAGE_FILE_NAME + BG_IMAGE_FILE_EXT);

          // Loop for files.          
          for (String data_file_name:data_files_list)
          {
            // Check file is exist and is file.
            File data_file_handle;
            data_file_handle = new File(data_dir_full_name + data_file_name);
            if (!data_file_handle.isFile()) {
              if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR) println("File_Operations_save_events():" + instance + ":File not exist or not a file!:"+data_dir_full_name + data_file_name);
              SYSTEM_logger.severe("File_Operations_save_events():" + instance + ":File not exist or not a file!:"+data_dir_full_name + data_file_name);
              continue;
            }
            // Copy file to events dir.
            if (!copy_file(
                  data_dir_full_name + data_file_name,
                  File_Operations_save_events_dir_full_name[instance] + data_file_name,
                  new CopyOption[] {StandardCopyOption.COPY_ATTRIBUTES}))
            {
              if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR) println("File_Operations_save_events():" + instance + ":copy_file() error!" + "\n\t" + data_dir_full_name + data_file_name + "->" + "\n\t" + File_Operations_save_events_dir_full_name[instance] + data_file_name + "\n\t" + copy_file_error);
              SYSTEM_logger.severe("File_Operations_save_events():" + instance + ":copy_file() error!" + "\n\t" + data_dir_full_name + data_file_name + "->" + "\n\t" + File_Operations_save_events_dir_full_name[instance] + data_file_name + "\n\t" + copy_file_error);
            }
          }

          // Set state to next.
          File_Operations_save_events_state[instance] = File_Operations_save_events_state_enum.COPY_ALWAYS_TO_EVENTS;

          break;

        case COPY_ALWAYS_TO_EVENTS:
          int copy_start_millis = millis();
          //int copy_count = 0;
          File always_file_handle;
          for (; always_files_list_iterator[instance].hasNext();)
          {
            Path always_file_path = always_files_list_iterator[instance].next();

            String always_file_name = always_file_path.getFileName().toString();
            //println("File_Operations_save_events("+instance+"):always_file_name="+always_file_name);

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

            // Check file is exist and is file.
            always_file_handle = new File(always_dir_full_name+always_file_name);
            if (!always_file_handle.isFile()) {
              if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR) println("File_Operations_save_events():" + instance + ":File not exist or not a file!:"+always_dir_full_name+always_file_name);
              SYSTEM_logger.severe("File_Operations_save_events():" + instance + ":File not exist or not a file!:"+always_dir_full_name+always_file_name);
              continue;
            }

            // Copy data file on always dir to events dir.
            if (!copy_file(
                  always_dir_full_name + always_file_name,
                  File_Operations_save_events_dir_full_name[instance] + always_file_name,
                  new CopyOption[] {StandardCopyOption.COPY_ATTRIBUTES}))
            {
              if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR) println("File_Operations_save_events():" + instance + ":copy_file() error!" + "\n\t" + always_dir_full_name + always_file_name + "->" + "\n\t" + File_Operations_save_events_dir_full_name[instance] + always_file_name + "\n\t" + copy_file_error);
              SYSTEM_logger.severe("File_Operations_save_events():" + instance + ":copy_file() error!" + "\n\t" + always_dir_full_name + always_file_name + "->" + "\n\t" + File_Operations_save_events_dir_full_name[instance] + always_file_name + "\n\t" + copy_file_error);
            }
            //copy_count ++;

            //delay(1);
            // Check copy operation is too late by frame time.
            if (get_millis_diff(copy_start_millis) > FRAME_TIME)
            {
              //SYSTEM_logger.warning("File_Operations_save_events():copy operation take long time!:"+copy_count+","+get_millis_diff(copy_start_millis));
              break;
            }
          } // End of for (; always_files_list_iterator[instance].hasNext();)

          // Check end of iterator.
          if (always_files_list_iterator[instance].hasNext())
          {
            // Files remained. come back this switch case.
            break;
          }

          // Close list of DirectoryStream.
          try
          {
            always_files_list[instance].close();
          }
          catch (IOException e) {
            // An I/O problem has occurred
            if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_EVENTS_ERR) println("File_Operations_save_events():"+instance+":DirectoryStream close() err!"+"\n\t"+e.toString());
            SYSTEM_logger.severe("File_Operations_save_events():"+instance+":DirectoryStream close() err!"+"\n\t"+e.toString());
          }
          always_files_list[instance] = null;

          File_Operations_save_events_state[instance] = File_Operations_save_events_state_enum.WAIT_WRITE_EVENTS_DONE;
          // Reset pause state of Disk Space free threads to save events files.
          File_Operations_free_threads_pause = false;

          break;

        case WAIT_WRITE_EVENTS_DONE:
          // Check write done of save events.
          if (!File_Operations_save_events_write_events_done[instance]) break;

          File_Operations_save_events_state[instance] = File_Operations_save_events_state_enum.DONE;

          break;

        case DONE:
          //println("File_Operations_save_events():"+instance+":save events done!");
          SYSTEM_logger.info("File_Operations_save_events():"+instance+":save events done!");  
          File_Operations_save_events_done[instance] = true;
          File_Operations_save_events_state[instance] = File_Operations_save_events_state_enum.IDLE;

          break;
      }
    }
  } while (true);
}

void File_Operations_save_always()
{
  File_Operations_save_always_data save_always_data;
  String always_dir_full_name;
  if (OS_is_Windows)
  {
    always_dir_full_name = sketchPath() + "\\always\\";
  }
  else
  {
    always_dir_full_name = sketchPath() + "/always/";
  }

  delay(FRAME_TIME * 4 / 4);
  do
  {
    delay(FRAME_TIME);

    while ((save_always_data = File_Operations_save_always_queue.poll()) != null)
    {
      if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_SAVE_ALWAYS_DBG) println("File_Operations_save_always()" + ":instance=" + save_always_data.instance + ",date_time=" + save_always_data.date_time + ",data_buf=" + save_always_data.data_buf);

      // Write data file to always.
      if (
        !write_file(
          save_always_data.data_buf,
          always_dir_full_name+save_always_data.instance+"_"+save_always_data.date_time+".dat"))
      {
        if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_ALWAYS_ERR) println("File_Operations_save_always()" + ":" + save_always_data.instance + ":write_file() error! " + always_dir_full_name+save_always_data.instance+"_"+save_always_data.date_time+".dat" + "\n\t" + write_file_error);
        SYSTEM_logger.severe("File_Operations_save_always()" + ":" + save_always_data.instance + ":write_file() error! " + always_dir_full_name+save_always_data.instance+"_"+save_always_data.date_time+".dat" + "\n\t" + write_file_error);
      }

      if (save_always_data.save_events_dir_full_name != null)
      {
        // Make save events dir.
        File save_events_dir_handle;
        save_events_dir_handle = new File(save_always_data.save_events_dir_full_name);
        if (!save_events_dir_handle.isDirectory())
        {
          if (!save_events_dir_handle.mkdirs())
          {
            if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_ALWAYS_ERR) println("File_Operations_save_always()" + ":" + save_always_data.instance + ":mkdirs() error! " + save_always_data.save_events_dir_full_name);
            SYSTEM_logger.severe("File_Operations_save_always()" + ":" + save_always_data.instance + ":mkdirs() error! " + save_always_data.save_events_dir_full_name);
            //break;
          }
        }

        // Write data file to events dir.
        if (
          !write_file(
            save_always_data.data_buf,
            save_always_data.save_events_dir_full_name+save_always_data.instance+"_"+save_always_data.date_time+".dat"))
        {
          if (PRINT_FILE_OPERATIONS_ALL_ERR || PRINT_FILE_OPERATIONS_SAVE_ALWAYS_ERR) println("File_Operations_save_always()" + ":" + save_always_data.instance + ":write_file() error! " + always_dir_full_name+save_always_data.instance+"_"+save_always_data.date_time+".dat" + "\n\t" + write_file_error);
          SYSTEM_logger.severe("File_Operations_save_always()" + ":" + save_always_data.instance + ":write_file() error! " + always_dir_full_name+save_always_data.instance+"_"+save_always_data.date_time+".dat" + "\n\t" + write_file_error);
        }
      }
    } // End of while ((save_always_data = File_Operations_save_always_queue.poll()) != null)
    if (PRINT_FILE_OPERATIONS_ALL_DBG || PRINT_FILE_OPERATIONS_SAVE_ALWAYS_DBG) println("File_Operations_save_always()" + ":queue empty!");
  } while (true);
}
