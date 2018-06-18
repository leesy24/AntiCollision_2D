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

  mousePressedX = mouseX - DRAW_OFFSET_X[0];
  mousePressedY = mouseY - DRAW_OFFSET_Y[0];

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

  //println("old DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
  if (buttons_rotate_ccw_over && buttons_rotate_ccw_pressed)
  {
    UI_Buttons_rotate_ccw();
  }
  if (buttons_rotate_cw_over && buttons_rotate_cw_pressed)
  {
    UI_Buttons_rotate_cw();
  }
  //println("new DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);

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

  DRAW_OFFSET_X[0] = mouseX - mousePressedX;
  DRAW_OFFSET_Y[0] = mouseY - mousePressedY;

  config_save();

  if (PRINT_MOUSEFUNC_Dragged) println("\t DRAW_OFFSET_X[0]:" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]:" + DRAW_OFFSET_Y[0]);
}

void mouseWheel(MouseEvent event)
{
  int wheel_count = event.getCount();
  int zoom_factor_save = ZOOM_FACTOR[0];

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
  if (zoom_factor_save != ZOOM_FACTOR[0])
  {
    final int const_x_base = (ROTATE_FACTOR[0] == 135)?(SCREEN_width + DRAW_OFFSET_X[0] - mouseX):(mouseX - DRAW_OFFSET_X[0]);
    final int const_y_base = (ROTATE_FACTOR[0] == 225)?(SCREEN_height + DRAW_OFFSET_Y[0] - mouseY):(mouseY - DRAW_OFFSET_Y[0]);
    final int const_x_offset = (ROTATE_FACTOR[0] == 315 || ROTATE_FACTOR[0] == 135)?(TEXT_MARGIN + FONT_HEIGHT / 2):(SCREEN_width / 2);
    final int const_y_offset = (ROTATE_FACTOR[0] == 45 || ROTATE_FACTOR[0] == 225)?(TEXT_MARGIN + FONT_HEIGHT / 2):(SCREEN_height / 2);
    final float const_x_ratio = (ROTATE_FACTOR[0] == 135)?(float(zoom_factor_save) / float(ZOOM_FACTOR[0]) - 1.0):(1.0 - float(zoom_factor_save) / float(ZOOM_FACTOR[0]));
    final float const_y_ratio = (ROTATE_FACTOR[0] == 225)?(float(zoom_factor_save) / float(ZOOM_FACTOR[0]) - 1.0):(1.0 - float(zoom_factor_save) / float(ZOOM_FACTOR[0]));

    //println("old ZOOM_FACTOR[0]=" + zoom_factor_save + ", new ZOOM_FACTOR[0]=" + ZOOM_FACTOR[0]);
    //println("SCREEN_width - mouseX=" + (SCREEN_width - mouseX) + ", mouseY=" + mouseY);
    //println("DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
    //println("(SCREEN_height - mouseY - DRAW_OFFSET_Y[0]) * const_ratio=" + ((SCREEN_height - mouseY - DRAW_OFFSET_Y[0]) * const_ratio));
    //println("(SCREEN_height - mouseY - DRAW_OFFSET_Y[0])=" + ((SCREEN_height - mouseY - DRAW_OFFSET_Y[0])));

    DRAW_OFFSET_X[0] += int((const_x_base - const_x_offset) * const_x_ratio);
    DRAW_OFFSET_Y[0] += int((const_y_base - const_y_offset) * const_y_ratio);

    config_save();
  }
}
