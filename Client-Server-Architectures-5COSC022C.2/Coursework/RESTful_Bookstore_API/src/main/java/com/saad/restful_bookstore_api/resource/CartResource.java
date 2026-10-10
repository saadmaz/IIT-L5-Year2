package com.saad.restful_bookstore_api.resource;

import com.saad.restful_bookstore_api.dao.BookDAO;
import com.saad.restful_bookstore_api.dao.CartDAO;
import com.saad.restful_bookstore_api.dao.CustomerDAO;
import com.saad.restful_bookstore_api.exception.CartNotFoundException;
import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.exception.OutOfStockException;
import com.saad.restful_bookstore_api.model.Book;
import com.saad.restful_bookstore_api.model.Cart;
import com.saad.restful_bookstore_api.model.CartItem;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.util.logging.Logger;

/**
 * @author saadm
 */
@Path("/customers/{customerId}/cart")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CartResource {
    private static final Logger LOGGER = Logger.getLogger(CartResource.class.getName());

    private final CartDAO cartDAO = new CartDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final BookDAO bookDAO = new BookDAO();

    @GET
    public Response getCart(@PathParam("customerId") Long customerId) {
        customerDAO.getCustomerById(customerId);
        Cart cart = cartDAO.getCartByCustomerId(customerId);
        if (cart.getItems().isEmpty()) {
            throw new CartNotFoundException("Cart for customer with ID " + customerId + " is empty.");
        }
        LOGGER.info("GET /customers/" + customerId + "/cart - " + cart.getItems().size() + " items");
        return Response.ok(cart).build();
    }

    @POST
    @Path("/items")
    public Response addItemToCart(@PathParam("customerId") Long customerId, CartItem item, @Context UriInfo uriInfo) {
        if (item == null || item.getBookId() == null) {
            throw new InvalidInputException("Book ID is required.");
        }
        validateQuantity(item.getQuantity());
        customerDAO.getCustomerById(customerId);
        Book book = bookDAO.getBookById(item.getBookId());

        // Count what is already in the cart, so repeated adds cannot exceed the stock
        int totalWanted = cartDAO.getQuantityInCart(customerId, book.getId()) + item.getQuantity();
        checkStock(book, totalWanted);

        Cart cart = cartDAO.addItemToCart(customerId, item);
        LOGGER.info("POST /customers/" + customerId + "/cart/items - added " + item.getQuantity() + " x book " + book.getId());
        URI cartUri = uriInfo.getBaseUriBuilder().path("customers").path(customerId.toString()).path("cart").build();
        return Response.created(cartUri).entity(cart).build();
    }

    @PUT
    @Path("/items/{bookId}")
    public Response updateCartItem(@PathParam("customerId") Long customerId,
                                   @PathParam("bookId") Long bookId,
                                   CartItem item) {
        if (item == null) {
            throw new InvalidInputException("Request body is required.");
        }
        validateQuantity(item.getQuantity());
        customerDAO.getCustomerById(customerId);
        Book book = bookDAO.getBookById(bookId);
        checkStock(book, item.getQuantity());

        Cart cart = cartDAO.updateCartItem(customerId, bookId, item.getQuantity());
        LOGGER.info("PUT /customers/" + customerId + "/cart/items/" + bookId + " - quantity now " + item.getQuantity());
        return Response.ok(cart).build();
    }

    @DELETE
    @Path("/items/{bookId}")
    public Response removeItemFromCart(@PathParam("customerId") Long customerId,
                                       @PathParam("bookId") Long bookId) {
        customerDAO.getCustomerById(customerId);
        cartDAO.removeItemFromCart(customerId, bookId);
        LOGGER.info("DELETE /customers/" + customerId + "/cart/items/" + bookId + " - removed");
        return Response.noContent().build();
    }

    private void validateQuantity(Integer quantity) {
        if (quantity == null || quantity <= 0) {
            throw new InvalidInputException("Quantity is required and must be greater than zero.");
        }
    }

    private void checkStock(Book book, int quantity) {
        if (quantity > book.getStock()) {
            throw new OutOfStockException("Not enough stock for '" + book.getTitle() + "'. Requested: "
                    + quantity + ", available: " + book.getStock() + ".");
        }
    }
}
