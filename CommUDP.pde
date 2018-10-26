import hypermedia.net.*;

//final static boolean PRINT_COMM_UDP_ALL_DBG = true; 
final static boolean PRINT_COMM_UDP_ALL_DBG = false; 
final static boolean PRINT_COMM_UDP_ALL_ERR = true; 
//final static boolean PRINT_COMM_UDP_ALL_ERR = false; 

//final static boolean PRINT_COMM_UDP_SETUP_DBG = true; 
final static boolean PRINT_COMM_UDP_SETUP_DBG = false; 
//final static boolean PRINT_COMM_UDP_SETUP_ERR = true; 
final static boolean PRINT_COMM_UDP_SETUP_ERR = false; 

//final static boolean PRINT_COMM_UDP_RESET_DBG = true; 
final static boolean PRINT_COMM_UDP_RESET_DBG = false; 
//final static boolean PRINT_COMM_UDP_RESET_ERR = true; 
final static boolean PRINT_COMM_UDP_RESET_ERR = false; 

//final static boolean PRINT_COMM_UDP_OPEN_DBG = true; 
final static boolean PRINT_COMM_UDP_OPEN_DBG = false; 
//final static boolean PRINT_COMM_UDP_OPEN_ERR = true; 
final static boolean PRINT_COMM_UDP_OPEN_ERR = false; 

//final static boolean PRINT_COMM_UDP_CLOSE_DBG = true; 
final static boolean PRINT_COMM_UDP_CLOSE_DBG = false; 
//final static boolean PRINT_COMM_UDP_CLOSE_ERR = true; 
final static boolean PRINT_COMM_UDP_CLOSE_ERR = false; 

//final static boolean PRINT_COMM_UDP_SEND_DBG = true; 
final static boolean PRINT_COMM_UDP_SEND_DBG = false; 
//final static boolean PRINT_COMM_UDP_SEND_ERR = true; 
final static boolean PRINT_COMM_UDP_SEND_ERR = false; 

//final static boolean PRINT_COMM_UDP_RECV_IN_DBG = true; 
final static boolean PRINT_COMM_UDP_RECV_IN_DBG = false; 

//final static boolean PRINT_COMM_UDP_RECV_DBG = true; 
final static boolean PRINT_COMM_UDP_RECV_DBG = false; 
//final static boolean PRINT_COMM_UDP_RECV_ERR = true; 
final static boolean PRINT_COMM_UDP_RECV_ERR = false; 

//final static boolean PRINT_COMM_UDP_GET_DBG = true; 
final static boolean PRINT_COMM_UDP_GET_DBG = false; 
//final static boolean PRINT_COMM_UDP_GET_ERR = true; 
final static boolean PRINT_COMM_UDP_GET_ERR = false; 

//final static boolean PRINT_COMM_UDP_LOAD_DBG = true; 
final static boolean PRINT_COMM_UDP_LOAD_DBG = false; 
//final static boolean PRINT_COMM_UDP_LOAD_ERR = true; 
final static boolean PRINT_COMM_UDP_LOAD_ERR = false; 

final int COMM_UDP_INSTANCE_MAX = 2;
static UDP UDP_handle = null;  // The handle of UDP library to use.
static Comm_UDP Comm_UDP_handle = null;

void Comm_UDP_setup(int local_port)
{
  if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_SETUP_DBG) println("Comm_UDP_setup():local_port = "+local_port);

  if (Comm_UDP_handle != null)
  {
    if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_SETUP_ERR) println("Comm_UDP_setup():Comm_UDP_handle already setup.");
    return;
  }

  if (UDP_handle == null)
  {
    UDP_handle = new UDP(this, local_port);
    if (UDP_handle == null)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_SETUP_ERR) println("Comm_UDP_setup():UDP_handle=null");
      return;
    }
    //UDP_handle.log( true );
    UDP_handle.log( false );
    UDP_handle.setReceiveHandler("Comm_UDP_recv");
    UDP_handle.listen( true );
 }

  if (Comm_UDP_handle != null)
  {
    for (int i = 0; i < PS_INSTANCE_MAX; i ++)
    {
      Comm_UDP_handle.close(i);
    }
    Comm_UDP_handle = null;
  }

  Comm_UDP_handle = new Comm_UDP();
  if (Comm_UDP_handle == null)
  {
    UDP_handle.listen( false );
    UDP_handle.close();
    UDP_handle = null;
    if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_SETUP_ERR) println("Comm_UDP_setup():Comm_UDP_handle=null");
    return;
  }
}

