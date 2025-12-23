/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.tutorial.week03.socket1;

/** Import the BufferedReader class, which reads text from a character-input stream, 
 * buffering characters so as to provide for the efficient reading of characters, arrays, and lines.** */


/* **Import the IOException class, which is thrown when an input-output operation is failed or interrupted** */


/* **Import the InputStreamReader class, which is a bridge from byte streams to 
character streams. It reads bytes and decodes them into characters using a specified charset.** */


/* **Import the PrintWriter class, which prints formatted representations of objects to a text-output stream.** */


/* **Import the Socket class, which is used for client-side TCP operations. 
It creates a socket, connects it to a specified port number at a specified IP address.** */


/* **Define a public class named Client. This class will contain all the logic for our client program.** */


    /* **Define the main method. This is the entry point for any Java application.** */
    

        /* **Define a final string variable for the server address. 
        "localhost" is used here, which means the server is running on the same machine as the client.** */
        

        /* **Define a final integer variable for the server port. 12345 is used here. 
        The client will connect to this port on the server.** */
        

        /* **Try to establish a socket connection to the server. 
        The Socket class constructor takes two parameters: the server address and the server port. The try-with-resources statement ensures that the socket is closed when it is no longer needed.** */
        

            /* **Create a PrintWriter object for sending messages to the server. 
            The PrintWriter class constructor takes two parameters: the socket output stream and 
            a boolean indicating whether to automatically flush the output stream after every write operation.** */
            

            /* **Create a BufferedReader object for reading server responses. 
            The BufferedReader class constructor takes an InputStreamReader, which in turn takes the socket input stream.** */
            

            /* **Send a message to the server. The PrintWriter's println method is used here, 
            which sends a string followed by a newline to the server.** */
            

            /* **Read the server response and store it in a string variable. 
            The BufferedReader's readLine method is used here, which reads a line of text from the server.** */
            

            /* **Print the server response to the console. The System.out.println method is used here, 
            which prints a string followed by a newline to the console.** */
            
        /* **Catch any IOException that may occur and print the stack trace. 
            An IOException is thrown when an input-output operation is failed or interrupted.** */
        

