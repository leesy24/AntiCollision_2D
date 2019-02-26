import java.util.*;
import java.text.*;

//static color C_VERSION_DATE_TEXT = 0xFFFFFFFF; // Black
static color C_VERSION_DATE_TEXT = 0xFF000000; // White

final static String VERSION_DATE_VERSION_STR = "1.00.20";
final static String VERSION_DATE_DATE_STR = "2019-02-26";

// Follow strings will be set via Const.pde
static String VERSION_DATE_VERSION_STR_CONST = "Unknown";
static String VERSION_DATE_DATE_STR_CONST = "Unknown";

static String VERSION_DATE_VERSION_STR_live;
static int VERSION_DATE_VERSION_x;
static int VERSION_DATE_DATE_x;
static SimpleDateFormat CURRENT_DATE_TIME_FORMAT = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
static int CURRENT_DATE_TIME_seconds;
static String CURRENT_DATE_TIME_STR_live;
static int CURRENT_DATE_TIME_x;

void Version_Date_setup()
{
  println("Version:" + VERSION_DATE_VERSION_STR + " Date:" + VERSION_DATE_DATE_STR);
  SYSTEM_logger.info("");
  SYSTEM_logger.info("Version:" + VERSION_DATE_VERSION_STR + " Date:" + VERSION_DATE_DATE_STR);

  textSize(FONT_HEIGHT);
  VERSION_DATE_VERSION_STR_live = "Ver. " + VERSION_DATE_VERSION_STR;
  VERSION_DATE_VERSION_x = int(SCREEN_width - TEXT_MARGIN - textWidth(VERSION_DATE_VERSION_STR_live));
  VERSION_DATE_DATE_x = int(SCREEN_width - TEXT_MARGIN - textWidth(VERSION_DATE_DATE_STR));

  Date now;
  now = new Date();
  CURRENT_DATE_TIME_seconds = now.getSeconds();
  CURRENT_DATE_TIME_STR_live = CURRENT_DATE_TIME_FORMAT.format(now);
  CURRENT_DATE_TIME_x = int(SCREEN_width - TEXT_MARGIN - textWidth(CURRENT_DATE_TIME_STR_live));

  if (!VERSION_DATE_VERSION_STR.equals(VERSION_DATE_VERSION_STR_CONST)
      ||
      !VERSION_DATE_DATE_STR.equals(VERSION_DATE_DATE_STR_CONST))
  {
    Const_create();
  }
}

void Version_Date_draw()
{
  // Sets the color used to draw text and borders around shapes.
  fill(C_VERSION_DATE_TEXT);
  stroke(C_VERSION_DATE_TEXT);
  textSize(FONT_HEIGHT);
  textAlign(LEFT, TOP);

  text(
    TITLE_COMPANY,
    TEXT_MARGIN,
    TEXT_MARGIN);

  text(
    UP_DATE_TIME_STR,
    TEXT_MARGIN,
    SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN));

  text(
  	VERSION_DATE_VERSION_STR_live,
  	VERSION_DATE_VERSION_x,
  	TEXT_MARGIN);
  text(
  	VERSION_DATE_DATE_STR,
  	VERSION_DATE_DATE_x,
  	TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN);

  Date now = new Date();
  if (CURRENT_DATE_TIME_seconds != now.getSeconds())
  {
    CURRENT_DATE_TIME_seconds = now.getSeconds();
    CURRENT_DATE_TIME_STR_live = CURRENT_DATE_TIME_FORMAT.format(now);
  }
  text(
    CURRENT_DATE_TIME_STR_live,
    CURRENT_DATE_TIME_x,
    SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN));
}
