final static long DISK_SPACE_FREE_LIMIT = 1L*1024L*1024L*1024L; // 1GB

void Disk_Space_free()
{
	String events_dir_full_name = sketchPath("events\\");
	File events_dir_handle = new File(events_dir_full_name);

	long free_space = events_dir_handle.getFreeSpace();
	//println("Disk free space is "+free_space+" at "+events_dir_full_name);
	if (free_space > DISK_SPACE_FREE_LIMIT) return;

	// get files list.
	String[] events_dirs_list = events_dir_handle.list();
	if (events_dirs_list == null) return;
	//println("events_dirs_list.length="+events_dirs_list.length);
	if (events_dirs_list.length <= 10) return;

  int delete_start_millis = millis();
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
	      if (get_millis_diff(delete_start_millis) >= (FRAME_TIME / 2)) break;
			}
		}
    // Check delete operation is too late by frame time.
    if (get_millis_diff(delete_start_millis) >= (FRAME_TIME / 2)) break;
		events_dir_handle.delete();
		break;
	}
}
