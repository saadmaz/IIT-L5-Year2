package com.saad.restful_bookstore_api.resource;

import com.saad.restful_bookstore_api.dao.BookDAO;
import com.saad.restful_bookstore_api.dao.CartDAO;
import com.saad.restful_bookstore_api.dao.CustomerDAO;
import com.saad.restful_bookstore_api.dao.OrderDAO;
import com.saad.restful_bookstore_api.exception.BookNotFoundException;
import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.exception.OrderNotFoundException;
import com.saad.restful_bookstore_api.exception.OutOfStockException;
import com.saad.restful_bookstore_api.model.*;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * @author saadm
 */
@Path("/customers/{customerId}/orders")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class OrderResource {
    private static final Logger LOGGER = Logger.getLogger(OrderResource.class.getName());

    private final OrderDAO orderDAO = new OrderDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final CartDAO cartDAO = new CartDAO();
    private final BookDAO bookDAO = new BookDAO();

    @GET
    public Response getCustomerOrders(@PathParam("customerId") Long customerId) {
        customerDAO.getCustomerById(customerId);
        List<Order> orders = orderDAO.getOrdersByCustomerId(customerId);
        if (orders.isEmpty()) {
            throw new OrderNotFoundException("No orders found for customer with ID " + customerId + ".");
        }
        LOGGER.info("GET /customers/" + customerId + "/orders - returning " + orders.size() + " orders");
        return Response.ok(orders).build();
    }

    @GET
    @Path("/{orderId}")
    public Response getOrderById(@PathParam("customerId") Long customerId,
                                 @PathParam("orderId") Long orderId) {
        customerDAO.getCustomerById(customerId);
        Order order = orderDAO.getOrder(customerId, orderId);
        LOGGER.info("GET /customers/" + customerId + "/orders/" + orderId + " - found");
        return Response.ok(order).build();
    }

    @POST
    public Response createOrder(@PathParam("customerId") Long customerId, @Context UriInfo uriInfo) {
        customerDAO.getCustomerById(customerId);
        Cart cart = cartDAO.getCartByCustomerId(customerId);
        if (cart.getItems().isEmpty()) {
            throw new InvalidInputException("Cannot create an order from an empty cart.");
        }

        Order order = new Order();
        order.setCustomerId(customerId);
        double total = 0;

        // Check every item before taking any stock, so a failure part-way through changes nothing
        synchronized (BookDAO.class) {
            for (CartItem cartItem : cart.getItems()) {
                Book book = bookDAO.getBookById(cartItem.getBookId());
                if (cartItem.getQuantity() > book.getStock()) {
                    throw new OutOfStockException("Not enough stock for '" + book.getTitle() + "'. Requested: "
                            + cartItem.getQuantity() + ", available: " + book.getStock() + ".");
                }
            }
            for (CartItem cartItem : cart.getItems()) {
                Book book = bookDAO.getBookById(cartItem.getBookId());
                bookDAO.adjustStock(book.getId(), -cartItem.getQuantity());
                order.getItems().add(new OrderItem(book.getId(), cartItem.getQuantity(), book.getPrice()));
                total += book.getPrice() * cartItem.getQuantity();
            }
        }
        order.setTotalAmount(Math.round(total * 100) / 100.0);

        Order createdOrder = orderDAO.createOrder(order);
        cartDAO.clearCart(customerId);
        LOGGER.info("POST /customers/" + customerId + "/orders - created order " + createdOrder.getId()
                + " totalling " + createdOrder.getTotalAmount());
        URI uri = uriInfo.getAbsolutePathBuilder().path(createdOrder.getId().toString()).build();
        return Response.created(uri).entity(createdOrder).build();
    }

    /** Updates the order's status, e.g. {"status": "SHIPPED"}. */
    @PUT
    @Path("/{orderId}")
    public Response updateOrderStatus(@PathParam("customerId") Long customerId,
                                      @PathParam("orderId") Long orderId,
                                      Order update) {
        if (update == null || update.getStatus() == null || !Order.STATUSES.contains(update.getStatus().toUpperCase())) {
            throw new InvalidInputException("Status must be one of " + Order.STATUSES + ".");
        }
        customerDAO.getCustomerById(customerId);
        Order order = orderDAO.updateStatus(customerId, orderId, update.getStatus().toUpperCase());
        LOGGER.info("PUT /customers/" + customerId + "/orders/" + orderId + " - status now " + order.getStatus());
        return Response.ok(order).build();
    }

    /** Cancels an order that has not shipped yet and puts its books back in stock. */
    @DELETE
    @Path("/{orderId}")
    public Response cancelOrder(@PathParam("customerId") Long customerId,
                                @PathParam("orderId") Long orderId) {
        customerDAO.getCustomerById(customerId);
        Order order = orderDAO.getOrder(customerId, orderId);
        if (!Order.PLACED.equals(order.getStatus()) && !"PROCESSING".equals(order.getStatus())) {
            throw new InvalidInputException("Order " + orderId + " is already " + order.getStatus() + " and cannot be cancelled.");
        }

        List<Long> missingBooks = new ArrayList<>();
        synchronized (BookDAO.class) {
            for (OrderItem item : order.getItems()) {
                try {
                    bookDAO.adjustStock(item.getBookId(), item.getQuantity());
                } catch (BookNotFoundException e) {
                    missingBooks.add(item.getBookId()); // book was deleted since; nothing to restock
                }
            }
        }
        orderDAO.deleteOrder(customerId, orderId);
        LOGGER.info("DELETE /customers/" + customerId + "/orders/" + orderId + " - cancelled and restocked"
                + (missingBooks.isEmpty() ? "" : " (skipped deleted books " + missingBooks + ")"));
        return Response.noContent().build();
    }
}
