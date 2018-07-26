//static color C_VERSION_DATE_TEXT = 0xFFFFFFFF; // Black
static color C_VERSION_DATE_TEXT = 0xFF000000; // White

final static String VERSION_DATE_VERSION_STR = "1.00.10";
final static String VERSION_DATE_DATE_STR = "2018-07-26";

void Version_Date_setup()
{
  println("Version:" + VERSION_DATE_VERSION_STR + " Date:" + VERSION_DATE_DATE_STR);
  SYSTEM_logger.info("Version:" + VERSION_DATE_VERSION_STR + " Date:" + VERSION_DATE_DATE_STR);
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
  /*
  text(
  	TITLE_PRODUCT,
  	TEXT_MARGIN,
  	TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN);
  */
  textAlign(RIGHT, TOP);
  text(
  	"Ver. "+VERSION_DATE_VERSION_STR,
  	SCREEN_width - TEXT_MARGIN,
  	TEXT_MARGIN);
  text(
  	VERSION_DATE_DATE_STR,
  	SCREEN_width - TEXT_MARGIN,
  	TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN);

}