void Grid_draw_rotate_315(int instance)
{
  final int const_screen_height_d_2 = SCREEN_height / 2;
  final int const_screen_x_start = TEXT_MARGIN;
  final int const_screen_x_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_y_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_y_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  //final float const_zoom_factor_d_100 = ZOOM_FACTOR[instance] / 100.0;
  final int const_grid_offset_x = const_screen_x_start + const_font_height_d_2 + (DRAW_OFFSET_X[instance] % 100);
  final int const_grid_offset_y = ((SCREEN_height % 100) / 2) + (DRAW_OFFSET_Y[instance] % 100) + ((((SCREEN_height / 100) % 2) == 0)?0:50);
  final int const_str_offset_ix = DRAW_OFFSET_X[instance] / 100 * 100;
  final int const_str_offset_iy = SCREEN_height / 100 / 2 * 100 + DRAW_OFFSET_Y[instance] / 100 * 100;
  //final int const_str_base_ix_y = (SCREEN_height / 2) + const_font_height_d_2 + DRAW_OFFSET_Y[instance];
  final int const_str_base_ix_y =
    (DRAW_OFFSET_Y[instance] < TEXT_MARGIN + const_font_height_d_2 - const_screen_height_d_2)
    ?
    const_screen_y_start
    :
    ((DRAW_OFFSET_Y[instance] > const_screen_height_d_2 - TEXT_MARGIN - const_font_height_d_2)
      ?
      const_screen_y_end
      :
      (const_screen_height_d_2 + const_font_height_d_2 + DRAW_OFFSET_Y[instance])
    );
  final int const_str_base_iy_x = const_screen_x_start + const_font_height_d_2 + DRAW_OFFSET_X[instance];
  int x, y;
  int ix, iy;
  int x_zero, y_zero;
  String string;
  float distance = 0.0;

  if (MIRROR_ENABLE[instance])
    y_zero = 0;
  else
    y_zero = SCREEN_height;
  for (iy = -100; iy <= SCREEN_height + 100; iy += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(iy - const_str_offset_iy) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (iy - const_str_offset_iy)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(const_str_offset_iy - iy) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_iy - iy)) / 100.0 / 100.0;
    //println("iy="+iy+":d="+distance);
    if (distance == 0.0) {
      y_zero = iy + const_grid_offset_y;
      break;
    }
  }
  //println("iy="+iy+":d="+distance);
  if (iy > SCREEN_height + 100 && distance < 0.0)
    if (MIRROR_ENABLE[instance])
      y_zero = SCREEN_height;
    else
      y_zero = 0;
  //println("y_zero="+y_zero);

  x_zero = 0;
  for (ix = 0; ix <= SCREEN_width + 100; ix += 100) {
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
    x_zero = SCREEN_width;
  //println("x_zero="+x_zero);

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  for (iy = -100; iy <= SCREEN_height + 100; iy += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(iy - const_str_offset_iy) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (iy - const_str_offset_iy)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(const_str_offset_iy - iy) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_iy - iy)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      line(x_zero,       iy + const_grid_offset_y,
           SCREEN_width, iy + const_grid_offset_y);
      //println("iy="+iy+":offset_y="+const_grid_offset_y+",y="+(iy + const_grid_offset_y));
    }
  }
  for (ix = 0; ix <= SCREEN_width + 100; ix += 100) {
    //distance = const_zoom_factor_d_100 * float(ix - const_str_offset_ix) / 100.0;
    distance = (ZOOM_FACTOR[instance] * (ix - const_str_offset_ix)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      if (MIRROR_ENABLE[instance])
        line(ix + const_grid_offset_x, y_zero,
             ix + const_grid_offset_x, SCREEN_height);
      else
        line(ix + const_grid_offset_x, 0,
             ix + const_grid_offset_x, y_zero);
      //println("ix="+ix+":offset_x="+const_grid_offset_x+",x="+(ix + const_grid_offset_x));
    }
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  for (iy = -100; iy <= SCREEN_height + 100; iy += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(iy - const_str_offset_iy) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (iy - const_str_offset_iy)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(const_str_offset_iy - iy) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_iy - iy)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      string = distance + "m";
      x = const_str_base_iy_x - int(textWidth(string) / 2.0);
      if (x < const_screen_x_start)
        x = const_screen_x_start;
      if (x > const_screen_x_end - int(textWidth(string)))
        x = const_screen_x_end - int(textWidth(string));
      y = iy + const_grid_offset_y;
      if(distance == 0.0)
        Grid_zero_y[instance] = y;
      text(string, x, y + const_font_height_d_2);
      //println("iy=" + iy + ":x=" + x + ",y=" + y + "," + string);
    }
  }

  y = const_str_base_ix_y;
  //if (y < const_screen_y_start) y = const_screen_y_start;
  //if (y > const_screen_y_end) y = const_screen_y_end;
  for (ix = 0; ix <= SCREEN_width + 100; ix += 100) {
    //distance = const_zoom_factor_d_100 * float(ix - const_str_offset_ix) / 100.0;
    distance = (ZOOM_FACTOR[instance] * (ix - const_str_offset_ix)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      string = distance + "m";
      x = ix + const_grid_offset_x;
      if(distance == 0.0)
        Grid_zero_x[instance] = x;
      text(string, x - int(textWidth(string) / 2.0), y);
      //println("ix=" + ix + ":x=" + x + ",y=" + y + ",const_zoom_factor_d_100=" + const_zoom_factor_d_100 + ",const_str_offset_ix=" + const_str_offset_ix + "," + string);
    }
  }
}