/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.lab.based.practical.csa.sockets;


/*
----------------------------------------------
TOTAL MARK = 40
-----------------------------------------------
*/

/*
----------------------------------------------
(2 mark)
import necessary libraries
-----------------------------------------------
*/
import
import
import
import

        


/*
----------------------------------------------
(1 mark)
Define a publicd class named SingleClassClientServer
-----------------------------------------------
*/
Public class SingleClassClientServer { 
    
    /*
    ----------------------------------------------
    (1 mark)
    create a logger and name it as logger
    -----------------------------------------------
    */
    private static final Logger logger = Logger.getLogger(SingleClassClientServer.class.getName());

    /*
    ----------------------------------------------
    (1 mark)
    Define a static final integer variable called PORT.  This specifies the port number that the server will listen on.
    Clients must connect to this same port.  12345 is an arbitrary port number above 1024 (well-known ports).
    -----------------------------------------------
    */
    private static final int PORT = 12345;

    /*
    ----------------------------------------------
    (1 mark)
    Define a static inner class named Server.  The 'static' keyword means this class belongs to the
    SingleClassClientServer class and doesn't require an instance of SingleClassClientServer to be created.
    It extends the Thread class, allowing the server to run concurrently with the client.
    -----------------------------------------------
    */
    Thread serverThread = new Thread(new Server());
        serverThread.start();

        /*
        ----------------------------------------------
       (1 mark)
        Declare a private instance variable serverSocket of type ServerSocket. This will hold the server's socket.
        It's private because only the Server class needs to access it.
        -----------------------------------------------
        */
        private final Socket SingleClassClientServer;

            public ClientHandler(Socket SingleClassClientServer) {
                this.SingleClassClientServer = SingleClassClientServer;
            }

        /*
        ----------------------------------------------
        (1 mark)
        Override the run() method from the Thread class.  This method contains the code that will be executed
        when the server thread is started.
        -----------------------------------------------
        */
        @Override
        public void run() {

            /*
            ----------------------------------------------
            (1 mark)
            Use a try-catch block to handle potential IOExceptions that can occur during server operations
            (e.g., if the port is already in use).
            -----------------------------------------------
            */
            


                /*
                ----------------------------------------------
                (2 marks)
                Create a new ServerSocket and bind it to the specified PORT.  This makes the server listen
                for incoming client connections on that port.
                -----------------------------------------------
                */
                try (ServerSocket serverSocket = new ServerSocket(PORT)) {
                    logger.info("Server started on port " + PORT);

                /*
                ----------------------------------------------
                (1 mark)
                Print a message to the console (System.out) indicating that the server has started and is
                listening on the specified port.
                -----------------------------------------------
                */
                logger.info("Server started on port " + PORT);

                 /*
                ----------------------------------------------
                (1 mark)
                log an informational log and provide a message like Server started on port 8000
                -----------------------------------------------
                */
                


                /*
                ----------------------------------------------
                (1 mark)
                Enter an infinite loop.  The server will continuously listen for and accept
                client connections within this loop.
                -----------------------------------------------
                */
                

                    /*
                    ----------------------------------------------
                    (2 marks)
                    Call the accept() method on the serverSocket.  This method *blocks* (waits) until a
                    client connects to the server.  When a client connects, accept() returns a Socket
                    object representing the connection to that client.
                    -----------------------------------------------
                    */
                    


                    /*
                    ----------------------------------------------
                    (2 marks)
                    Print a message to the console indicating that a client has connected.
                    getInetAddress() retrieves the IP address of the connected client.
                    -----------------------------------------------
                    */
                   



                   
                    /*
                    ----------------------------------------------
                    (3 marks)
                    Create a PrintWriter to send data (text) to the client.  clientSocket.getOutputStream()
                    gets the output stream of the client's socket.  The 'true' argument enables auto-flushing,
                    meaning data is sent immediately without needing to call out.flush().
                    -----------------------------------------------
                    */
                    
                    

                /*
                ----------------------------------------------
                (1 marks)
                Print an error message to the console (System.err) if an IOException occurs.
                e.getMessage() provides a description of the error.
                -----------------------------------------------
                */
                


                /*
                ----------------------------------------------
                (1 marks)
                Print the stack trace of the exception. This provides detailed information about where
                the error occurred, which is helpful for debugging.
                -----------------------------------------------
                */
                



    /*
    ----------------------------------------------
    (1 marks)
    Define a static inner class named Client without public keyword.  This class also extends Thread, allowing the client to run
    concurrently with the server.
    -----------------------------------------------
    */
    static class Client implements Runnable {

         /*
        ----------------------------------------------
        (1 mark)
        Override the run() method from the Thread class.  This method contains the code that will be
        executed when the client thread is started.
        -----------------------------------------------
        */
        @Override
        public void run() {

             /*
            ----------------------------------------------
            (1 mark)
            Use a try-with-resources statement to automatically close the Socket, PrintWriter,
            BufferedReader, and Scanner.
            -----------------------------------------------
            */
            try { 
            
                 /*
                ----------------------------------------------
                (3 marks)
                Create a new Socket and connect it to the server running on "localhost" (the same machine)
                at the specified PORT.  This establishes a connection to the server.
                -----------------------------------------------
                */
                Socket socket = new Socket("localhost", PORT);
                
                /*
                ----------------------------------------------
                (4 marks)
                Create a BufferedReader to read data (text) from the client.
                socket.getInputStream() gets the input stream of the client's socket.
                An InputStreamReader wraps the byte-based input stream to convert it to a character-based stream.
                -----------------------------------------------
                */
                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

                /*
                ----------------------------------------------
                (1 mark)
                Print a message to the console indicating that the client has started and connected to the server.
                -----------------------------------------------
                */
                PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
                
                /*
                ----------------------------------------------
                (1 mark)
                Print an error message to the console if an IOException occurs.
                -----------------------------------------------
                */
              



    /*
    ----------------------------------------------
    (1 mark)
    Define the main method.  This is the entry point of the program.
    -----------------------------------------------
    */
    public static void main(String[] args) {

        /*
        ----------------------------------------------
        (1 mark)
        Create a new object of the Server class and name it as server.
        -----------------------------------------------
        */


        /*
        ----------------------------------------------
        (1 mark)
        Create a new instance of the Client class and call it as client.
        -----------------------------------------------
        */
        

        /*
        ----------------------------------------------
        (1 mark)
        Start the server thread by calling .
        -----------------------------------------------
        */
        

        
        /*
        ----------------------------------------------
        (1 mark)
        Start the client thread.  This causes the client's run() method
        to be executed in a separate thread.
        -----------------------------------------------
        */

            }
        }
    }
}