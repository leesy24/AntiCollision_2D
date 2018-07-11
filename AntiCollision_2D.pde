import java.util.*;

// Define to enable or disable the log print in console.
//final static boolean PRINT_DBG = true; 
final static boolean PRINT_DBG = false; 

//static color C_BG = #FFFFFF; // White
static color C_BG = #F8F8F8; // White - 0x8

static String SYSTEM_PASSWORD = "0000"; // 4-digits, Default SYSTEM_PASSWORD

static int SYSTEM_UI_TIMEOUT = 60; // in seconds.

final static int PS_INSTANCE_MAX = 2;

// Define window title string.
final static String TITLE_COMPANY = "DASAN InfoTek";
final static String TITLE_PRODUCT = "2D Anti-Collision System";
String Title;

static int FRAME_RATE = 20; // Frame rate per second of screen update in Hz. 20Hz = 50msec
static int FRAME_TIME; // Frame time will calculated from frame rate.

// The settings() function is new with Processing 3.0. It's not needed in most sketches.
// It's only useful when it's absolutely necessary to define the parameters to size() with a variable. 
void settings() {
  Screen_settings();
}

// The setup() function is run once, when the program starts.
// It's used to define initial enviroment properties such as screen size
//  and to load media such as images and fonts as the program starts.
// There can only be one setup() function for each program
//  and it shouldn't be called again after its initial execution.
void setup() {
  if (PRINT_DBG) println("setup():Enter");

  // Must very first initialize font.
  SCREEN_PFront = createFont("SansSerif", 32);
  textFont(SCREEN_PFront);

  //noStroke();
/*
  // This is only pertains to the desktop version of Processing (not JavaScript or Android),
  //  because it's the only one to use windows and frames.
  // It's possible to make the window resizable.
  surface.setResizable(true);
  surface.setLocation(SCREEN_x, SCREEN_y);
*/

  //Config_settings();
/*
  // fullScreen() opens a sketch using the full size of the computer's display.
  // This function must be the first line in setup().
  // The size() and fullScreen() functions cannot both be used in the same program,
  //  just choose one.
  fullScreen();

  // Assign full screen width and height
  SCREEN_WIDTH = width;
  SCREEN_HEIGHT = height;
*/

  // To set the background on the first frame of animation. 
  background(C_BG);
  // Specifies the number of frames to be displayed every second.
  // The default rate is 60 frames per second.
  //frameRate(1);
  //frameRate(30);

  // Title set to default.
  Title = TITLE_COMPANY + ":" + TITLE_PRODUCT;

  Const_setup();
  Config_setup();
  Screen_setup();
  Update_Data_Files_setup();
  BG_Image_setup();
  Grid_setup();
  PS_Data_setup();
  PS_Image_setup();
  ROI_Data_setup();
  Regions_setup();
  Relay_Module_setup();
  UI_Buttons_setup();
  UI_Interfaces_setup();
  UI_System_Config_setup();
  UI_Regions_Config_setup();
  Disk_Space_setup();
  Version_Date_setup();

  frameRate(FRAME_RATE);
  FRAME_TIME = int(1000. / FRAME_RATE);

  // Set window title
  surface.setTitle(Title);

  // Need to call gc() to free memory.
  System.gc();
}

