// Define to enable or disable the log print in console.
//final boolean PRINT = true; 
final boolean PRINT = false; 

//static color C_BG = #FFFFFF; // White
static color C_BG = #F8F8F8; // White - 0x8

final static int PS_INSTANCE_MAX = 2;

// Define window title string.
final String TITLE = "DASAN-InfoTEK - 2D Anti-Collision System";
String Title;

// Define zoom factor variables.
int[] ZOOM_FACTOR;

// Define rotate factor variables.
float[] ROTATE_FACTOR;

// Define mirror variables.
boolean[] MIRROR_ENABLE;

// Define offset of misc. draw.
int[] DRAW_OFFSET_X;
int[] DRAW_OFFSET_Y;

int FRAME_RATE = 20; // Frame rate per second of screen update in Hz. 20Hz = 50msec

// The settings() function is new with Processing 3.0. It's not needed in most sketches.
// It's only useful when it's absolutely necessary to define the parameters to size() with a variable. 
void settings() {
  ZOOM_FACTOR = new int[PS_INSTANCE_MAX];
  ROTATE_FACTOR = new float[PS_INSTANCE_MAX];
  MIRROR_ENABLE = new boolean[PS_INSTANCE_MAX];
  DRAW_OFFSET_X = new int[PS_INSTANCE_MAX];
  DRAW_OFFSET_Y = new int[PS_INSTANCE_MAX];
  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    // Define zoom factor variables.
    ZOOM_FACTOR[i] = 100;
    // Define rotate factor variables.
    ROTATE_FACTOR[i] = 315;/*45;*//*135;*//*225;*/
    // Define mirror variables.
    MIRROR_ENABLE[i] = false;
    // Define offset of misc. draw.
    DRAW_OFFSET_X[i] = 0;
    DRAW_OFFSET_Y[i] = 0;
  }

  PS_Data_settings();
  const_settings();
  config_settings();
  screen_settings();
  BG_Image_settings();
  Grid_settings();
  PS_Image_settings();
  Fault_Region_settings();
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
  //config_settings();
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
  config_setup();
  PS_Data_setup();
  screen_setup();
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
    config_setup();
    PS_Data_setup();
    screen_setup();
    UI_Buttons_setup();
    UI_Interfaces_setup();
    // Set window title
    surface.setTitle(Title);
  }
  if (screen_check_update()) {
    //PS_Data_setup();
    screen_setup();
    UI_Buttons_setup();
    UI_Interfaces_setup();
  }

  // Move to mouseMoved() and mouseDragged().
  //UI_Buttons_check_over();

  Grid_draw();
  BG_Image_draw();
  PS_Image_draw();
  Fault_Region_draw();

  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (PS_Data_handle.load(i) == true) {
      if (PS_Data_handle.parse(i) == false) {
        if (PS_Data_handle.parse_err_cnt[i] > 10) {
          PS_Data_setup();
        }
      }
    }
    PS_Data_handle.draw_points(i);
    PS_Data_handle.draw_params(i);
  }

  UI_Buttons_draw();
  bubbleinfo_draw();
  UI_Interfaces_draw();
} 
