import java.awt.event.KeyEvent;

//final static boolean PRINT_MOUSEFUNC_DBG_ALL = true;
final static boolean PRINT_MOUSEFUNC_DBG_ALL = false;

//final static boolean PRINT_MOUSEFUNC_DBG_POS = true;
final static boolean PRINT_MOUSEFUNC_DBG_POS = false;

//final static boolean PRINT_MOUSEFUNC_Pressed = true; 
final static boolean PRINT_MOUSEFUNC_Pressed = false;

//final static boolean PRINT_MOUSEFUNC_Released = true; 
final static boolean PRINT_MOUSEFUNC_Released = false;

//final static boolean PRINT_MOUSEFUNC_Moved = true; 
final static boolean PRINT_MOUSEFUNC_Moved = false;

//final static boolean PRINT_MOUSEFUNC_Dragged = true; 
final static boolean PRINT_MOUSEFUNC_Dragged = false;

//final static boolean PRINT_MOUSEFUNC_Wheel = true; 
final static boolean PRINT_MOUSEFUNC_Wheel = false;

int mousePressedX;
int mousePressedY;

/**/
void keyPressed()
{
  //println("keyPressed " + int(key) + " " + keyCode);
  if(key == CODED)
  {
    if(keyCode == KeyEvent.VK_F10)
    {
      UDP_get_src_ip_port_enable = !UDP_get_src_ip_port_enable;
      SN_get_src_ip_port_enable = !SN_get_src_ip_port_enable;
    }
    else if(keyCode == KeyEvent.VK_F9)
    {
      UART_get_take_time_enable = !UART_get_take_time_enable;
      UDP_get_take_time_enable = !UDP_get_take_time_enable;
      SN_get_take_time_enable = !SN_get_take_time_enable;
    } 
    else if(keyCode == KeyEvent.VK_F8)
    {
      PS_DATA_draw_params_enable = !PS_DATA_draw_params_enable;
    } 
  }
}
/**/
/*
void keyTyped()
{
  println("keyTyped " + int(key) + " " + keyCode);
}
*/
/*
void keyReleased()
{
  println("released " + int(key) + " " + keyCode);
}
*/

