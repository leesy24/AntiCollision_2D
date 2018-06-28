import garciadelcastillo.dashedlines.*;

//final static boolean PRINT_REGIONS_ALL_DBG = true; 
final static boolean PRINT_REGIONS_ALL_DBG = false;

//final static boolean PRINT_REGIONS_SETUP_DBG = true; 
final static boolean PRINT_REGIONS_SETUP_DBG = false;

//final static boolean PRINT_REGIONS_UPDATE_DBG = true; 
final static boolean PRINT_REGIONS_UPDATE_DBG = false;

//final static boolean PRINT_REGIONS_DRAW_DBG = true; 
final static boolean PRINT_REGIONS_DRAW_DBG = false;

//final static boolean PRINT_REGIONS_POINT_IS_CONTAINS_DBG = true; 
final static boolean PRINT_REGIONS_POINT_IS_CONTAINS_DBG = false;

// Define default table filename and ext.
final static String REGIONS_FILE_NAME = "regions";
final static String REGIONS_FILE_EXT = ".csv";

Regions Regions_handle;
DashedLines DashedLines_handle;

void Regions_setup()
{
  if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_SETUP_DBG) println("Regions_setup():Enter");

  Regions_handle = new Regions();
  Regions_handle.setup();

  DashedLines_handle = new DashedLines(this);
}

void Regions_update()
{
  Regions_handle.update();
}

void Regions_draw()
{
  Regions_handle.draw();
}

int Regions_check_point_contains(int instance, int mi_x, int mi_y)
{
  return Regions_handle.point_is_over(instance, mi_x, mi_y);
}

class Regions {
  LinkedList<Region_Data>[] regions_array = new LinkedList[PS_INSTANCE_MAX];
  int[] regions_priority_max = new int[PS_INSTANCE_MAX];

  Regions() {
    for (int instance = 0; instance < PS_INSTANCE_MAX; instance ++) {
      regions_array[instance] = new LinkedList<Region_Data>();
      regions_priority_max[instance] = MIN_INT;

      String file_full_name;
      Table table;

      file_full_name = REGIONS_FILE_NAME + "_" + instance + REGIONS_FILE_EXT;

      // Load lines file(CSV type) into a Table object
      // "header" option indicates the file has a header row
      table = loadTable(file_full_name, "header");
      // Check loadTable failed.
      if(table == null) {
        return;
      }

      for (TableRow variable:table.rows()) {
        String name = variable.getString("Name");
        // If name start with # than skip it.
        if (name.charAt(0) == '#') {
          continue;
        }
        Region_Data region_data =
          new Region_Data(
            name,
            variable.getInt("Priority"));
        if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_SETUP_DBG) println("Regions:settings():"+instance+":region_data:"+"name="+region_data.name+",priority="+region_data.priority);

        regions_priority_max[instance] = max(regions_priority_max[instance], region_data.priority);

        region_data.relay_index = variable.getInt("Relay_Num");
        if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_SETUP_DBG) println("Regions:settings():"+instance+":region_data:"+"name="+region_data.name+",relay_index="+region_data.relay_index);

        region_data.no_mark_big = (variable.getString("No_Mark_Big").toLowerCase().equals("true"))?true:false; 
        if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_SETUP_DBG) println("Regions:settings():"+instance+":region_data:"+"name="+region_data.name+",no_mark_big="+region_data.no_mark_big);
        //println("Regions:settings():"+instance+":region_data:"+"name="+region_data.name+",no_mark_big="+region_data.no_mark_big);

