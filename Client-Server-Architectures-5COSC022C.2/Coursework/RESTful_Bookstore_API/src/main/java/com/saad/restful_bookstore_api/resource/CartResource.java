/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.resource;

/**
 *
 * @author saadm
 */

import com.saad.restful_bookstore_api.exception.BookNotFoundException;
import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.exception.OutOfStockException;
import com.saad.restful_bookstore_api.model.Book;
import com.saad.restful_bookstore_api.model.Cart;
import com.saad.restful_bookstore_api.model.CartItem;
import com.saad.restful_bookstore_api.repository.BookRepository;
import com.saad.restful_bookstore_api.repository.CartRepository;
import com.saad.restful_bookstore_api.repository.CustomerRepository;

import javax.ws.rs.*;
import javax.ws.rs.core.*;

@Path("/customers/{customerId}/cart")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CartResource {
    private CartRepository cartRepository = new CartRepository();
    private CustomerRepository customerRepository = new CustomerRepository();
    private BookRepository bookRepository = new BookRepository();
    
    @GET
    public Response getCart(@PathParam("customerId") Long customerId) {
        // Verify customer exists
        customerRepository.getCustomerById(customerId);
        
        Cart cart;
        try {
            cart = cartRepository.getCartByCustomerId(customerId);
        } catch (Exception e) {
            // If cart doesn't exist, create a new one
            cart = cartRepository.createCart(customerId);
        }
        
        return Response.ok(cart).build();
    }
    
    @POST
    @Path("/items")
    public Response addItemToCart(@PathParam("customerId") Long customerId, CartItem item) {
        // Verify customer exists
        customerRepository.getCustomerById(customerId);
        
        // Verify book exists
        Book book = bookRepository.getBookById(item.getBookId());
        
        // Validate quantity
        if (item.getQuantity() <= 0) {
            throw new InvalidInputException("Quantity must be greater than zero.");
        }
        
        // Check stock
        if (book.getStock() < item.getQuantity()) {
            throw new OutOfStockException("Not enough stock. Available: " + book.getStock());
        }
        
        Cart updatedCart = cartRepository.addItemToCart(customerId, item);
        return Response.ok(updatedCart).build();
    }
    
    @PUT
    @Path("/items/{bookId}")
    public Response updateCartItem(
            @PathParam("customerId") Long customerId,
            @PathParam("bookId") Long bookId,
            CartItem item) {
        
        // Verify customer exists
        customerRepository.getCustomerById(customerId);
        
        // Verify book exists
        Book book = bookRepository.getBookById(bookId);
        
        // Validate quantity
        if (item.getQuantity() <= 0) {
            throw new InvalidInputException("Quantity must be greater than zero.");
        }
        
        // Check stock
        if (book.getStock() < item.getQuantity()) {
            throw new OutOfStockException("Not enough stock. Available: " + book.getStock());
        }
        
        Cart updatedCart = cartRepository.updateCartItem(customerId, bookId, item.getQuantity());
        return Response.ok(updatedCart).build();
    }
    
    @DELETE
    @Path("/items/{bookId}")
    public Response removeItemFromCart(
            @PathParam("customerId") Long customerId,
            @PathParam("bookId") Long bookId) {
        
        // Verify customer exists
        customerRepository.getCustomerById(customerId);
        
        // Verify book exists
        bookRepository.getBookById(bookId);
        
        Cart updatedCart = cartRepository.removeItemFromCart(customerId, bookId);
        return Response.ok(updatedCart).build();
    }
}