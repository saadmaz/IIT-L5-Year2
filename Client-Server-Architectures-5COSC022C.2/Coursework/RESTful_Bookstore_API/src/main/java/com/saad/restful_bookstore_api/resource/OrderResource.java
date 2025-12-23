/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.resource;

/**
 *
 * @author saadm
 */

import com.saad.restful_bookstore_api.exception.CartNotFoundException;
import com.saad.restful_bookstore_api.exception.CustomerNotFoundException;
import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.exception.OutOfStockException;
import com.saad.restful_bookstore_api.model.*;
import com.saad.restful_bookstore_api.repository.BookRepository;
import com.saad.restful_bookstore_api.repository.CartRepository;
import com.saad.restful_bookstore_api.repository.CustomerRepository;
import com.saad.restful_bookstore_api.repository.OrderRepository;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Path("/customers/{customerId}/orders")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class OrderResource {
    private OrderRepository orderRepository = new OrderRepository();
    private CustomerRepository customerRepository = new CustomerRepository();
    private CartRepository cartRepository = new CartRepository();
    private BookRepository bookRepository = new BookRepository();
    
    @GET
    public Response getCustomerOrders(@PathParam("customerId") Long customerId) {
        // Verify customer exists
        customerRepository.getCustomerById(customerId);
        
        List<Order> orders = orderRepository.getOrdersByCustomerId(customerId);
        return Response.ok(orders).build();
    }
    
    @GET
    @Path("/{orderId}")
    public Response getOrderById(
            @PathParam("customerId") Long customerId,
            @PathParam("orderId") Long orderId) {
        
        // Verify customer exists
        customerRepository.getCustomerById(customerId);
        
        Order order = orderRepository.getOrderByIdAndCustomerId(orderId, customerId);
        if (order == null) {
            throw new CustomerNotFoundException("Order with ID " + orderId + " not found for customer " + customerId);
        }
        
        return Response.ok(order).build();
    }
    
    @POST
    public Response createOrder(
            @PathParam("customerId") Long customerId,
            @Context UriInfo uriInfo) {
        
        // Verify customer exists
        Customer customer = customerRepository.getCustomerById(customerId);
        
        // Get customer's cart
        Cart cart;
        try {
            cart = cartRepository.getCartByCustomerId(customerId);
        } catch (CartNotFoundException e) {
            throw new InvalidInputException("Cannot create order with empty cart.");
        }
        
        if (cart.getItems().isEmpty()) {
            throw new InvalidInputException("Cannot create order with empty cart.");
        }
        
        // Create new order
        Order order = new Order();
        order.setCustomerId(customerId);
        order.setOrderDate(new Date());
        
        double totalAmount = 0;
        List<OrderItem> orderItems = new ArrayList<>();
        
        // Process each cart item
        for (CartItem cartItem : cart.getItems()) {
            Book book = bookRepository.getBookById(cartItem.getBookId());
            
            // Check stock
            if (book.getStock() < cartItem.getQuantity()) {
                throw new OutOfStockException("Not enough stock for book: " + book.getTitle() + 
                        ". Available: " + book.getStock());
            }
            
            // Update stock
            bookRepository.updateStock(book.getId(), cartItem.getQuantity());
            
            // Create order item
            OrderItem orderItem = new OrderItem(book.getId(), cartItem.getQuantity(), book.getPrice());
            orderItems.add(orderItem);
            
            // Add to total
            totalAmount += (book.getPrice() * cartItem.getQuantity());
        }
        
        order.setItems(orderItems);
        order.setTotalAmount(totalAmount);
        
        // Save order
        Order createdOrder = orderRepository.createOrder(order);
        
        // Clear cart
        cartRepository.clearCart(customerId);
        
        URI uri = uriInfo.getAbsolutePathBuilder().path(createdOrder.getId().toString()).build();
        return Response.created(uri).entity(createdOrder).build();
    }
}