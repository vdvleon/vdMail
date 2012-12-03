module vdMail;

import std.socket;

class MailServer
{
	void handleConnection(Socket socket)
	{
		Thread thread = new Thread(&handleConnection_);
		thread.start();
	}
}

class Server : std.socket.Socket
{
	private MailServer server_;
	
	this(MailServer server, ushort = 25, bool ipv6 = false, string address = "")
	{
		// Store vars
		server_ = server;
		
		// Prepare socket vars
		Address addr;
		try
		{
			addr = std.socket.parseAddress(address, port);
		}
		catch (SocketException e)
		{
			addr = ipv6 ? new std.socket.Internet6Address(port) : new std.socket.InternetAddress(port);
		}
		
		// Setup socket
		super(ipv6 ? std.socket.AddressFamily.INET6 : std.socket.AddressFamily.INET);
		socket.bind(addr);
		socket.listen(SOMAXCONN);
	}
	
	void next()
	{
		server_.handleConnection(accept());
	}
}
