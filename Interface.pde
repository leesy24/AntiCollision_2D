/**
 * ControlP5 ScrollableList
 *
 * replaces DropdownList and and ListBox. 
 * List can be scrolled by dragging the list or using the scroll-wheel. 
 *
 * by Andreas Schlegel, 2014
 * www.sojamo.de/libraries/controlp5
 *
 */
import controlP5.*;
import java.util.*;

static color C_INTERFACE_TEXT = #000000; // Black
static color C_INTERFACE_FILL_NORMAL = #FFFFFF; // White
static color C_INTERFACE_FILL_HIGHLIGHT = #C0C0C0; // White - 0x40
static color C_INTERFACE_BORDER_ACTIVE = #FF0000; // Red
static color C_INTERFACE_BORDER_NORMAL = #000000; // Black
static color C_INTERFACE_CURSOR = #0000FF; // Blue

boolean INTERFACE_changed = false;
String[] INTERFACE_str_array = {"File", "UART", "UDP", "SN"};

ControlFont cf1 = null;
ControlP5 cp5 = null;

void interface_setup()
{
  INTERFACE_changed = false;
  int x, y;
  int w, h;
  String str;

  if(cf1 == null) {
    cf1 = new ControlFont(SCREEN_PFront,12);
  }
  if(cp5 == null) {
    cp5 = new ControlP5(this, cf1);
    cp5.setBackground(C_INTERFACE_FILL_NORMAL);
  }
  else {
    cp5.remove("interface_ddmenu");
    cp5.remove("interface_ddborder");
    cp5.remove("interface_ddlabel");
    cp5.remove("interface_filename");
    cp5.remove("interface_UARTport");
    cp5.remove("interface_UARTbaud");
    cp5.remove("interface_UARTdps");
    cp5.remove("interface_UDPremoteip");
    cp5.remove("interface_UDPremoteport");
    cp5.remove("interface_UDPlocalport");
    cp5.remove("interface_SNserialnumber");

    cp5.setGraphics(this,0,0);
  }

  w = 0;
  for(String s: INTERFACE_str_array) {
    w = int(max(w, int(textWidth(s))));
  }
  w += 20;
  x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w;
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  y = TEXT_MARGIN + FONT_HEIGHT * 1 + TEXT_MARGIN;

  Textfield tf_ddborder;
  tf_ddborder = cp5.addTextfield("interface_ddborder");
  tf_ddborder.setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_INTERFACE_FILL_NORMAL)
    .setColorForeground( C_INTERFACE_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  /* add a ScrollableList, by default it behaves like a DropdownList */
  ScrollableList sl_ddmenu;
  sl_ddmenu = cp5.addScrollableList("interface_ddmenu"/*l.get(0).toString()*/);
  sl_ddmenu.setBackgroundColor( C_INTERFACE_BORDER_ACTIVE /*color(255,0,255)*/ /*color( 255 , 128 )*/ )
     .setColorBackground( C_INTERFACE_FILL_NORMAL /*color(255,255,0)*/ /*color(200)*/ )
     .setColorForeground( C_INTERFACE_FILL_HIGHLIGHT /*color(0,255,255)*/ /*color(235)*/ )
     .setColorActive( C_INTERFACE_BORDER_ACTIVE /*color(255,0,0)*/ /*(color(255)*/ )
     .setColorValueLabel( C_INTERFACE_TEXT /*color(0,255,0)*/ /*color(100)*/ )
     .setColorCaptionLabel( C_INTERFACE_TEXT /*color(0,0,255)*/ /*color(50)*/ )
     .setPosition(x + 1, y + 1)
     .setSize(w - 2, h + (h + 1) * (INTERFACE_str_array.length - 1) - 2)
     .setBarHeight(h - 2)
     .setItemHeight(h + 1 - 2)
     //.setBarHeight(100)
     //.setItemHeight(100)
     .setOpen(false)
     .addItems(INTERFACE_str_array)
     .setCaptionLabel(INTERFACE_str_array[DATA_interface])
     .removeItem(INTERFACE_str_array[DATA_interface])
     //.setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  //y += h;
  sl_ddmenu.getCaptionLabel()
      //.setFont(cf1)
      .setSize(FONT_HEIGHT)
      .toUpperCase(false)
      ;
  sl_ddmenu.getCaptionLabel()
      .getStyle()
        //.setPaddingTop(32/2 - 4)
        //.setPaddingTop((32 - 12 ) / 2)
        //.padding(10,10,10,10)
        .marginTop = int(float(FONT_HEIGHT)/2.0-float(FONT_HEIGHT)/6.0);
  sl_ddmenu.getValueLabel()
      //.setFont(cf1)
      .setSize(FONT_HEIGHT)
      .toUpperCase(false)
      ;
  sl_ddmenu.getValueLabel()
      .getStyle()
        //.setPaddingTop(32/2 - 4)
        //.setPaddingTop((32 - 12 ) / 2)
        //.padding(10,10,10,10)
        //.marginTop = 32/2-4;
        .marginTop = int(float(FONT_HEIGHT)/2.0-float(FONT_HEIGHT)/6.0) - 1;
  //sl_ddmenu.getValueLabel().getStyle().padding(4,4,3,3);
/*
  CColor c = new CColor();
  c.setBackground(C_INTERFACE_BORDER_ACTIVE);
  //c.setForeground(C_INTERFACE_BORDER_ACTIVE);
  sl_ddmenu.getItem(DATA_interface).put("color", c);
*/

  str = "Interface:";
  w = int(textWidth(str));
  x -= w + TEXT_MARGIN;
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  Textlabel tl_ddlabel;
  tl_ddlabel = cp5.addTextlabel("interface_ddlabel");
  tl_ddlabel.setText(str)
    .setPosition(x, y)
    .setColorValue(C_INTERFACE_TEXT)
    .setHeight(h)
    ;
  tl_ddlabel.get()
      .setSize(FONT_HEIGHT)
      ;

  y += h;

  Textfield tf_param1, tf_param2, tf_param3;
  if(DATA_interface == DATA_INTERFACE_FILE) {
    str = FILE_name;
    w = int(textWidth(str)) + TEXT_MARGIN*2;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    y += TEXT_MARGIN;
    tf_param1 = cp5.addTextfield("interface_filename");
    tf_param1.setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_INTERFACE_FILL_NORMAL )
      .setColorForeground( C_INTERFACE_BORDER_NORMAL )
      .setColorActive( C_INTERFACE_BORDER_ACTIVE )
      .setColorValueLabel( C_INTERFACE_TEXT )
      .setColorCursor( C_INTERFACE_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    y += h;
    //println("tf.getText() = ", tf.getText());
    tf_param1.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param1.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param1.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/
  }
  else if(DATA_interface == DATA_INTERFACE_UART) {
    str = UART_port_name;
    w = int(textWidth(str)) + TEXT_MARGIN*2;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    y += TEXT_MARGIN;
    tf_param1 = cp5.addTextfield("interface_UARTport");
    tf_param1.setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_INTERFACE_FILL_NORMAL )
      .setColorForeground( C_INTERFACE_BORDER_NORMAL )
      .setColorActive( C_INTERFACE_BORDER_ACTIVE )
      .setColorValueLabel( C_INTERFACE_TEXT )
      .setColorCursor( C_INTERFACE_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    y += h;
    tf_param1.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param1.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param1.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/
    str = Integer.toString(UART_baud_rate);
    w = int(textWidth(str)) + TEXT_MARGIN*2;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    y += TEXT_MARGIN;
    tf_param2 = cp5.addTextfield("interface_UARTbaud");
    tf_param2.setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_INTERFACE_FILL_NORMAL )
      .setColorForeground( C_INTERFACE_BORDER_NORMAL )
      .setColorActive( C_INTERFACE_BORDER_ACTIVE )
      .setColorValueLabel( C_INTERFACE_TEXT )
      .setColorCursor( C_INTERFACE_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    y += h;
    //println("tf.getText() = ", tf.getText());
    tf_param2.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param2.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param2.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/

    str = Integer.toString(UART_data_bits) + UART_parity;
    if(int(UART_stop_bits*10.0)%10 == 0)
      str += int(UART_stop_bits);
    else
      str += UART_stop_bits;
    w = int(textWidth(str)) + TEXT_MARGIN*2;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    y += TEXT_MARGIN;
    tf_param3 = cp5.addTextfield("interface_UARTdps");
    tf_param3.setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_INTERFACE_FILL_NORMAL )
      .setColorForeground( C_INTERFACE_BORDER_NORMAL )
      .setColorActive( C_INTERFACE_BORDER_ACTIVE )
      .setColorValueLabel( C_INTERFACE_TEXT )
      .setColorCursor( C_INTERFACE_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    y += h;
    //println("tf.getText() = ", tf.getText());
    tf_param3.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param3.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param3.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/
  }
  else if(DATA_interface == DATA_INTERFACE_UDP) {
    str = UDP_remote_ip;
    w = int(textWidth(str)) + TEXT_MARGIN*2;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    y += TEXT_MARGIN;
    tf_param1 = cp5.addTextfield("interface_UDPremoteip");
    tf_param1.setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_INTERFACE_FILL_NORMAL )
      .setColorForeground( C_INTERFACE_BORDER_NORMAL )
      .setColorActive( C_INTERFACE_BORDER_ACTIVE )
      .setColorValueLabel( C_INTERFACE_TEXT )
      .setColorCursor( C_INTERFACE_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //Textfield.cursorWidth = 10;
    //controlP5.Textfield.cursorWidth = 10;
    y += h;
    //println("tf.getText() = ", tf.getText());
    tf_param1.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param1.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param1.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/

    str = Integer.toString(UDP_remote_port);
    w = int(textWidth(str)) + TEXT_MARGIN*2;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    y += TEXT_MARGIN;
    tf_param2 = cp5.addTextfield("interface_UDPremoteport");
    tf_param2.setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_INTERFACE_FILL_NORMAL )
      .setColorForeground( C_INTERFACE_BORDER_NORMAL )
      .setColorActive( C_INTERFACE_BORDER_ACTIVE )
      .setColorValueLabel( C_INTERFACE_TEXT )
      .setColorCursor( C_INTERFACE_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    y += h;
    //println("tf.getText() = ", tf.getText());
    tf_param2.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param2.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param2.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/

    str = Integer.toString(UDP_local_port);
    w = int(textWidth(str)) + TEXT_MARGIN*2;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    y += TEXT_MARGIN;
    tf_param3 = cp5.addTextfield("interface_UDPlocalport");
    tf_param3.setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_INTERFACE_FILL_NORMAL )
      .setColorForeground( C_INTERFACE_BORDER_NORMAL )
      .setColorActive( C_INTERFACE_BORDER_ACTIVE )
      .setColorValueLabel( C_INTERFACE_TEXT )
      .setColorCursor( C_INTERFACE_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    y += h;
    //println("tf.getText() = ", tf.getText());
    tf_param3.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param3.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param3.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/
  }
  else /*if(DATA_interface == DATA_INTERFACE_SN)*/ {
    str = Integer.toString(SN_serial_number);
    w = int(textWidth(str)) + TEXT_MARGIN*2;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w - 1;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    y += TEXT_MARGIN;
    tf_param1 = cp5.addTextfield("interface_SNserialnumber");
    tf_param1.setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_INTERFACE_FILL_NORMAL )
      .setColorForeground( C_INTERFACE_BORDER_NORMAL )
      .setColorActive( C_INTERFACE_BORDER_ACTIVE )
      .setColorValueLabel( C_INTERFACE_TEXT )
      .setColorCursor( C_INTERFACE_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //Textfield.cursorWidth = 10;
    //controlP5.Textfield.cursorWidth = 10;
    y += h;
    //println("tf.getText() = ", tf.getText());
    tf_param1.getValueLabel()
        //.setFont(cf1)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_param1.getValueLabel()
        .getStyle()
          .marginTop = -1;
/*
    tf_param1.getValueLabel()
        .getStyle()
          .marginLeft = TEXT_MARGIN;
*/

  }

  tf_ddborder.bringToFront();
  sl_ddmenu.bringToFront();
  //println(sl_ddmenu.getBackgroundColor());
  //printArray(PFont.list());
}

