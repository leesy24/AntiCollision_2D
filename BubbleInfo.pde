static color C_BUBBLEINFO_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
static color C_BUBBLEINFO_RECT_STROKE = #000000; // Black
static color C_BUBBLEINFO_TEXT = #000000; // Black

final int BUBBLEINFO_TIMEOUT = 2000; // 2 seconds

boolean BUBBLEINFO_AVAILABLE = false;
boolean BUBBLEINFO_DISPLAY = false;
int BUBBLEINFO_POINT;
float BUBBLEINFO_DISTANCE;
float BUBBLEINFO_COR_X;
float BUBBLEINFO_COR_Y;
float BUBBLEINFO_ANGLE;
int BUBBLEINFO_PULSE_WIDTH;
int BUBBLEINFO_TIMER = -BUBBLEINFO_TIMEOUT;
int BUBBLEINFO_BOX_X, BUBBLEINFO_BOX_Y;
final static int BUBBLEINFO_POINT_WH = 10;

void bubbleinfo_draw()
{
  String[] strings = new String[6];
  int x, y, w, h, tl = 5, tr = 5, br = 0, bl = 5;

  if(BUBBLEINFO_AVAILABLE || (millis() - BUBBLEINFO_TIMER) < BUBBLEINFO_TIMEOUT)
  {

    BUBBLEINFO_DISPLAY = true;
    if(BUBBLEINFO_AVAILABLE) {
      BUBBLEINFO_TIMER = millis();
      BUBBLEINFO_AVAILABLE = false;
      //BUBBLEINFO_BOX_X = mouseX;
      //BUBBLEINFO_BOX_Y = mouseY;
    }

    strings[0] = "Point:" + BUBBLEINFO_POINT;
    strings[1] = "Angle:" + BUBBLEINFO_ANGLE + "°";
    strings[2] = "Distance:" + BUBBLEINFO_DISTANCE + "m";
    strings[3] = "Coord. X:" + BUBBLEINFO_COR_X + "m";
    strings[4] = "Coord. Y:" + BUBBLEINFO_COR_Y + "m";
    strings[5] = "PW:" + BUBBLEINFO_PULSE_WIDTH;

    // Get max string width
    w = 0;
    for( String string:strings)
    {
      w = max(w, int(textWidth(string)));    
    }
    w += TEXT_MARGIN + TEXT_MARGIN;

    h = TEXT_MARGIN + FONT_HEIGHT * 6 + TEXT_MARGIN;
    x = BUBBLEINFO_BOX_X - BUBBLEINFO_POINT_WH/2 - w;
    y = BUBBLEINFO_BOX_Y - BUBBLEINFO_POINT_WH/2 - h;
    if(x < 0 && y < 0) {
      br = 5;
      tl = 0;
      x = BUBBLEINFO_BOX_X + BUBBLEINFO_POINT_WH/2;
      y = BUBBLEINFO_BOX_Y + BUBBLEINFO_POINT_WH/2;
    }
    else if(x < 0) {
      br = 5;
      bl = 0;
      x = BUBBLEINFO_BOX_X + BUBBLEINFO_POINT_WH/2;
    }
    else if(y < 0) {
      br = 5;
      tr = 0;
      y = BUBBLEINFO_BOX_Y + BUBBLEINFO_POINT_WH/2;
    }
    
    // Sets the color used to draw box and borders around shapes.
    fill(C_BUBBLEINFO_RECT_FILL);
    stroke(C_BUBBLEINFO_RECT_STROKE);
    rect(x, y, w, h, tl, tr, br, bl);
    // Sets the color used to draw text and borders around shapes.
    fill(C_BUBBLEINFO_TEXT);
    stroke(C_BUBBLEINFO_TEXT);
    textSize(FONT_HEIGHT);
    textAlign(LEFT, BASELINE);
    int i = 0;
    x += TEXT_MARGIN;
    y +=  TEXT_MARGIN + FONT_HEIGHT - 1;
    for( String string:strings)
    {
      text(string, x, y + FONT_HEIGHT * i);
      i ++;
    }
  }
  else
  {
    BUBBLEINFO_DISPLAY = false;
  }
}