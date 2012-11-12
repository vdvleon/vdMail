module vdMail;

import std.socket;

class MailServer
{
	friend class MailConnectionThread;
	
	void handleConnection(Socket socket)
	{
		MailConnectionThread thread = new MailConnectionThread(this, socket);
		thread.start();
	}
	
	enum ReplyCodes : string
	{
		SUCCESS				= "200",
		HELP_SUCCESS		= "211",
		HELP_MESSAGE		= "214",
		SERVICE_READY		= "220",
		CLOSING				= "221",
		COMPLETED			= "250",
		FORWARDING			= "251",
		START_CONTENT		= "354",
		SERVICE_UNAVAILABLE	= "421",
		MAILBOX_UNAVAILABLE	= "450",
		INTERNAL_ERROR		= "451",
		OUT_OF_STORAGE		= "452",
		COMMAND_NOT_EXISTS	= "500",
		PARAMS_ERROR		= "501",
		COMMAND_UNIMPLEMENTED = "502",
		BAD_COMMAND_ATT		= "503",
		PARAM_UNSUPPORTED	= "504",
		MAIL_UNACCEPTED		= "521",
		ACCESS_DENIED		= "530",
		ACTION_IGNORED		= "550",
		NOT_LOCAL_TRY_AGAIN	= "551",
		STORAGE_OR_MEMORY_PROBLEM = "552",
		MAIL_NOT_ACCEPT_FOR_USER = "553",
		TRANSACTION_FAIED	= "554"
	}

	private void sendCommand(std.stream.Stream stream, string code, string rest)
	{
		// Send command
		stream.write(code);
		stream.write(" ");
		stream.write(rest);
		stream.write("\r\n");
		stream.flush();
	}
	
	private	void startConnection(std.socketstream.SocketStream stream)
	{
		sendCommand(stream, ReplyCodes.SERVICE_READY, serverName(stream) + " " + 
	}
}

class MailConnectionThread
{
	MailServer server_;
	std.socket.Socket socket_;
	std.socketstream.SocketStream stream_;

	this(MailServer server, Socket socket)
	{
		// Store vars
		server_ = server;
		socket_ = socket;
		stream_ = new std.socketstream.SocketStream(socket_);
	}
	
	private void run()
	{
		try
		{
			while (!stream_.eof())
			{
				// Start
				server_.startConnection(stream_);
				
				
			}
		}
		catch (Exception e)
		{
			
		}
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
