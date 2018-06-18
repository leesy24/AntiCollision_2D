//static color C_GRID_LINE = #808080; // Black + 0x80
static color C_GRID_LINE = #C0C0C0; // Black + 0xC0
static color C_GRID_TEXT = #404040; // Black + 0x40
//static color C_GRID_TEXT = #808080; //Black + 0x80

PImage[] PS_image;

void grid_settings()
{
  PS_image = new PImage[PS_INSTANCE_MAX];
  grid_ready();
}

void grid_draw()
{
  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (ROTATE_FACTOR[i] == 315) {
      grid_draw_rotate_315(i);
    } else if (ROTATE_FACTOR[i] == 45) {
      grid_draw_rotate_45(i);
    } else if (ROTATE_FACTOR[i] == 135) {
      grid_draw_rotate_135(i);
    } else /*if (ROTATE_FACTOR[i] == 225)*/ {
      grid_draw_rotate_225(i);
    }
  }
}

void grid_ready()
{
  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (ROTATE_FACTOR[i] == 315) {
      // Images must be in the "data" directory to load correctly
      if (MIRROR_ENABLE[i]) {
        PS_image[i] = loadImage("PS_315_.png");
      }
      else {
        PS_image[i] = loadImage("PS_315.png");
      }
    } else if (ROTATE_FACTOR[i] == 45) {
      // Images must be in the "data" directory to load correctly
      if (MIRROR_ENABLE[i]) {
        PS_image[i] = loadImage("PS_45_.png");
      }
      else {
        PS_image[i] = loadImage("PS_45.png");
      }
    } else if (ROTATE_FACTOR[i] == 135) {
      // Images must be in the "data" directory to load correctly
      if (MIRROR_ENABLE[i]) {
        PS_image[i] = loadImage("PS_135_.png");
      }
      else {
        PS_image[i] = loadImage("PS_135.png");
      }
    } else /*if (ROTATE_FACTOR[i] == 225)*/ {
      // Images must be in the "data" directory to load correctly
      if (MIRROR_ENABLE[i]) {
        PS_image[i] = loadImage("PS_225_.png");
      }
      else {
        PS_image[i] = loadImage("PS_225.png");
      }
    }
  }
}