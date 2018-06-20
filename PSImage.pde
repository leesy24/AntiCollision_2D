//final static boolean PRINT_PS_IMAGE_ALL_DBG = true; 
final static boolean PRINT_PS_IMAGE_ALL_DBG = false; 
final static boolean PRINT_PS_IMAGE_ALL_ERR = true; 
//final static boolean PRINT_PS_IMAGE_ALL_ERR = false; 

//final static boolean PRINT_PS_IMAGE_SETUP_DBG = true; 
final static boolean PRINT_PS_IMAGE_SETUP_DBG = false; 
//final static boolean PRINT_PS_IMAGE_SETUP_ERR = true; 
final static boolean PRINT_PS_IMAGE_SETUP_ERR = false; 

PImage[] PS_Image;
boolean[] PS_Image_mouse_over;
boolean[] PS_Image_mouse_pressed;

void PS_Image_settings()
{
  PS_Image = new PImage[PS_INSTANCE_MAX];
  if (PS_Image == null)
  {
    if (PRINT_PS_IMAGE_ALL_ERR || PRINT_PS_IMAGE_SETUP_ERR) println("PS_Image_settings():PS_Image=null");
    return;
  }
  PS_Image_mouse_over = new boolean[PS_INSTANCE_MAX];
  if (PS_Image == null)
  {
    if (PRINT_PS_IMAGE_ALL_ERR || PRINT_PS_IMAGE_SETUP_ERR) println("PS_Image_settings():PS_Image_mouse_over=null");
    return;
  }
  PS_Image_mouse_pressed = new boolean[PS_INSTANCE_MAX];
  if (PS_Image == null)
  {
    if (PRINT_PS_IMAGE_ALL_ERR || PRINT_PS_IMAGE_SETUP_ERR) println("PS_Image_settings():PS_Image_mouse_pressed=null");
    return;
  }

  PS_Image_update();
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    PS_Image_mouse_over[i] = false;
    PS_Image_mouse_pressed[i] = false;
  }
}

void PS_Image_draw()
{
  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    //println("Grid_zero_x["+i+"]="+Grid_zero_x[i]+",Grid_zero_y["+i+"]="+Grid_zero_y[i]);
    if( (
          Grid_zero_x[i] >= 0 - PS_Image[i].width / 2
          &&
          Grid_zero_x[i] < SCREEN_width + PS_Image[i].width / 2
        )
        &&
        (
          Grid_zero_y[i] >= 0 - PS_Image[i].height / 2
          &&
          Grid_zero_y[i] < SCREEN_height + PS_Image[i].height / 2
        )
      )
    {
      //println("image xy=" + Grid_zero_x[i] + "," + Grid_zero_y[i]);
      image(  PS_Image[i],
              Grid_zero_x[i] - PS_Image[i].width / 2,
              Grid_zero_y[i] - PS_Image[i].height / 2);
    }
  }
}

void PS_Image_update()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (ROTATE_FACTOR[i] == 315) {
      // Images must be in the "data" directory to load correctly
      if (MIRROR_ENABLE[i]) {
        PS_Image[i] = loadImage("PS_315_.png");
      }
      else {
        PS_Image[i] = loadImage("PS_315.png");
      }
    } else if (ROTATE_FACTOR[i] == 45) {
      // Images must be in the "data" directory to load correctly
      if (MIRROR_ENABLE[i]) {
        PS_Image[i] = loadImage("PS_45_.png");
      }
      else {
        PS_Image[i] = loadImage("PS_45.png");
      }
    } else if (ROTATE_FACTOR[i] == 135) {
      // Images must be in the "data" directory to load correctly
      if (MIRROR_ENABLE[i]) {
        PS_Image[i] = loadImage("PS_135_.png");
      }
      else {
        PS_Image[i] = loadImage("PS_135.png");
      }
    } else /*if (ROTATE_FACTOR[i] == 225)*/ {
      // Images must be in the "data" directory to load correctly
      if (MIRROR_ENABLE[i]) {
        PS_Image[i] = loadImage("PS_225_.png");
      }
      else {
        PS_Image[i] = loadImage("PS_225.png");
      }
    }
  }
}

void PS_Image_mouse_pressed()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    PS_Image_mouse_pressed[i] = false;
    if (PS_Image_mouse_over[i])
    {
      PS_Image_mouse_pressed[i] = true;
      PS_Data_draw_params_x = mouseX;
      PS_Data_draw_params_y = mouseY;
      PS_Data_draw_params_enabled[i] = !PS_Data_draw_params_enabled[i];
      if (PS_Data_draw_params_enabled[i]) PS_Data_draw_params_timer = millis();
    }
    else
    {
      PS_Data_draw_params_enabled[i] = false;
    }
  }
}

void PS_Image_mouse_released()
{
}

void PS_Image_mouse_moved()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if( mouse_is_over(
          Grid_zero_x[i] - PS_Image[i].width / 2,
          Grid_zero_y[i] - PS_Image[i].height / 2,
          PS_Image[i].width,
          PS_Image[i].height) )
    {
      PS_Image_mouse_over[i] = true;
      if (PS_Data_draw_params_enabled[i]) PS_Data_draw_params_timer = millis();
    }
    else
    {
      PS_Image_mouse_over[i] = false;
    }
  }
}

void PS_Image_mouse_dragged()
{
  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if( mouse_is_over(
          Grid_zero_x[i] - PS_Image[i].width / 2,
          Grid_zero_y[i] - PS_Image[i].height / 2,
          PS_Image[i].width,
          PS_Image[i].height) )
    {
      PS_Image_mouse_over[i] = true;
      if (PS_Data_draw_params_enabled[i]) PS_Data_draw_params_timer = millis();
    }
    else
    {
      PS_Image_mouse_over[i] = false;
    }
  }
}

