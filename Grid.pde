//static color C_GRID_LINE = #808080; // Black + 0x80
static color C_GRID_LINE = #C0C0C0; // Black + 0xC0
static color C_GRID_TEXT = #404040; // Black + 0x40
//static color C_GRID_TEXT = #808080; //Black + 0x80

int GRID_OFFSET_X = 0;
int GRID_OFFSET_Y = 0;
PImage PS_image;
/*
int PS_image_x_start;
int PS_image_x_end;
int PS_image_y_start;
int PS_image_y_end;
*/

void grid_settings()
{
  grid_ready();
}

void grid_draw()
{
  if (ROTATE_FACTOR == 315) {
    grid_draw_rotate_0();
  } else if (ROTATE_FACTOR == 45) {
    grid_draw_rotate_90();
  } else if (ROTATE_FACTOR == 135) {
    grid_draw_rotate_180();
  } else /*if (ROTATE_FACTOR == 225)*/ {
    grid_draw_rotate_270();
  }
}

void grid_ready()
{
  if (ROTATE_FACTOR == 315) {
    // Images must be in the "data" directory to load correctly
    if (MIRROR_ENABLE) {
      PS_image = loadImage("PS_315_.png");
    }
    else {
      PS_image = loadImage("PS_315.png");
    }
  } else if (ROTATE_FACTOR == 45) {
    // Images must be in the "data" directory to load correctly
    if (MIRROR_ENABLE) {
      PS_image = loadImage("PS_45_.png");
    }
    else {
      PS_image = loadImage("PS_45.png");
    }
  } else if (ROTATE_FACTOR == 135) {
    // Images must be in the "data" directory to load correctly
    if (MIRROR_ENABLE) {
      PS_image = loadImage("PS_135_.png");
    }
    else {
      PS_image = loadImage("PS_135.png");
    }
  } else /*if (ROTATE_FACTOR == 225)*/ {
    // Images must be in the "data" directory to load correctly
    if (MIRROR_ENABLE) {
      PS_image = loadImage("PS_225_.png");
    }
    else {
      PS_image = loadImage("PS_225.png");
    }
  }

/*
  if(PS_image == null) return;

final int const_screen_width_d_100 = SCREEN_width / 100;
final int const_screen_width_d_100_d_2 = const_screen_width_d_100 / 2;
final int const_screen_height_d_100 = SCREEN_height / 100;
final int const_screen_height_d_100_d_2 = const_screen_height_d_100 / 2;
*/
/*
  PS_image_x_start = 0 - PS_image.width / 2;
  PS_image_x_end = SCREEN_width + PS_image.width / 2;
  PS_image_y_start = 0 - PS_image.height / 2;
  PS_image_y_end = SCREEN_height + PS_image.height / 2;
*/
}