void interface_draw()
{
/*
  String string;

  // Sets the color used to draw lines and borders around shapes.
  stroke(C_INTERFACE_TEXT);
  fill(C_INTERFACE_TEXT);
  //stroke(#FF0000);
  //fill(#ff0000);
  
  string = "Interface";
  text(string, SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - int(textWidth(string)), TEXT_MARGIN + FONT_HEIGHT * 2);
*/
}

void interface_mouseReleased()
{
  try {
    Controller controller = (Controller)cp5.getWindow().getMouseOverList().get(0);
    if(controller.getName().equals("interface_ddmenu") == true) {
      ScrollableList sl_ddmenu = (ScrollableList)controller;
      Textfield tf_ddborder;
      int x, y, w, h;
      int c;
  
      w = 0;
      for(String s: INTERFACE_str_array) {
        w = int(max(w, int(textWidth(s))));
      }
      w += 20;
      x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w;
      y = TEXT_MARGIN + FONT_HEIGHT * 1 + TEXT_MARGIN;
      if(sl_ddmenu.isOpen()) {
        h = FONT_HEIGHT + TEXT_MARGIN*2 + (FONT_HEIGHT + TEXT_MARGIN*2 + 1 - 2) * (INTERFACE_str_array.length - 1);
        c = C_INTERFACE_BORDER_ACTIVE;
      }
      else {
        h = FONT_HEIGHT + TEXT_MARGIN*2;
        c = C_INTERFACE_BORDER_NORMAL;
      }
      tf_ddborder = (Textfield)cp5.getController("interface_ddborder");
      tf_ddborder
        .setPosition(x+1, y)
        .setSize(w - 2, h)
        .setColorForeground( c )
        ;
      sl_ddmenu
        .setItems(INTERFACE_str_array)
        .removeItem(INTERFACE_str_array[DATA_interface])
        ;
      return;
    }
  }
  catch (Exception e) {
    // Do nothing
  }

  ScrollableList sl_ddmenu;
  Textfield tf_param;
  String str;

  sl_ddmenu = (ScrollableList)cp5.get("interface_ddmenu");
  if( sl_ddmenu != null && sl_ddmenu.isOpen()) {
    Textfield tf_ddborder;
    int x, y, w, h;
    int c;

    w = 0;
    for(String s: INTERFACE_str_array) {
      w = int(max(w, int(textWidth(s))));
    }
    w += 20;
    x = SCREEN_width - TEXT_MARGIN - FONT_HEIGHT * 3 - w;
    y = TEXT_MARGIN + FONT_HEIGHT * 1 + TEXT_MARGIN;
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    c = C_INTERFACE_BORDER_NORMAL;
    tf_ddborder = (Textfield)cp5.getController("interface_ddborder");
    tf_ddborder
      .setPosition(x+1, y)
      .setSize(w - 2, h)
      .setColorForeground( c )
      ;
    sl_ddmenu.close();
  }
  if(DATA_interface == DATA_INTERFACE_FILE) {
    tf_param = (Textfield)cp5.get("interface_filename");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = FILE_name;
      tf_param.setText(str);
    }
  }
  else if(DATA_interface == DATA_INTERFACE_UART) {
    tf_param = (Textfield)cp5.get("interface_UARTport");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = UART_port_name;
      tf_param.setText(str);
    }
    tf_param = (Textfield)cp5.get("interface_UARTbaud");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = Integer.toString(UART_baud_rate);
      tf_param.setText(str);
    }
    tf_param = (Textfield)cp5.get("interface_UARTdps");
     if( tf_param != null && tf_param.isFocus() == false) {
     str = Integer.toString(UART_data_bits) + UART_parity;
      if(int(UART_stop_bits*10.0)%10 == 0)
        str += int(UART_stop_bits);
      else
        str += UART_stop_bits;
      tf_param.setText(str);
    }
  }
  else if(DATA_interface == DATA_INTERFACE_UDP) {
    tf_param = (Textfield)cp5.get("interface_UDPremoteip");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = UDP_remote_ip;
      tf_param.setText(str);
    }
    tf_param = (Textfield)cp5.get("interface_UDPremoteport");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = Integer.toString(UDP_remote_port);
      tf_param.setText(str);
    }
    tf_param = (Textfield)cp5.get("interface_UDPlocalport");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = Integer.toString(UDP_local_port);
      tf_param.setText(str);
    }
  }
  else /*if(DATA_interface == DATA_INTERFACE_SN)*/ {
    tf_param = (Textfield)cp5.get("interface_SNserialnumber");
    if( tf_param != null && tf_param.isFocus() == false) {
      str = Integer.toString(SN_serial_number);
      tf_param.setText(str);
    }
  }
}