void mousePressed()
{
  if (PRINT_MOUSEFUNC_Pressed || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse pressed! ");

  if (PRINT_MOUSEFUNC_Pressed || PRINT_MOUSEFUNC_DBG_ALL || PRINT_MOUSEFUNC_DBG_POS) println("mouseX=" + mouseX + ", mouseY=" + mouseY);
  //if (PRINT_MOUSEFUNC_Pressed) println("SCREEN_width - mouseX=" + (SCREEN_width - mouseX) + ", mouseY=" + mouseY);

  mousePressedX = mouseX - GRID_OFFSET_X;
  mousePressedY = mouseY - GRID_OFFSET_Y;

  buttons_zoom_minus_pressed = false;
  buttons_zoom_pluse_pressed = false;
  buttons_rotate_ccw_pressed = false;
  buttons_rotate_cw_pressed = false;
  buttons_mirror_ud_pressed = false;
  buttons_mirror_lr_pressed = false;
  buttons_reset_en_pressed = false;

  if (buttons_zoom_minus_over)
  {
    buttons_zoom_minus_pressed = true;
  }
  if (buttons_zoom_pluse_over)
  {
    buttons_zoom_pluse_pressed = true;
  }
  if (buttons_rotate_ccw_over)
  {
    buttons_rotate_ccw_pressed = true;
  }
  if (buttons_rotate_cw_over)
  {
    buttons_rotate_cw_pressed = true;
  }
  if (buttons_mirror_ud_over)
  {
    buttons_mirror_ud_pressed = true;
  }
  if (buttons_mirror_lr_over)
  {
    buttons_mirror_lr_pressed = true;
  }
  if (buttons_reset_en_over)
  {
    buttons_reset_en_pressed = true;
  }
}

void mouseReleased()
{
  if (PRINT_MOUSEFUNC_Released || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse released! ");

  UI_Interfaces_mouseReleased();

  if (buttons_zoom_minus_over && buttons_zoom_minus_pressed)
  {
    UI_Buttons_zoom_minus();
  }
  if (buttons_zoom_pluse_over && buttons_zoom_pluse_pressed)
  {
    UI_Buttons_zoom_pluse();
  }

  //println("old GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
  if (buttons_rotate_ccw_over && buttons_rotate_ccw_pressed)
  {
    UI_Buttons_rotate_ccw();
  }
  if (buttons_rotate_cw_over && buttons_rotate_cw_pressed)
  {
    UI_Buttons_rotate_cw();
  }
  //println("new GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);

  if (buttons_mirror_ud_over && buttons_mirror_ud_pressed)
  {
    UI_Buttons_mirror_ud();
  }

  if (buttons_mirror_lr_over && buttons_mirror_lr_pressed)
  {
    UI_Buttons_mirror_lr();
  }

  if (buttons_reset_en_over && buttons_reset_en_pressed)
  {
    UI_Buttons_reset_en();
  }

}

void mouseMoved()
{
  if (PRINT_MOUSEFUNC_Moved || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse moved!");
  if (PRINT_MOUSEFUNC_Moved || PRINT_MOUSEFUNC_DBG_ALL || PRINT_MOUSEFUNC_DBG_POS) println("\t mouseX=" + mouseX + ", mouseY=" + mouseY + ", mousePressed=" + mousePressed);

  UI_Buttons_check_update();
}

void mouseDragged() 
{
  if (PRINT_MOUSEFUNC_Dragged || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse dragged!");
  if (PRINT_MOUSEFUNC_Dragged || PRINT_MOUSEFUNC_DBG_ALL || PRINT_MOUSEFUNC_DBG_POS) println("\t mouseX=" + mouseX + ", mouseY=" + mouseY + ", mousePressed=" + mousePressed);
  if (PRINT_MOUSEFUNC_Dragged) println("\t mousePressedX=" + mousePressedX + ", mousePressedY=" + mousePressedY);

  UI_Buttons_check_update();

  GRID_OFFSET_X = mouseX - mousePressedX;
  GRID_OFFSET_Y = mouseY - mousePressedY;

  config_save();

  if (PRINT_MOUSEFUNC_Dragged) println("\t GRID_OFFSET_X:" + GRID_OFFSET_X + ", GRID_OFFSET_Y:" + GRID_OFFSET_Y);
}

void mouseWheel(MouseEvent event)
{
  int wheel_count = event.getCount();
  //float zoom_factor_save = ZOOM_FACTOR;
  int zoom_factor_save = ZOOM_FACTOR;

  if (PRINT_MOUSEFUNC_Wheel || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse wheeled!\n\t count=" + wheel_count);

  if (wheel_count > 0)
  {
    for (; wheel_count > 0; wheel_count -= 1)
    {  
      UI_Buttons_zoom_minus();
    }
  }
  else if (wheel_count < 0)
  {
    for (; wheel_count < 0; wheel_count += 1)
    {  
      UI_Buttons_zoom_pluse();
    }
  }

  // Check zoom factor changed.
  if (zoom_factor_save != ZOOM_FACTOR)
  {
    final int const_x_base = (ROTATE_FACTOR == 135)?(SCREEN_width + GRID_OFFSET_X - mouseX):(mouseX - GRID_OFFSET_X);
    final int const_y_base = (ROTATE_FACTOR == 225)?(SCREEN_height + GRID_OFFSET_Y - mouseY):(mouseY - GRID_OFFSET_Y);
    final int const_x_offset = (ROTATE_FACTOR == 315 || ROTATE_FACTOR == 135)?(TEXT_MARGIN + FONT_HEIGHT / 2):(SCREEN_width / 2);
    final int const_y_offset = (ROTATE_FACTOR == 45 || ROTATE_FACTOR == 225)?(TEXT_MARGIN + FONT_HEIGHT / 2):(SCREEN_height / 2);
    final float const_x_ratio = (ROTATE_FACTOR == 135)?(float(zoom_factor_save) / float(ZOOM_FACTOR) - 1.0):(1.0 - float(zoom_factor_save) / float(ZOOM_FACTOR));
    final float const_y_ratio = (ROTATE_FACTOR == 225)?(float(zoom_factor_save) / float(ZOOM_FACTOR) - 1.0):(1.0 - float(zoom_factor_save) / float(ZOOM_FACTOR));

    //println("old ZOOM_FACTOR=" + zoom_factor_save + ", new ZOOM_FACTOR=" + ZOOM_FACTOR);
    //println("SCREEN_width - mouseX=" + (SCREEN_width - mouseX) + ", mouseY=" + mouseY);
    //println("GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    //println("(SCREEN_height - mouseY - GRID_OFFSET_Y) * const_ratio=" + ((SCREEN_height - mouseY - GRID_OFFSET_Y) * const_ratio));
    //println("(SCREEN_height - mouseY - GRID_OFFSET_Y)=" + ((SCREEN_height - mouseY - GRID_OFFSET_Y)));

    GRID_OFFSET_X += int((const_x_base - const_x_offset) * const_x_ratio);
    GRID_OFFSET_Y += int((const_y_base - const_y_offset) * const_y_ratio);

    config_save();
  }
}
