//static color C_GRID_LINE = #808080; // Black + 0x80
static color C_GRID_LINE = #C0C0C0; // Black + 0xC0
static color C_GRID_TEXT = #404040; // Black + 0x40
//static color C_GRID_TEXT = #808080; //Black + 0x80

int[] Grid_zero_x;
int[] Grid_zero_y;

void Grid_settings()
{
  Grid_zero_x = new int[PS_INSTANCE_MAX];
  Grid_zero_y = new int[PS_INSTANCE_MAX];
}

void Grid_draw()
{
  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (ROTATE_FACTOR[i] == 315) {
      Grid_draw_rotate_315(i);
    } else if (ROTATE_FACTOR[i] == 45) {
      Grid_draw_rotate_45(i);
    } else if (ROTATE_FACTOR[i] == 135) {
      Grid_draw_rotate_135(i);
    } else /*if (ROTATE_FACTOR[i] == 225)*/ {
      Grid_draw_rotate_225(i);
    }
  }
}
