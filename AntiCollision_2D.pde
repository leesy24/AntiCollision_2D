// Define to enable or disable the log print in console.
//final boolean PRINT = true; 
final boolean PRINT = false; 

//static color C_BG = #FFFFFF; // White
static color C_BG = #F8F8F8; // White - 0x8

final static int PS_INSTANCE_MAX = 2;

// Define window title string.
final String TITLE = "DASAN-InfoTEK - 2D Anti-Collision System";
String Title;

int FRAME_RATE = 20; // Frame rate per second of screen update in Hz. 20Hz = 50msec

// The settings() function is new with Processing 3.0. It's not needed in most sketches.
// It's only useful when it's absolutely necessary to define the parameters to size() with a variable. 
void settings() {
  Screen_settings();
  PS_Data_settings();
  Const_settings();
  Config_settings();
  BG_Image_settings();
  Grid_settings();
  PS_Image_settings();
  ROI_Data_settings();
  Fault_Region_settings();
  Alert_Region_settings();
}

// The setup() function is run once, when the program starts.
// It's used to define initial enviroment properties such as screen size
//  and to load media such as images and fonts as the program starts.
// There can only be one setup() function for each program
//  and it shouldn't be called again after its initial execution.
void setup() {
  frameRate(FRAME_RATE);
  //noStroke();
  // This is only pertains to the desktop version of Processing (not JavaScript or Android),
  //  because it's the only one to use windows and frames.
  // It's possible to make the window resizable.
  surface.setResizable(true);
  surface.setLocation(SCREEN_x, SCREEN_y);

  SCREEN_PFront = createFont("SansSerif", 32);
  textFont(SCREEN_PFront);
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
  Title = TITLE;
  Config_setup();
  ROI_Data_setup();
  PS_Data_setup();
  Screen_setup();
  Fault_Region_setup();
  Alert_Region_setup();
  Grid_setup();
  UI_Buttons_setup();
  UI_Interfaces_setup();

  // Set window title
  surface.setTitle(Title);
}

// Called directly after setup()
//  , the draw() function continuously executes the lines of code contained inside
//  its block until the program is stopped or noLoop() is called. draw() is called automatically
//  and should never be called explicitly.
// All Processing programs update the screen at the end of draw(), never earlier.
void draw() {
  // Ready to draw from here!
  // To clear the display window at the beginning of each frame,
  background(C_BG);

  if (UI_Interfaces_changed) {
    // Title set to default.
    Title = TITLE;
    Config_setup();
    ROI_Data_setup();
    PS_Data_setup();
    Screen_setup();
    Fault_Region_setup();
    Alert_Region_setup();
    Grid_setup();
    UI_Buttons_setup();
    UI_Interfaces_setup();
    // Set window title
    surface.setTitle(Title);
  }
  if (Screen_check_update()) {
    //PS_Data_setup();
    Screen_setup();
    Fault_Region_setup();
    Alert_Region_setup();
    Grid_setup();
    UI_Buttons_setup();
    UI_Interfaces_setup();
  }

  // Move to mouseMoved() and mouseDragged().
  //UI_Buttons_check_over();

  Grid_draw();
  BG_Image_draw();
  PS_Image_draw();
  Fault_Region_draw();
  Alert_Region_draw();

  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (PS_Data_handle.load(i) == true) {
      if (PS_Data_handle.parse(i) == false) {
        if (PS_Data_handle.parse_err_cnt[i] > 10) {
          ROI_Data_setup();
          PS_Data_setup();
        }
      }
    }
    PS_Data_handle.draw_points(i);
    ROI_Data_handle.draw_objects(i);
    PS_Data_handle.draw_params(i);
    ROI_Data_handle.draw_object_info(i);
  }

  UI_Buttons_draw();
  Bubble_Info_draw();
  UI_Interfaces_draw();
} 
