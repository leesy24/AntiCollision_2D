Dbg_Time_logs Dbg_Time_logs_handle = new Dbg_Time_logs();

class Dbg_Time_logs {
  private LinkedList<Dbg_Time_log> time_logs = new LinkedList<Dbg_Time_log>();
  private String str;
  private int start;
  private int diff;
  private int limit;
  private int last = -1;
  private int add_diff;
  private boolean stop;
  private boolean stop_print;

  Dbg_Time_logs() {}

  void start(String str, int limit, boolean stop) {
    this.str = str;
    this.limit = limit;
    this.stop = stop;
    this.time_logs.clear();
    this.last = -1;
    this.start = millis();
    this.stop_print = false;
  }

  int get_diff() {
    return diff;
  }

  int get_add_diff() {
    return add_diff;
  }

  void add(String str) {
    diff = get_millis_diff(start);
    if (last == -1)
      add_diff = 0;
    else
      add_diff = diff - last;
    time_logs.add(new Dbg_Time_log(diff, add_diff, str));
    last = diff;
    if (diff > limit) {
      if (!stop_print) print();
      if (stop) stop_print = true;
    }
  }

  void print() {
    println(str);
    SYSTEM_logger.warning(str);  
    for (Dbg_Time_log time_log:time_logs) {
      println("\t"+time_log.str+":"+time_log.time+","+time_log.diff);
      SYSTEM_logger.warning("\t"+time_log.str+":"+time_log.time+","+time_log.diff);  
    }
  }
}

class Dbg_Time_log {
  int time, diff;
  String str;
  Dbg_Time_log(int time, int diff, String str) {
    this.time = time;
    this.diff = diff;
    this.str = str;
  }
}
