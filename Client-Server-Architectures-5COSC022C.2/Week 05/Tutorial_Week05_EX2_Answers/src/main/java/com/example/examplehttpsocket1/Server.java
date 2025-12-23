/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.examplehttpsocket1;

/* Please import necessary classes for input and output operations */
import java.io.*;

/* Please import necessary classes for networking operations */
import java.net.*;

/* Please import necessary classes for data structures like Map and Set */
import java.util.*;

public class Server {

    /* Please create a ServerSocket to listen for incoming client connections */
    private ServerSocket serverSocket;

    /* Please create a Map to store client usernames and their corresponding PrintWriter objects */
    private Map<String, PrintWriter> clients = new HashMap<>();

    /* Please create a Set to store unique usernames of connected clients */
    private Set<String> usernames = new HashSet<>();

    public Server(int port) {
        try {
            /* Please create a ServerSocket to listen on the specified port */
            serverSocket = new ServerSocket(port);

            /* Please print a message to indicate the server has started */
            System.out.println("Server started on port " + port);

            while (true) {
                /* Please accept incoming client connections */
                Socket clientSocket = serverSocket.accept();

                /* Please create and start a new thread to handle the client */
                new ClientHandler(clientSocket).start();
            }
        } catch (IOException e) {
            /* Please print stack trace in case of an IOException */
            e.printStackTrace();
        }
    }

    private void broadcast(String message, String sender) {
        for (PrintWriter client : clients.values()) {
            client.println(sender + ": " + message);
        }
    }

    private void sendPrivateMessage(String message, String sender, String recipient) {
        if (clients.containsKey(recipient)) {

            clients.get(recipient).println(sender + " (private): " + message);
        } else {

            clients.get(sender).println("User " + recipient + " not found.");
        }
    }

    private void updateUserList() {

        StringBuilder userList = new StringBuilder("USERLIST:");

        for (String username : usernames) {

            userList.append(username).append(",");
        }

        if (userList.length() > 9) {
            userList.deleteCharAt(userList.length() - 1);
        }

        for (PrintWriter client : clients.values()) {

            client.println(userList.toString());
        }
    }

    private class ClientHandler extends Thread {

        /* Please create a Socket for the connected client */
        private Socket clientSocket;

        /* Please create a BufferedReader to read input from the client */
        private BufferedReader in;

        /* Please create a PrintWriter to send output to the client */
        private PrintWriter out;

        /* Please create a variable to store the username of the connected client */
        private String username;

        public ClientHandler(Socket socket) {

            this.clientSocket = socket;
        }

        public void run() {
            try {
                /* Please initialize the BufferedReader to read input from the client */
                in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));

                /* Please initialize the PrintWriter to send output to the client */
                out = new PrintWriter(clientSocket.getOutputStream(), true);

                /* Please read the username from the client */
                username = in.readLine();

                /* Please check if the username is invalid or already taken */
                if (username == null || username.isEmpty() || usernames.contains(username)) {
                    /* Please send an error message if the username is invalid */
                    out.println("Invalid username. Please choose a different one.");

                    /* Please close the client socket */
                    clientSocket.close();
                    return;
                }

                usernames.add(username);

                clients.put(username, out);

                updateUserList();

                broadcast(username + " has joined the chat.", "Server");

                String message;
                while ((message = in.readLine()) != null) {
                    if (message.equals("EXIT")) {
                        /* Please exit the loop if the client sends "EXIT" */
                        break;
                    } else if (message.startsWith("PRIVATE:")) {
                        /* Please split the message to get the recipient and the private message */
                        String[] parts = message.substring("PRIVATE:".length()).split(":", 2);
                        String recipient = parts[0];
                        String privateMessage = parts[1];

                        /* Please send a private message */
                        sendPrivateMessage(privateMessage, username, recipient);
                    } else {
                        /* Please broadcast the message to all clients */
                        broadcast(message, username);
                    }
                }

                usernames.remove(username);

                clients.remove(username);

                updateUserList();

                /* Please broadcast a message that the user has left */
                broadcast(username + " has left the chat.", "Server");

                /* Please close the client socket */
                clientSocket.close();

            } catch (IOException e) {

                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {

        new Server(12345);
    }
}