// Called directly after setup()
//  , the draw() function continuously executes the lines of code contained inside
//  its block until the program is stopped or noLoop() is called. draw() is called automatically
//  and should never be called explicitly.
// All Processing programs update the screen at the end of draw(), never earlier.
void draw() {
  Dbg_Time_logs_handle.start("Main:draw():", 500, true);
  //Dbg_Time_logs_handle.start("Main:draw():", FRAME_TIME);

  // Ready to draw from here!
  // To clear the display window at the beginning of each frame,
  background(C_BG);

  if (UI_Interfaces_changed_any) {
      // To restart program set frameCount to -1, this wiil call setup() of main.
      frameCount = -1;
  }
  if (Screen_check_update()) {
    //PS_Data_setup();
    Screen_setup();
    Regions_setup();
    Grid_setup();
    UI_Buttons_setup();
    UI_Interfaces_update();
    UI_Regions_Config_update();
  }
  Dbg_Time_logs_handle.add("Screen_check_update()");

  Grid_draw_lines();
  Dbg_Time_logs_handle.add("Grid_draw_lines()");
  BG_Image_draw();
  Dbg_Time_logs_handle.add("BG_Image_draw()");
  Regions_draw();
  Dbg_Time_logs_handle.add("Regions_draw()");
  Grid_draw_texts();
  Dbg_Time_logs_handle.add("Grid_draw_texts()");
  PS_Image_draw();
  Dbg_Time_logs_handle.add("PS_Image_draw()");

  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (PS_Data_handle.load(i) == true) {
      Dbg_Time_logs_handle.add("PS_Data_handle.load("+i+"):true");
      PS_Data_handle.save_always(i);
      Dbg_Time_logs_handle.add("PS_Data_handle.save_always("+i+")");
      if (PS_Data_handle.parse(i) == false) {
        Dbg_Time_logs_handle.add("PS_Data_handle.parse("+i+"):false");
        if (PS_Data_handle.parse_err_cnt[i] > 10) {
          ROI_Data_setup();
          PS_Data_setup();
        }
      }
      else {
        Dbg_Time_logs_handle.add("PS_Data_handle.parse("+i+"):true");
      }
    }
    else {
      Dbg_Time_logs_handle.add("PS_Data_handle.load("+i+"):false");
    }
    PS_Data_handle.draw_points(i);
    Dbg_Time_logs_handle.add("PS_Data_handle.draw_points("+i+")");
    ROI_Data_handle.draw_objects(i);
    Dbg_Time_logs_handle.add("ROI_Data_handle.draw_objects("+i+")");
    ROI_Data_handle.save_events(i);
    Dbg_Time_logs_handle.add("ROI_Data_handle.save_events("+i+")");
    PS_Data_handle.draw_params(i);
    Dbg_Time_logs_handle.add("PS_Data_handle.draw_params("+i+")");
    ROI_Data_handle.draw_object_info(i);
    Dbg_Time_logs_handle.add("ROI_Data_handle.draw_object_info("+i+")");
  }

  Relay_Module_output();
  Dbg_Time_logs_handle.add("Relay_Module_output()");

  UI_Buttons_draw();
  Dbg_Time_logs_handle.add("UI_Buttons_draw()");
  Bubble_Info_draw();
  Dbg_Time_logs_handle.add("Bubble_Info_draw()");
  UI_Interfaces_draw();
  Dbg_Time_logs_handle.add("UI_Interfaces_draw()");
  UI_System_Config_draw();
  Dbg_Time_logs_handle.add("UI_System_Config_draw()");
  UI_Regions_Config_draw();
  Dbg_Time_logs_handle.add("UI_Regions_Config_draw()");
  Notice_Messages_draw();
  Dbg_Time_logs_handle.add("Notice_Messages_draw()");

  Update_Data_Files_check();
  Dbg_Time_logs_handle.add("Update_Data_Files_check()");

// Disk Space free will run as threads on Disk Space feature.
/*
  Disk_Space_free();

  Dbg_Time_logs_handle.add("Disk_Space_free()");
*/

  Version_Date_draw();

  Dbg_Time_logs_handle.add("Version_Date_draw()");
} 

void Notice_Messages_draw()
{
  LinkedList<String> strings = new LinkedList<String>();

  /*
  if (PS_Data_save_enabled)
  {
    strings.add("Saving PS data ...");
  }
  */
  if (Bubble_Info_enabled)
  {
    strings.add("Bubble Info enabled.");
  }

  float gray = (millis()/10)%255;
  // Sets the color used to draw lines and borders around shapes.
  fill(gray);
  stroke(gray);
  textSize(FONT_HEIGHT);
  textAlign(LEFT, BASELINE);
  int i = 0;
  for (String str:strings)
  {
    text(str, SCREEN_width / 2 - textWidth(str) / 2, TEXT_MARGIN + FONT_HEIGHT + i * FONT_HEIGHT);
    i ++;
  }
}
