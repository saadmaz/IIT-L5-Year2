/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.lab.based.practical.csa.http;


/*
----------------------------------------------
TOTAL MARK = 45
-----------------------------------------------
 */
 /*
----------------------------------------------
(3 marks)
Import necessary classes:
- HttpServer: The core class for creating an HTTP server. - Done 
- HttpExchange: Represents a single HTTP request/response exchange. - 
- HttpHandler: Interface for handling HTTP requests.
- InetSocketAddress: Represents a socket address (IP address and port number). - DONE
- IOException: For handling I/O exceptions. - DONE 
- OutputStream: For writing the response body. - DONE
- URI: represents an Uniform Resource Identifier (URI) reference
-----------------------------------------------
*/

import com.sun.net.httpserver.HttpExchange; //for creating an HTTP Server 
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress; // Representing Socket Addresses 
import java.io.IOException; //Handling IO exceptions 
import java.io.OutputStream; //Writing the response body 

/*
----------------------------------------------
(1 mark)
Define a class named SimpleHttpServer.
-----------------------------------------------
*/
public class SimpleHttpServer {


}
    /*
    ----------------------------------------------
    (1 mark)
    Define the main method.
    -----------------------------------------------
    */
    public static void main(String[] args) {

        
        /*
        ----------------------------------------------
        (3 mark)
        Create an HttpServer instance.
        - HttpServer.create() creates a server bound to the specified address and port.
        - new InetSocketAddress() creates an address on port 8000 and any available IP address (0.0.0.0).
        - 0 is the backlog, representing the maximum number of queued incoming connections.  0 uses a system default.
        -----------------------------------------------
        */
        try {
            HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
        

        /*
        ----------------------------------------------
        (3 mark)
        Create a context for the "/hello" path.
        - server.createContext() associates a URL path with an HttpHandler.
        - "/hello" is the path that will trigger this handler.
        - new MyHandler() creates an instance of our custom handler (defined below).
        -----------------------------------------------
        */
        server.createContext("/hello", new MyHandler());
        
        /*
        ----------------------------------------------
        (1 mark)
        Sets executor to the default value.
        If the executor is null, a default implementation is used.
        -----------------------------------------------  
        */
        server.setExecutor(null);
             
        /*
        ----------------------------------------------
        (1 mark)
        Start the server.  This begins listening for incoming HTTP requests.
        -----------------------------------------------
        */
        server.start();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
        
        /*
        ----------------------------------------------
        (1 mark)
        Print information to the console to inform the server's status like "Server is up and running!".
        -----------------------------------------------
        */
        System.out.println("Server is up and running!");
           
    /*
    ----------------------------------------------
    (2 mark)
    Define a static inner class named MyHandler that implements the HttpHandler interface.
    Please do not use public keyword. This class must be implemented outside of the main method
    ----------------------------------------------- 
    */
    static class MyHandler implements HttpHandler {
    
        /*
        ----------------------------------------------
        (2 marks)
        Override the handle() method.  This method is called for each incoming request to the associated path.
        - HttpExchange exchange provides access to the request and response objects.
        -----------------------------------------------
        */
        @Override
        public void handle(HttpExchange exchange) throws IOException {

/*
            ----------------------------------------------
            (2 marks)
            Gets request method from client by invoking getRequestMethod and store it inside a string variable called requestMethod
            -----------------------------------------------
            */
            String method = exchange.getRequestMethod();
            String path = exchange.getRequestURI().getPath();


            /*
            ----------------------------------------------
            (2 marks)
            Checks if request method equals GET methods 
            -----------------------------------------------
            */
            if (!"/hello".equals(path)) {
                sendResponse(exchange, "Not Found", 404);
                return;
            }

                /*
                ----------------------------------------------
                (2 marks)
                Get the request URI of the request by invoking getRequestURI and store it inside an object of the URI named requestURI.
                -----------------------------------------------
                */
                
                


                /*
                ----------------------------------------------
                (2 mark)
                Print the requestURI to the console. 
                -----------------------------------------------        
                */
                
                


                /*
                ----------------------------------------------
                (2 mark)
                provide the response message like "Hello" plus requestURI and store them inside a string variable named response.
                -----------------------------------------------
                */
                
                


                /*
                ----------------------------------------------
                (3 marks)
                Set the response headers by invoking sendResponseHeaders method using exchange object and pass the following arguments:
                - 200 is the HTTP status code for OK.
                - converts the response to bytes and get the length of the response.
                -----------------------------------------------
                */
                String response = "This is a POST request to /hello";
                sendResponse(exchange, response, 200);
            }
                
                /*
                ----------------------------------------------
                (2 mark)
                Get the response body by invoking getResponseBody method and store it inside the object of OutputStream named os. 
                -----------------------------------------------
                */
                
                


                /*
                ----------------------------------------------
                (2 mark)
                Write the response string to the OutputStream and convert it to bytes.
                -----------------------------------------------
                */
                
                


                /*
                ----------------------------------------------
                (1 mark)
                Close the OutputStream.  This is essential to send the response to the client.
                -----------------------------------------------
                */
                
                


            /*
            ----------------------------------------------
            (1 mark)
            else
            -----------------------------------------------
            */
            else {
                sendResponse(exchange, "Method not supported", 400);
            }
        }


                /*
                ----------------------------------------------
                (1 mark)
                create a message like "method not allowed" and store it in a string variable named response
                -----------------------------------------------
                */
                
                


                /*
                ----------------------------------------------
                (2 marks)
                Sets response header by invoking sendResponseHeaders using the HttpExchange and pass the arguments (405 and the length of the response by converting it to bytes).
                -----------------------------------------------                
                */
                exchange.sendResponseHeaders(statusCode, response.getBytes().length);

                /*
                ----------------------------------------------
                (2 marks)
                Get the response body using exchange object and store it inside OutputStream object named os to write the response data.
                -----------------------------------------------
                */
                
               

                
                /*
                ----------------------------------------------
                (2 mark) 
                Write the response string to the OutputStream to be returned to the client and convert it to bytes.
                -----------------------------------------------
                */
                
               

                
                /*           
                ----------------------------------------------
                (1 mark)
                Close the OutputStream to send the response to the client.
                -----------------------------------------------
                */
                try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes());
            }
        }
    }
}
