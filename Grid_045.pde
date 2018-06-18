void grid_draw_rotate_45(int instance)
{
  final int const_screen_x_start = TEXT_MARGIN;
  final int const_screen_x_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_y_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_y_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  //final float const_zoom_factor_d_100 = ZOOM_FACTOR[instance] / 100.0;
  final int const_grid_offset_x = ((SCREEN_width % 100) / 2) + (DRAW_OFFSET_X[instance] % 100) + (((SCREEN_width / 100) % 2 == 0)?0:50);
  final int const_grid_offset_y = const_screen_y_start - const_font_height_d_2 + (DRAW_OFFSET_Y[instance] % 100);
  final int const_str_offset_ix = SCREEN_width / 100 / 2 * 100 + DRAW_OFFSET_X[instance] / 100 * 100;
  final int const_str_offset_iy = DRAW_OFFSET_Y[instance] / 100 * 100;
  //final int const_str_base_ix_y = const_screen_y_start + DRAW_OFFSET_Y[instance];
  final int const_str_base_ix_y =
    (DRAW_OFFSET_Y[instance] < 0)
    ?
    const_screen_y_start
    :
    ((DRAW_OFFSET_Y[instance] > const_screen_y_end - const_screen_y_start)
      ?
      const_screen_y_end
      :
      (const_screen_y_start + DRAW_OFFSET_Y[instance])
    );
  final int const_str_base_iy_x = (SCREEN_width / 2) + DRAW_OFFSET_X[instance];
  int x, y;
  int ix, iy;
  int x_zero, y_zero;
  String string;
  float distance = 0.0;
  int image_x = MIN_INT, image_y = MIN_INT;

  if (MIRROR_ENABLE[instance])
    x_zero = SCREEN_width;
  else
    x_zero = 0;
  for (ix = -100; ix <= SCREEN_width + 100; ix += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(const_str_offset_ix - ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_ix - ix)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(ix - const_str_offset_ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (ix - const_str_offset_ix)) / 100.0 / 100.0;
    //println("ix="+ix+":d="+distance);
    if (distance == 0.0) {
      x_zero = ix + const_grid_offset_x;
      break;
    }
  }
  //println("ix="+ix+":d="+distance);
  if (ix > SCREEN_width + 100 && distance < 0.0)
    if (MIRROR_ENABLE[instance])
      x_zero = 0;
    else
      x_zero = SCREEN_width;
  //println("x_zero="+x_zero);

  y_zero = 0;
  for (iy = 0; iy <= SCREEN_height + 100; iy += 100) {
    //distance = const_zoom_factor_d_100 * float(iy - const_str_offset_iy) / 100.0;
    distance = (ZOOM_FACTOR[instance] * (iy - const_str_offset_iy)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      y_zero = iy + const_grid_offset_y;
      break;
    }
  }
  //println("iy="+iy+":d="+distance);
  if (iy > SCREEN_height + 100 && distance < 0.0)
    y_zero = SCREEN_height;
  //println("y_zero="+y_zero);

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  for (ix = -100; ix <= SCREEN_width + 100; ix += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(const_str_offset_ix - ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_ix - ix)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(ix - const_str_offset_ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (ix - const_str_offset_ix)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      line(ix + const_grid_offset_x, y_zero,
           ix + const_grid_offset_x, SCREEN_height);
      //println("ix="+ix+":offset_x="+const_grid_offset_x+",x="+(ix + const_grid_offset_x));
    }
  }
  for (iy = 0; iy <= SCREEN_height + 100; iy += 100) {
    //distance = const_zoom_factor_d_100 * float(iy - const_str_offset_iy) / 100.0;
    distance = (ZOOM_FACTOR[instance] * (iy - const_str_offset_iy)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      if (MIRROR_ENABLE[instance])
        line(0,      iy + const_grid_offset_y,
             x_zero, iy + const_grid_offset_y);
      else
        line(x_zero,       iy + const_grid_offset_y,
             SCREEN_width, iy + const_grid_offset_y);
      //println("iy="+iy+":offset_y="+const_grid_offset_y+",y="+(iy + const_grid_offset_y));
    }
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  y = const_str_base_ix_y;
  //if (y < const_screen_y_start) y = const_screen_y_start;
  //if (y > const_screen_y_end) y = const_screen_y_end;
  for (ix = -100; ix <= SCREEN_width + 100; ix += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(const_str_offset_ix - ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_ix - ix)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(ix - const_str_offset_ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (ix - const_str_offset_ix)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      string = distance + "m";
      x = ix + const_grid_offset_x;
      if(distance == 0.0)
        image_x = x;
      text(string, x - int(textWidth(string) / 2.0), y);
      //println("iy=" + iy + ":x=" + x + ",y=" + y + "," + string);
    }
  }

  for (iy = 0; iy <= SCREEN_height + 100; iy += 100) {
    //distance = const_zoom_factor_d_100 * float(iy - const_str_offset_iy) / 100.0;
    distance = (ZOOM_FACTOR[instance] * (iy - const_str_offset_iy)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      string = distance + "m";
      x = const_str_base_iy_x - int(textWidth(string)/2);
      if (x < const_screen_x_start)
        x = const_screen_x_start;
      if (x > const_screen_x_end - int(textWidth(string)))
        x = const_screen_x_end - int(textWidth(string));
      y = iy + const_grid_offset_y;
      if(distance == 0.0)
        image_y = y;
      text(string, x, y + const_font_height_d_2);
      //println("ix=" + ix + ":x=" + x + ",y=" + y + "," + string);
    }
  }

  if( (image_x >= 0 - PS_image[instance].width / 2 && image_x < SCREEN_width + PS_image[instance].width / 2)
      &&
      (image_y >= 0 - PS_image[instance].height / 2 && image_y < SCREEN_height + PS_image[instance].height / 2)
    )
  {
    //println("image xy=" + image_x + "," + image_y);
    image(PS_image[instance], image_x - PS_image[instance].width / 2, image_y - PS_image[instance].height / 2);
  }
}
