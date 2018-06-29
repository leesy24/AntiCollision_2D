//final static boolean PRINT_PS_IMAGE_ALL_DBG = true;
final static boolean PRINT_PS_IMAGE_ALL_DBG = false;
final static boolean PRINT_PS_IMAGE_ALL_ERR = true;
//final static boolean PRINT_PS_IMAGE_ALL_ERR = false;

//final static boolean PRINT_PS_IMAGE_SETUP_DBG = true;
final static boolean PRINT_PS_IMAGE_SETUP_DBG = false;
//final static boolean PRINT_PS_IMAGE_SETUP_ERR = true;
final static boolean PRINT_PS_IMAGE_SETUP_ERR = false;

static PImage[] PS_Image = new PImage[PS_INSTANCE_MAX];
static int[] PS_Image_y_offset = new int[PS_INSTANCE_MAX];
static boolean[] PS_Image_mouse_over = new boolean[PS_INSTANCE_MAX];
static boolean[] PS_Image_mouse_pressed = new boolean[PS_INSTANCE_MAX];

void PS_Image_setup()
{
  if (PRINT_PS_IMAGE_ALL_DBG || PRINT_PS_IMAGE_SETUP_DBG) println("PS_Image_setup():Enter");

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    PS_Image_y_offset[i] = 0;
    PS_Image_mouse_over[i] = false;
    PS_Image_mouse_pressed[i] = false;
  }

  PS_Image_update();
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
          Grid_zero_y[i] >= 0 + PS_Image_y_offset[i]
          &&
          Grid_zero_y[i] < SCREEN_height + PS_Image_y_offset[i]
        )
      )
    {
      //println("image xy=" + Grid_zero_x[i] + "," + Grid_zero_y[i]);
      image(  PS_Image[i],
              Grid_zero_x[i] - PS_Image[i].width / 2,
              Grid_zero_y[i] + PS_Image_y_offset[i]);
    }
  }
}

void PS_Image_update()
{
  String file_name;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    file_name = "PS_"+int(ROTATE_FACTOR[i]);
    if (MIRROR_ENABLE[i])
      file_name = file_name+"_";
    file_name = file_name+".png";
    // Images must be in the "data" directory to load correctly
    PS_Image[i] = loadImage(file_name);
    if (PS_Image[i] == null) continue;
    // Check PS image located on top.
    if ((ROTATE_FACTOR[i] == 45 && MIRROR_ENABLE[i] == true)
        ||
        (ROTATE_FACTOR[i] == 45 && MIRROR_ENABLE[i] == false)
        ||
        (ROTATE_FACTOR[i] == 135 && MIRROR_ENABLE[i] == false)
        ||
        (ROTATE_FACTOR[i] == 315 && MIRROR_ENABLE[i] == true))
    {
      PS_Image_y_offset[i] = -PS_Image[i].height;
    }
    else
    {
      PS_Image_y_offset[i] = 0;
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
      PS_Data_draw_params_x[i] = mouseX;
      PS_Data_draw_params_y[i] = mouseY;
      PS_Data_draw_params_enabled[i] = true;
      if (PS_Data_draw_params_enabled[i])
      {
        PS_Data_draw_params_timer[i] = millis();
      }
    }
    else
    {
      int j;
      for (j = 0; j < PS_INSTANCE_MAX; j ++)
      {
        if (PS_Image_mouse_over[j]) break;
      }
      if (j == PS_INSTANCE_MAX)
      {
        PS_Data_draw_params_enabled[i] = false;
      }
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
          Grid_zero_y[i] + PS_Image_y_offset[i],
          PS_Image[i].width,
          PS_Image[i].height) )
    {
      PS_Image_mouse_over[i] = true;
      if (PS_Data_draw_params_enabled[i])
      {
        PS_Data_draw_params_timer[i] = millis();
      }
    }
    else
    {
      PS_Image_mouse_over[i] = false;
    }
  }
}

void PS_Image_mouse_dragged()
{
  PS_Image_mouse_moved();
}