void Comm_UDP_reset()
{
  if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_RESET_DBG) println("Comm_UDP_reset():");

  // Check UDP config changed
  if (UDP_handle == null)
  {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_RESET_DBG) println("Comm_UDP_reset():UDP_handle already reset.");
    return;
  }

  UDP_handle.listen( false );
  UDP_handle.close();
  UDP_handle = null;

  if (Comm_UDP_handle == null)
  {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_RESET_DBG) println("Comm_UDP_reset():Comm_UDP_handle already reset.");
    return;
  }
  Comm_UDP_handle = null;
}

void Comm_UDP_recv(byte[] data, String remote_ip, int remote_port)
{
  int instance;
  try {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_RECV_DBG || PRINT_COMM_UDP_RECV_IN_DBG) println("Comm_UDP_recv():remote_ip=" + remote_ip + ",remote_port=" + remote_port + ",data.length=" + data.length);
    if (Comm_UDP_handle == null)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_RECV_ERR) println("Comm_UDP_recv():Comm_UDP_handle=null");
      return;
    }
    instance = Comm_UDP_handle.get_instance_by_remote_ip(remote_ip);
    if (instance == -1)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_RECV_ERR) println("Comm_UDP_recv():can't get instance for remote_ip=" + remote_ip);
      return;
    }
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_RECV_DBG) println("Comm_UDP_recv():found instance=" + instance);
    Interfaces_UDP_recv(instance, data);
  }
  catch (Exception e) {
  }
} 

class Comm_UDP {
  boolean[] instance_opened = new boolean[COMM_UDP_INSTANCE_MAX];
  String[] remote_ip = new String[COMM_UDP_INSTANCE_MAX];
  int[] remote_port = new int[COMM_UDP_INSTANCE_MAX];

  Comm_UDP()
  {
    // Init. handle_opened arrary.
    for (int i = 0; i < COMM_UDP_INSTANCE_MAX; i++)
    {
      remote_ip[i] = null;
      remote_port[i] = -1;
      instance_opened[i] = false;
    }
  }

  public int open(int instance, String remote_ip, int remote_port)
  {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_OPEN_DBG) println("Comm_UDP:open("+instance+"):remote_ip="+remote_ip+",remote_port="+remote_port);
    if (instance >= COMM_UDP_INSTANCE_MAX)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_OPEN_ERR) println("Comm_UDP:open("+instance+"):instance exceed MAX.");
      return -1;
    }
    if (instance_opened[instance] != false)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_OPEN_ERR) println("Comm_UDP:open("+instance+"):instance already opended.");
      return -1;
    }
    this.remote_ip[instance] = remote_ip;
    this.remote_port[instance] = remote_port;
    instance_opened[instance] = true;
    return 0;
  }

  public int close(int instance)
  {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_CLOSE_DBG) println("Comm_UDP:close("+instance+"):");
    if (instance >= COMM_UDP_INSTANCE_MAX)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_CLOSE_ERR) println("Comm_UDP:close("+instance+"):instance exceed MAX.");
      return -1;
    }
    if (instance_opened[instance] != true)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_CLOSE_ERR) println("Comm_UDP:close("+instance+"):instance already closed.");
      return -1;
    }
    remote_ip[instance] = null;
    remote_port[instance] = -1;
    instance_opened[instance] = false;
    return 0;
  }

  public int send(int instance, byte[] buf)
  {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_SEND_DBG) println("Comm_UDP:send("+instance+"):buf.length="+buf.length);

    if (UDP_handle == null)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_SEND_ERR) println("Comm_UDP:send("+instance+"):UDP_handle=null");
      return -1;
    }
    if (instance >= COMM_UDP_INSTANCE_MAX)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_SEND_ERR) println("Comm_UDP:send("+instance+"):instance exceed MAX.");
      return -1;
    }
    if (instance_opened[instance] != true)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_SEND_ERR) println("Comm_UDP:send("+instance+"):instance not opended.");
      return -1;
    }

    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_SEND_DBG) println("Comm_UDP:send("+instance+"):remote_ip="+remote_ip[instance]+",remote_port="+remote_port[instance]);

    if (UDP_handle.send(buf, remote_ip[instance], remote_port[instance]) != true)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_SEND_ERR) println("Comm_UDP:send("+instance+"):UDP_handle.send() return false!");
      return -1;
    }

    return 0;
  }

  public int get_instance_by_remote_ip(String remote_ip_search)
  {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_GET_DBG) println("Comm_UDP:get_instance_by_remote_ip():remote_ip="+remote_ip_search);

    for (int i = 0; i < COMM_UDP_INSTANCE_MAX; i++)
    {
      if (remote_ip_search.equals(remote_ip[i]))
      {
        return i;
      }
    }
    return -1;
  }
}