        color first_color, other_color;
        region_data.set_rect_data(
          variable.getInt("Rect_X") * 100,
          variable.getInt("Rect_Y") * 100,
          variable.getInt("Rect_Width") * 100,
          variable.getInt("Rect_Height") * 100,
          (int)Long.parseLong(variable.getString("Rect_First_Color"), 16),
          (int)Long.parseLong(variable.getString("Rect_Color"), 16),
          variable.getInt("Rect_Weight"),
          variable.getInt("Rect_Dashed"));
        if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_SETUP_DBG) println("Regions:settings():"+instance+":region_data:"+"x="+region_data.rect_mi_x+",y="+region_data.rect_mi_y+",w="+region_data.rect_mi_width+",h="+region_data.rect_mi_height);
        //if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_SETUP_DBG) println("Regions:settings():"+instance+"region_data:"+"f_c="+region_data.first_color+",c="+region_data.other_color+",w="+region_data.weight);
        //println("Regions:settings():"+instance+":region_data:"+"name="+region_data.name+",Rect_First_Color="+(int)Long.parseLong(variable.getString("Rect_First_Color"), 16));

        region_data.set_marker_data(
          (int)Long.parseLong(variable.getString("Marker_Stroke_Color"), 16),
          variable.getInt("Marker_Stroke_Weight"),
          (int)Long.parseLong(variable.getString("Marker_Fill_Color"), 16));
        if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_SETUP_DBG) println("Regions:settings():"+instance+":region_data:"+"m_s_c="+region_data.marker_stroke_color+",m_s_w="+region_data.marker_stroke_weight+",m_f_c="+region_data.marker_fill_color);

        regions_array[instance].add(region_data);
      }
    }
  }

  void setup() {
    update();
  }

  void update() {
    for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++) {
      update_instance(instance);
    }
  }

  void update_instance(int instance) {
    for (Region_Data region_data:regions_array[instance]) {
      int mi_x, mi_y;
      int scr_x, scr_y;
      final int offset_x =
        (ROTATE_FACTOR[instance] == 315)
        ?
        (TEXT_MARGIN + FONT_HEIGHT / 2)
        :
        (
          (ROTATE_FACTOR[instance] == 135)
          ?
          (SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT / 2))
          :
          (SCREEN_width / 2)
        );
      final int offset_y =
        (ROTATE_FACTOR[instance] == 45)
        ?
        (TEXT_MARGIN + FONT_HEIGHT / 2)
        :
        (
          (ROTATE_FACTOR[instance] == 225)
          ?
          (SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT / 2))
          :
          (SCREEN_height / 2)
        );

      for (int i = 0; i < region_data.points_data.length; i ++) {
        mi_x = region_data.points_data.mi_x[i];
        mi_y = region_data.points_data.mi_y[i];
        if (PRINT_REGIONS_UPDATE_DBG) println("update("+instance+"):points_data[" + i + "],mi_x=" + mi_x + ",mi_y=" + mi_y);
        if (mi_x == MIN_INT || mi_y == MIN_INT) {
          // Save coordinate data for drawing line on screen. 
          region_data.points_data.scr_x[i] = MIN_INT;
          region_data.points_data.scr_y[i] = MIN_INT;
          continue;
        }

        if (ROTATE_FACTOR[instance] == 315) {
          scr_x = int(mi_y / ZOOM_FACTOR[instance]);
          scr_y = int(mi_x / ZOOM_FACTOR[instance]);
          scr_x += offset_x;
          if (MIRROR_ENABLE[instance])
            scr_y += offset_y;
          else
            scr_y = offset_y - scr_y;
        }
        else if (ROTATE_FACTOR[instance] == 45) {
          scr_x = int(mi_x / ZOOM_FACTOR[instance]);
          scr_y = int(mi_y / ZOOM_FACTOR[instance]);
          if (MIRROR_ENABLE[instance])
            scr_x = offset_x - scr_x;
          else
            scr_x += offset_x;
          scr_y += offset_y;
        }
        else if (ROTATE_FACTOR[instance] == 135) {
          scr_x = int(mi_y / ZOOM_FACTOR[instance]);
          scr_y = int(mi_x / ZOOM_FACTOR[instance]);
          scr_x = offset_x - scr_x; 
          if (MIRROR_ENABLE[instance])
            scr_y = offset_y - scr_y;
          else
            scr_y += offset_y;
        }
        else /*if(ROTATE_FACTOR[instance] == 225)*/ {
          scr_x = int(mi_x / ZOOM_FACTOR[instance]);
          scr_y = int(mi_y / ZOOM_FACTOR[instance]);
          if (MIRROR_ENABLE[instance])
            scr_x += offset_x;
          else
            scr_x = offset_x - scr_x;
          scr_y = offset_y - scr_y;
        }
        scr_x += DRAW_OFFSET_X[instance];
        scr_y += DRAW_OFFSET_Y[instance];

        // Save coordinate data for drawing line on screen. 
        region_data.points_data.scr_x[i] = scr_x;
        region_data.points_data.scr_y[i] = scr_y;
      }
    }
  }

  void draw() {
    for( int instance = 0; instance < PS_INSTANCE_MAX; instance ++) {
      draw_instance(instance);
    }
  }

  void draw_instance(int instance) {
    for (int priority = regions_priority_max[instance]; priority >= 0; priority --) {
      for (Region_Data region_data:regions_array[instance]) {
        if (region_data.priority != priority) {
          continue;
        }
        int x_curr, y_curr;
        int w_curr;
        color c_curr;
        int x_prev, y_prev;
        int w_prev;
        color c_prev;
        int i = 0;

        if (region_data.rect_dashed_gap > 0) {
          DashedLines_handle.pattern(region_data.rect_dashed_gap, region_data.rect_dashed_gap);
        }
        x_prev = region_data.points_data.scr_x[i];
        y_prev = region_data.points_data.scr_y[i];
        w_prev = region_data.points_data.w[i];
        c_prev = region_data.points_data.c[i];
        i ++;

        for (; i < region_data.points_data.length; i ++) {
          x_curr = region_data.points_data.scr_x[i];
          y_curr = region_data.points_data.scr_y[i];
          w_curr = region_data.points_data.w[i];
          c_curr = region_data.points_data.c[i];
          //if (PRINT_REGIONS_DRAW_DBG) println("Regions:draw_instance("+instance+"):points_data[" + i + "],x_curr=" + x_curr + ",y_curr=" + y_curr + ",w_curr=" + w_curr + ",c_curr=" + c_curr);

          fill(c_prev);
          // Sets the color and weight used to draw lines and borders around shapes.
          stroke(c_prev);
          strokeWeight(w_prev);
          if (region_data.rect_dashed_gap > 0) {
            DashedLines_handle.line(x_prev, y_prev, x_curr, y_curr);
          }
          else
          {
            line(x_prev, y_prev, x_curr, y_curr);
          }

          // Save data for drawing line between previous and current points. 
          x_prev = x_curr;
          y_prev = y_curr;
          w_prev = w_curr;
          c_prev = c_curr;
        }
      }
    }
  }

  int point_is_over(int instance, int point_mi_x, int point_mi_y) {
    if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_POINT_IS_CONTAINS_DBG) println("point_is_over("+instance+"):point_mi_x=" + point_mi_x + ",point_mi_y=" + point_mi_y);

    int region_index = -1;

    for (int priority = 0; priority <= regions_priority_max[instance]; priority ++) {
      for (region_index = regions_array[instance].size() - 1; region_index >= 0; region_index --) {
        Region_Data region_data = regions_array[instance].get(region_index);
        if (priority == region_data.priority) {
          if (is_point_over_rect(
                point_mi_x, point_mi_y,
                region_data.rect_mi_x, region_data.rect_mi_y,
                region_data.rect_mi_width, region_data.rect_mi_height)) {
            break;
          }
        }
      }
      if (region_index != -1) break;
    }

    if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_POINT_IS_CONTAINS_DBG) println("point_is_over("+instance+"):region_index=" + region_index);

    return region_index;
  }

  LinkedList<Integer> get_region_indexes_contains_point(int instance, int point_mi_x, int point_mi_y) {
    LinkedList<Integer> region_indexes = new LinkedList<Integer>();

    if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_POINT_IS_CONTAINS_DBG) println("get_region_indexes_contains_point("+instance+"):point_mi_x=" + point_mi_x + ",point_mi_y=" + point_mi_y);

    for (int priority = 0; priority <= regions_priority_max[instance]; priority ++) {
    //for (int priority = regions_priority_max[instance]; priority >= 0; priority --) {
      for (int region_index = 0; region_index < regions_array[instance].size(); region_index ++) {
        Region_Data region_data = regions_array[instance].get(region_index);
        if (priority != region_data.priority) {
          continue;
        }
        if (is_point_over_rect(
              point_mi_x, point_mi_y,
              region_data.rect_mi_x, region_data.rect_mi_y,
              region_data.rect_mi_width, region_data.rect_mi_height)) {
          region_indexes.add(region_index);
          //println("get_region_indexes_contains_point("+instance+"):region_index=" + region_index);
        }
      }
    }

    if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_POINT_IS_CONTAINS_DBG) println("get_region_indexes_contains_point("+instance+"):region_indexes.size()=" + region_indexes.size());

    return region_indexes;
  }

  boolean regions_are_over(int instance, int region_a_index, int region_b_index) {
    if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_POINT_IS_CONTAINS_DBG) println("regions_are_over("+instance+"):region_a_index=" + region_a_index + ",region_b_index=" + region_b_index);

    boolean ret = false;

    if (region_a_index == region_a_index) {
      ret = true;
    }
    else {
      Region_Data region_a_data = regions_array[instance].get(region_a_index);
      Region_Data region_b_data = regions_array[instance].get(region_a_index);

      if (
        is_point_over_rect(
          region_a_data.rect_mi_x, region_a_data.rect_mi_y,
          region_b_data.rect_mi_x, region_b_data.rect_mi_y,
          region_b_data.rect_mi_width, region_b_data.rect_mi_height)) {
        ret = true;
      }
      else if (
        is_point_over_rect(
          region_a_data.rect_mi_x + region_a_data.rect_mi_width, region_a_data.rect_mi_y,
          region_b_data.rect_mi_x, region_b_data.rect_mi_y,
          region_b_data.rect_mi_width, region_b_data.rect_mi_height)) {
        ret = true;
      }
      else if (
        is_point_over_rect(
          region_a_data.rect_mi_x, region_a_data.rect_mi_y + region_a_data.rect_mi_height,
          region_b_data.rect_mi_x, region_b_data.rect_mi_y,
          region_b_data.rect_mi_width, region_b_data.rect_mi_height)) {
        ret = true;
      }
      else if (
        is_point_over_rect(
          region_a_data.rect_mi_x + region_a_data.rect_mi_width, region_a_data.rect_mi_y + region_a_data.rect_mi_height,
          region_b_data.rect_mi_x, region_b_data.rect_mi_y,
          region_b_data.rect_mi_width, region_b_data.rect_mi_height)) {
        ret = true;
      }
    }

    if (PRINT_REGIONS_ALL_DBG || PRINT_REGIONS_POINT_IS_CONTAINS_DBG) println("regions_are_over("+instance+"):ret=" + ret);

    return ret;
  }

  int get_regions_size_for_index(int instance) {
    return regions_array[instance].size();
  }
  String get_region_name(int instance, int region_index) {
    return regions_array[instance].get(region_index).name;
  }

  int get_region_priority(int instance, int region_index) {
    return regions_array[instance].get(region_index).priority;
  }

  int get_region_relay_index(int instance, int region_index) {
    return regions_array[instance].get(region_index).relay_index;
  }

  boolean get_region_no_mark_big(int instance, int region_index) {
    return regions_array[instance].get(region_index).no_mark_big;
  }

  color get_marker_stroke_color(int instance, int region_index) {
    return regions_array[instance].get(region_index).marker_stroke_color;
  }

  int get_marker_stroke_weight(int instance, int region_index) {
    return regions_array[instance].get(region_index).marker_stroke_weight;
  }

  color get_marker_fill_color(int instance, int region_index) {
    return regions_array[instance].get(region_index).marker_fill_color;
  }

  void reset_regions_has_object(int instance) {
    for (Region_Data region_data:regions_array[instance]) {
      region_data.has_object = false;
    }
  }

  void set_region_has_object(int instance, int region_index) {
    regions_array[instance].get(region_index).has_object = true;
  }

  boolean get_region_has_object(int instance, int region_index) {
    return regions_array[instance].get(region_index).has_object;
  }

}

