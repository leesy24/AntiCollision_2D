void grid_draw_rotate_180()
{
  final int const_screen_height_d_2 = SCREEN_height / 2;
  final int const_screen_x_start = TEXT_MARGIN;
  final int const_screen_x_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_y_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_y_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  //final float const_zoom_factor_d_100 = ZOOM_FACTOR / 100.0;
  final int const_grid_offset_x = const_screen_x_end - const_font_height_d_2 + (GRID_OFFSET_X % 100);
  final int const_grid_offset_y = ((SCREEN_height % 100) / 2) + (GRID_OFFSET_Y % 100) + ((((SCREEN_height / 100) % 2) == 0)?0:50);
  final int const_str_offset_ix = GRID_OFFSET_X / 100 * 100;
  final int const_str_offset_iy = SCREEN_height / 100 / 2 * 100 + GRID_OFFSET_Y / 100 * 100;
  //final int const_str_base_ix_y = (SCREEN_height / 2) + const_font_height_d_2 + GRID_OFFSET_Y;
  final int const_str_base_ix_y =
    (GRID_OFFSET_Y < TEXT_MARGIN + const_font_height_d_2 - const_screen_height_d_2)
    ?
    const_screen_y_start
    :
    ((GRID_OFFSET_Y > const_screen_height_d_2 - TEXT_MARGIN - const_font_height_d_2)
      ?
      const_screen_y_end
      :
      (const_screen_height_d_2 + const_font_height_d_2 + GRID_OFFSET_Y)
    );
  final int const_str_base_iy_x = const_screen_x_end - const_font_height_d_2 + GRID_OFFSET_X;
  int x, y;
  int ix, iy;
  String string;
  float distance;
  int image_x = MIN_INT, image_y = MIN_INT;

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  //println("SCREEN_height="+SCREEN_height);
  for (iy = -100; iy <= SCREEN_height + 100; iy += 100) {
    line(0,            iy + const_grid_offset_y,
         SCREEN_width, iy + const_grid_offset_y);
    //println("iy="+iy+":offset_y="+const_grid_offset_y+",y="+(iy + const_grid_offset_y));
  }
  for (ix = 0; ix <= SCREEN_width + 100; ix += 100) {
    line(const_grid_offset_x - ix, 0,
         const_grid_offset_x - ix, SCREEN_height);
    //println("ix="+ix+":offset_x="+const_grid_offset_x+",x="+(const_grid_offset_x - ix));
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  for (iy = -100; iy <= SCREEN_height + 100; iy += 100) {
    if (MIRROR_ENABLE)
      //distance = const_zoom_factor_d_100 * float(const_str_offset_iy - iy) / 100.0;
      distance = (ZOOM_FACTOR * (const_str_offset_iy - iy)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(iy - const_str_offset_iy) / 100.0;
      distance = (ZOOM_FACTOR * (iy - const_str_offset_iy)) / 100.0 / 100.0;
    string = distance + "m";
    x = const_str_base_iy_x - int(textWidth(string) / 2.0);
    if (x < const_screen_x_start)
      x = const_screen_x_start;
    if (x > const_screen_x_end - int(textWidth(string)))
      x = const_screen_x_end - int(textWidth(string));
    y = iy + const_grid_offset_y;
    if(distance == 0.0)
      image_y = y;
    text(string, x, y + const_font_height_d_2);
    //println("iy=" + iy + ":x=" + x + ",y=" + y + "," + string);
  }

  y = const_str_base_ix_y;
  //if (y < const_screen_y_start) y = const_screen_y_start;
  //if (y > const_screen_y_end) y = const_screen_y_end;
  for (ix = 0; ix <= SCREEN_width + 100; ix += 100) {
    //distance = const_zoom_factor_d_100 * float(ix + const_str_offset_ix) / 100.0;
    distance = (ZOOM_FACTOR * (ix + const_str_offset_ix)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      string = distance + "m";
      x = const_grid_offset_x - ix;
      if(distance == 0.0)
        image_x = x;
      text(string, x - int(textWidth(string) / 2.0), y);
      //println("ix=" + ix + ":x=" + x + ",y=" + y + "," + string);
    }
  }

  if( (image_x >= 0 - PS_image.width / 2 && image_x < SCREEN_width + PS_image.width / 2)
      &&
      (image_y >= 0 - PS_image.height / 2 && image_y < SCREEN_height + PS_image.height / 2)
    )
  {
    //println("image xy=" + image_x + "," + image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}