/*
void controlEvent(ControlEvent theEvent)
{
  String ControllerName = theEvent.getController().getName();
  println("got a control event from controller with name "+","+ControllerName);

  if (ControllerName.equals("interface_ddmenu") == true) {
    println("this event was triggered by Controller interface_ddmenu");
  }
  
}
*/

void interface_ddmenu(int n)
{
/*
  ScrollableList sl_ddmenu = (ScrollableList)(cp5.get("interface_ddmenu"));
  //int interface = ((sl_ddmenu.getItem(n)).getValue();
  Map m = cp5.get(ScrollableList.class, "interface_ddmenu").getItem(n);
  int interface = m.get("value");
*/
  /* request the selected item based on index n */
  //println("dropdown=", n, ",", cp5.get(ScrollableList.class, "interface_ddmenu").getItem(n));
  
  /* here an item is stored as a Map  with the following key-value pairs:
   * name, the given name of the item
   * text, the given text of the item by default the same as name
   * value, the given value of the item, can be changed by using .getItem(n).put("value", "abc"); a value here is of type Object therefore can be anything
   * color, the given color of the item, how to change, see below
   * view, a customizable view, is of type CDrawable 
   */
/*
  for(int i = 0; i < 3; i ++) {
    CColor c = new CColor();
    if(i == n)
      c.setBackground(color(255,0,0));
    else
      c.setBackground(color(255,255,0));
    cp5.get(ScrollableList.class, "dropdown").getItem(i).put("color", c);
  }
*/
  if( n >= DATA_interface ) n ++;

  if( DATA_interface != n ) {
    DATA_interface = n;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_filename(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(theText.equals(FILE_name) != true) {
    FILE_name = theText;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_UARTport(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(theText.equals(UART_port_name) != true) {
    UART_port_name = theText;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_UARTbaud(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int baud_rate = Integer.parseInt(theText);
  if(baud_rate != UART_baud_rate) {
    UART_baud_rate = baud_rate;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_UARTdps(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int data_bits = Character.getNumericValue(theText.charAt(0));
  char parity = theText.charAt(1);
  float stop_bits = Float.valueOf(theText.substring(2));
  if( data_bits != UART_data_bits ||
      parity != UART_parity ||
      stop_bits != UART_stop_bits) {
    UART_data_bits = data_bits;
    UART_parity = parity;
    UART_stop_bits = stop_bits;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_UDPremoteip(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  if(theText.equals(UDP_remote_ip) != true) {
    UDP_remote_ip = theText;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_UDPremoteport(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int remote_port = Integer.parseInt(theText);
  if(remote_port != UDP_remote_port) {
    UDP_remote_port = remote_port;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_UDPlocalport(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int local_port = Integer.parseInt(theText);
  if(local_port != UDP_local_port) {
    UDP_local_port = local_port;
    config_save();
    INTERFACE_changed = true;
  }
}

void interface_SNserialnumber(String theText)
{
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);

  int serial_number = Integer.parseInt(theText);
  if(serial_number != SN_serial_number) {
    SN_serial_number = serial_number;
    config_save();
    INTERFACE_changed = true;
  }
}

/*
void keyPressed() {
  switch(key) {
    case('1'):
    // make the ScrollableList behave like a ListBox
    cp5.get(ScrollableList.class, "dropdown").setType(ControlP5.LIST);
    break;
    case('2'):
    // make the ScrollableList behave like a DropdownList
    cp5.get(ScrollableList.class, "dropdown").setType(ControlP5.DROPDOWN);
    break;
    case('3'):
    // change content of the ScrollableList
    List l = Arrays.asList("a-1", "b-1", "c-1", "d-1", "e-1", "f-1", "g-1", "h-1", "i-1", "j-1", "k-1");
    cp5.get(ScrollableList.class, "dropdown").setItems(l);
    break;
    case('4'):
    // remove an item from the ScrollableList
    cp5.get(ScrollableList.class, "dropdown").removeItem("k-1");
    break;
    case('5'):
    // clear the ScrollableList
    cp5.get(ScrollableList.class, "dropdown").clear();
    break;
  }
}
*/
/*
a list of all methods available for the ScrollableList Controller
use ControlP5.printPublicMethodsFor(ScrollableList.class);
to print the following list into the console.

You can find further details about class ScrollableList in the javadoc.

Format:
ClassName : returnType methodName(parameter type)


controlP5.Controller : CColor getColor() 
controlP5.Controller : ControlBehavior getBehavior() 
controlP5.Controller : ControlWindow getControlWindow() 
controlP5.Controller : ControlWindow getWindow() 
controlP5.Controller : ControllerProperty getProperty(String) 
controlP5.Controller : ControllerProperty getProperty(String, String) 
controlP5.Controller : ControllerView getView() 
controlP5.Controller : Label getCaptionLabel() 
controlP5.Controller : Label getValueLabel() 
controlP5.Controller : List getControllerPlugList() 
controlP5.Controller : Pointer getPointer() 
controlP5.Controller : ScrollableList addCallback(CallbackListener) 
controlP5.Controller : ScrollableList addListener(ControlListener) 
controlP5.Controller : ScrollableList addListenerFor(int, CallbackListener) 
controlP5.Controller : ScrollableList align(int, int, int, int) 
controlP5.Controller : ScrollableList bringToFront() 
controlP5.Controller : ScrollableList bringToFront(ControllerInterface) 
controlP5.Controller : ScrollableList 1() 
controlP5.Controller : ScrollableList linebreak() 
controlP5.Controller : ScrollableList listen(boolean) 
controlP5.Controller : ScrollableList lock() 
controlP5.Controller : ScrollableList onChange(CallbackListener) 
controlP5.Controller : ScrollableList onClick(CallbackListener) 
controlP5.Controller : ScrollableList onDoublePress(CallbackListener) 
controlP5.Controller : ScrollableList onDrag(CallbackListener) 
controlP5.Controller : ScrollableList onDraw(ControllerView) 
controlP5.Controller : ScrollableList onEndDrag(CallbackListener) 
controlP5.Controller : ScrollableList onEnter(CallbackListener) 
controlP5.Controller : ScrollableList onLeave(CallbackListener) 
controlP5.Controller : ScrollableList onMove(CallbackListener) 
controlP5.Controller : ScrollableList onPress(CallbackListener) 
controlP5.Controller : ScrollableList onRelease(CallbackListener) 
controlP5.Controller : ScrollableList onReleaseOutside(CallbackListener) 
controlP5.Controller : ScrollableList onStartDrag(CallbackListener) 
controlP5.Controller : ScrollableList onWheel(CallbackListener) 
controlP5.Controller : ScrollableList plugTo(Object) 
controlP5.Controller : ScrollableList plugTo(Object, String) 
controlP5.Controller : ScrollableList plugTo(Object[]) 
controlP5.Controller : ScrollableList plugTo(Object[], String) 
controlP5.Controller : ScrollableList registerProperty(String) 
controlP5.Controller : ScrollableList registerProperty(String, String) 
controlP5.Controller : ScrollableList registerTooltip(String) 
controlP5.Controller : ScrollableList removeBehavior() 
controlP5.Controller : ScrollableList removeCallback() 
controlP5.Controller : ScrollableList removeCallback(CallbackListener) 
controlP5.Controller : ScrollableList removeListener(ControlListener) 
controlP5.Controller : ScrollableList removeListenerFor(int, CallbackListener) 
controlP5.Controller : ScrollableList removeListenersFor(int) 
controlP5.Controller : ScrollableList removeProperty(String) 
controlP5.Controller : ScrollableList removeProperty(String, String) 
controlP5.Controller : ScrollableList setArrayValue(float[]) 
controlP5.Controller : ScrollableList setArrayValue(int, float) 
controlP5.Controller : ScrollableList setBehavior(ControlBehavior) 
controlP5.Controller : ScrollableList setBroadcast(boolean) 
controlP5.Controller : ScrollableList setCaptionLabel(String) 
controlP5.Controller : ScrollableList setColor(CColor) 
controlP5.Controller : ScrollableList setColorActive(int) 
controlP5.Controller : ScrollableList setColorBackground(int) 
controlP5.Controller : ScrollableList setColorCaptionLabel(int) 
controlP5.Controller : ScrollableList setColorForeground(int) 
controlP5.Controller : ScrollableList setColorLabel(int) 
controlP5.Controller : ScrollableList setColorValue(int) 
controlP5.Controller : ScrollableList setColorValueLabel(int) 
controlP5.Controller : ScrollableList setDecimalPrecision(int) 
controlP5.Controller : ScrollableList setDefaultValue(float) 
controlP5.Controller : ScrollableList setHeight(int) 
controlP5.Controller : ScrollableList setId(int) 
controlP5.Controller : ScrollableList setImage(PImage) 
controlP5.Controller : ScrollableList setImage(PImage, int) 
controlP5.Controller : ScrollableList setImages(PImage, PImage, PImage) 
controlP5.Controller : ScrollableList setImages(PImage, PImage, PImage, PImage) 
controlP5.Controller : ScrollableList setLabel(String) 
controlP5.Controller : ScrollableList setLabelVisible(boolean) 
controlP5.Controller : ScrollableList setLock(boolean) 
controlP5.Controller : ScrollableList setMax(float) 
controlP5.Controller : ScrollableList setMin(float) 
controlP5.Controller : ScrollableList setMouseOver(boolean) 
controlP5.Controller : ScrollableList setMoveable(boolean) 
controlP5.Controller : ScrollableList setPosition(float, float) 
controlP5.Controller : ScrollableList setPosition(float[]) 
controlP5.Controller : ScrollableList setSize(PImage) 
controlP5.Controller : ScrollableList setSize(int, int) 
controlP5.Controller : ScrollableList setStringValue(String) 
controlP5.Controller : ScrollableList setUpdate(boolean) 
controlP5.Controller : ScrollableList setValue(float) 
controlP5.Controller : ScrollableList setValueLabel(String) 
controlP5.Controller : ScrollableList setValueSelf(float) 
controlP5.Controller : ScrollableList setView(ControllerView) 
controlP5.Controller : ScrollableList setVisible(boolean) 
controlP5.Controller : ScrollableList setWidth(int) 
controlP5.Controller : ScrollableList show() 
controlP5.Controller : ScrollableList unlock() 
controlP5.Controller : ScrollableList unplugFrom(Object) 
controlP5.Controller : ScrollableList unplugFrom(Object[]) 
controlP5.Controller : ScrollableList unregisterTooltip() 
controlP5.Controller : ScrollableList update() 
controlP5.Controller : ScrollableList updateSize() 
controlP5.Controller : String getAddress() 
controlP5.Controller : String getInfo() 
controlP5.Controller : String getName() 
controlP5.Controller : String getStringValue() 
controlP5.Controller : String toString() 
controlP5.Controller : Tab getTab() 
controlP5.Controller : boolean isActive() 
controlP5.Controller : boolean isBroadcast() 
controlP5.Controller : boolean isInside() 
controlP5.Controller : boolean isLabelVisible() 
controlP5.Controller : boolean isListening() 
controlP5.Controller : boolean isLock() 
controlP5.Controller : boolean isMouseOver() 
controlP5.Controller : boolean isMousePressed() 
controlP5.Controller : boolean isMoveable() 
controlP5.Controller : boolean isUpdate() 
controlP5.Controller : boolean isVisible() 
controlP5.Controller : float getArrayValue(int) 
controlP5.Controller : float getDefaultValue() 
controlP5.Controller : float getMax() 
controlP5.Controller : float getMin() 
controlP5.Controller : float getValue() 
controlP5.Controller : float[] getAbsolutePosition() 
controlP5.Controller : float[] getArrayValue() 
controlP5.Controller : float[] getPosition() 
controlP5.Controller : int getDecimalPrecision() 
controlP5.Controller : int getHeight() 
controlP5.Controller : int getId() 
controlP5.Controller : int getWidth() 
controlP5.Controller : int listenerSize() 
controlP5.Controller : void remove() 
controlP5.Controller : void setView(ControllerView, int) 
controlP5.ScrollableList : List getItems() 
controlP5.ScrollableList : Map getItem(String) 
controlP5.ScrollableList : Map getItem(int) 
controlP5.ScrollableList : ScrollableList addItem(String, Object) 
controlP5.ScrollableList : ScrollableList addItems(List) 
controlP5.ScrollableList : ScrollableList addItems(Map) 
controlP5.ScrollableList : ScrollableList addItems(String[]) 
controlP5.ScrollableList : ScrollableList clear() 
controlP5.ScrollableList : ScrollableList close() 
controlP5.ScrollableList : ScrollableList open() 
controlP5.ScrollableList : ScrollableList removeItem(String) 
controlP5.ScrollableList : ScrollableList removeItems(List) 
controlP5.ScrollableList : ScrollableList setBackgroundColor(int) 
controlP5.ScrollableList : ScrollableList setBarHeight(int) 
controlP5.ScrollableList : ScrollableList setBarVisible(boolean) 
controlP5.ScrollableList : ScrollableList setItemHeight(int) 
controlP5.ScrollableList : ScrollableList setItems(List) 
controlP5.ScrollableList : ScrollableList setItems(Map) 
controlP5.ScrollableList : ScrollableList setItems(String[]) 
controlP5.ScrollableList : ScrollableList setOpen(boolean) 
controlP5.ScrollableList : ScrollableList setScrollSensitivity(float) 
controlP5.ScrollableList : ScrollableList setType(int) 
controlP5.ScrollableList : boolean isBarVisible() 
controlP5.ScrollableList : boolean isOpen() 
controlP5.ScrollableList : int getBackgroundColor() 
controlP5.ScrollableList : int getBarHeight() 
controlP5.ScrollableList : int getHeight() 
controlP5.ScrollableList : void controlEvent(ControlEvent) 
controlP5.ScrollableList : void keyEvent(KeyEvent) 
controlP5.ScrollableList : void setDirection(int) 
controlP5.ScrollableList : void updateItemIndexOffset() 
java.lang.Object : String toString() 
java.lang.Object : boolean equals(Object) 

created: 2015/03/24 12:21:22

*/
