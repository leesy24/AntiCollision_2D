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

final int COMM_UDP_INSTANCE_MAX = PS_INSTANCE_MAX;
static UDP[] UDP_handle = new UDP[PS_INSTANCE_MAX];  // The handle of UDP library to static
Comm_UDP Comm_UDP_handle = null;
static int[] Comm_UDP_local_port = new int[PS_INSTANCE_MAX];

void Comm_UDP_setup()
{
  if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_SETUP_DBG) println("Comm_UDP_setup()");

  if (Comm_UDP_handle != null)
  {
    if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_SETUP_ERR) println("Comm_UDP_setup():Comm_UDP_handle already setup.");
    return;
  }

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    Comm_UDP_local_port[i] = -1;
    UDP_handle[i] = null;
  }

  Comm_UDP_handle = new Comm_UDP();
  if (Comm_UDP_handle == null)
  {
    if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_OPEN_DBG) println("Comm_UDP_setup():Comm_UDP_handle=null");
    return;
  }
}

void Comm_UDP_reset()
{
  if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_RESET_DBG) println("Comm_UDP_reset():");

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    // Check UDP config changed
    if (UDP_handle[i] != null)
    {
      if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_OPEN_ERR) println("Comm_UDP_reset()"+":Comm_UDP_local_port["+i+"]="+Comm_UDP_local_port[i]+",UDP_handle["+i+"]="+UDP_handle[i]);
      UDP_handle[i].listen( false );
      UDP_handle[i].close();
      UDP_handle[i] = null;
      Comm_UDP_local_port[i] = -1;
    }
  }

  if (Comm_UDP_handle == null)
  {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_RESET_DBG) println("Comm_UDP_reset():Comm_UDP_handle already reset.");
    return;
  }

  Comm_UDP_handle = null;
}

void Comm_UDP_open(int instance, int local_port)
{
  if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_OPEN_DBG) println("Comm_UDP_open("+instance+")"+":local_port="+local_port);

  if (Comm_UDP_handle == null)
  {
    if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_OPEN_ERR) println("Comm_UDP_open("+instance+"):Comm_UDP_handle not setup.");
    return;
  }

  int i;

  for (i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (Comm_UDP_local_port[i] == local_port)
      break;
  }

  if (i != PS_INSTANCE_MAX)
  {
    Comm_UDP_local_port[instance] = local_port;
    UDP_handle[instance] = UDP_handle[i];
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_OPEN_DBG) println("Comm_UDP_open("+instance+"):reuse UDP_handle "+i);
    return;
  }

  if (Comm_UDP_local_port[instance] != -1)
  {
    if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_OPEN_DBG) println("Comm_UDP_open("+instance+"):UDP_handle[]!=-1");
    UDP_handle[instance].listen( false );
    UDP_handle[instance].close();
    UDP_handle[instance] = null;
    Comm_UDP_local_port[instance] = -1;
  }

  Comm_UDP_local_port[instance] = local_port;

  UDP_handle[instance] = new UDP(this, local_port);
  if (UDP_handle[instance] == null)
  {
    if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_OPEN_ERR) println("Comm_UDP_open("+instance+"):UDP_handle[]=null");
    return;
  }

  //UDP_handle[instance].log( true );
  UDP_handle[instance].log( false );
  UDP_handle[instance].setReceiveHandler("Comm_UDP_recv");
  UDP_handle[instance].listen( true );
}

void Comm_UDP_close(int instance)
{
  if (PRINT_COMM_UDP_ALL_DBG || PRINT_COMM_UDP_CLOSE_DBG) println("Comm_UDP_close("+instance+")");

  if (Comm_UDP_local_port[instance] != -1)
  {
    if (PRINT_COMM_UDP_ALL_ERR || PRINT_COMM_UDP_CLOSE_ERR) println("Comm_UDP_close("+instance+"):Comm_UDP_handle already close.");
    return;
  }

  int found = 0;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (Comm_UDP_local_port[i] == Comm_UDP_local_port[instance])
      found ++;
  }

  if (found == 1)
  {
    UDP_handle[instance].listen( false );
    UDP_handle[instance].close();
  }
  UDP_handle[instance] = null;

  Comm_UDP_local_port[instance] = -1;
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

    if (UDP_handle[instance] == null)
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

    if (UDP_handle[instance].send(buf, remote_ip[instance], remote_port[instance]) != true)
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