class Region_Data {
  String name;
  int priority;
  int relay_index;
  boolean no_mark_big;
  Points_Data points_data;
  int rect_mi_x;
  int rect_mi_y;
  int rect_mi_width;
  int rect_mi_height;
  color marker_stroke_color;
  int marker_stroke_weight;
  color marker_fill_color;
  int rect_dashed_gap;
  boolean has_object;

  Region_Data(String name, int priority) {
    points_data = new Points_Data(5);
    if(points_data == null) {
      return;
    }
    this.name = name;
    this.priority = priority;
  }

  void set_rect_data(int x, int y, int width, int height, color first_color, color other_color, int weight, int dashed_gap) {
    this.rect_mi_x = x;
    this.rect_mi_y = y;
    this.rect_mi_width = width;
    this.rect_mi_height = height;
    this.rect_dashed_gap = dashed_gap;
    points_data.set_point_mi(0, x, y, first_color, weight);
    points_data.set_point_mi(1, x + width, y, other_color, weight);
    points_data.set_point_mi(2, x + width, y + height, other_color, weight);
    points_data.set_point_mi(3, x, y + height, other_color, weight);
    points_data.set_point_mi(4, x, y, other_color, weight);
  }

  void set_marker_data(color stroke_color, int stroke_weight, color fill_color) {
    this.marker_stroke_color = stroke_color;
    this.marker_stroke_weight = stroke_weight;
    this.marker_fill_color = fill_color;
  }

}
