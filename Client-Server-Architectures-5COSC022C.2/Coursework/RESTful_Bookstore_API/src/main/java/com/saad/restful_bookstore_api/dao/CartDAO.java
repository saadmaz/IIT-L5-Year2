package com.saad.restful_bookstore_api.dao;

import com.saad.restful_bookstore_api.exception.CartNotFoundException;
import com.saad.restful_bookstore_api.model.Cart;
import com.saad.restful_bookstore_api.model.CartItem;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory storage for carts, one per customer, keyed by customer ID.
 *
 * @author saadm
 */
public class CartDAO {
    private static final Map<Long, Cart> carts = new ConcurrentHashMap<>();

    public Cart getCartByCustomerId(Long customerId) {
        Cart cart = carts.get(customerId);
        if (cart == null) {
            throw new CartNotFoundException("Cart for customer with ID " + customerId + " does not exist.");
        }
        return cart;
    }

    /** @return how many of this book are already in the customer's cart (0 if none or no cart) */
    public int getQuantityInCart(Long customerId, Long bookId) {
        Cart cart = carts.get(customerId);
        if (cart == null) {
            return 0;
        }
        return cart.getItems().stream()
                .filter(item -> item.getBookId().equals(bookId))
                .mapToInt(CartItem::getQuantity)
                .sum();
    }

    /** Adds the item, or increases its quantity if the book is already in the cart. Creates the cart if needed. */
    public Cart addItemToCart(Long customerId, CartItem item) {
        Cart cart = carts.computeIfAbsent(customerId, Cart::new);
        for (CartItem cartItem : cart.getItems()) {
            if (cartItem.getBookId().equals(item.getBookId())) {
                cartItem.setQuantity(cartItem.getQuantity() + item.getQuantity());
                return cart;
            }
        }
        cart.getItems().add(item);
        return cart;
    }

    public Cart updateCartItem(Long customerId, Long bookId, int quantity) {
        Cart cart = getCartByCustomerId(customerId);
        for (CartItem cartItem : cart.getItems()) {
            if (cartItem.getBookId().equals(bookId)) {
                cartItem.setQuantity(quantity);
                return cart;
            }
        }
        throw new CartNotFoundException("Book with ID " + bookId + " is not in the cart.");
    }

    public Cart removeItemFromCart(Long customerId, Long bookId) {
        Cart cart = getCartByCustomerId(customerId);
        if (!cart.getItems().removeIf(item -> item.getBookId().equals(bookId))) {
            throw new CartNotFoundException("Book with ID " + bookId + " is not in the cart.");
        }
        return cart;
    }

    public void clearCart(Long customerId) {
        getCartByCustomerId(customerId).getItems().clear();
    }

    public void deleteCart(Long customerId) {
        carts.remove(customerId);
    }
}
