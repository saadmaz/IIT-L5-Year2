/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.repository;

/**
 *
 * @author saadm
 */

import com.saad.restful_bookstore_api.exception.CartNotFoundException;
import com.saad.restful_bookstore_api.exception.CustomerNotFoundException;
import com.saad.restful_bookstore_api.model.Cart;
import com.saad.restful_bookstore_api.model.CartItem;

import java.util.HashMap;
import java.util.Map;

public class CartRepository {
    private static Map<Long, Cart> carts = new HashMap<>();
    
    public Cart getCartByCustomerId(Long customerId) {
        if (!carts.containsKey(customerId)) {
            throw new CartNotFoundException("Cart for customer with ID " + customerId + " does not exist.");
        }
        return carts.get(customerId);
    }
    
    public Cart createCart(Long customerId) {
        Cart cart = new Cart(customerId);
        carts.put(customerId, cart);
        return cart;
    }
    
    public Cart addItemToCart(Long customerId, CartItem item) {
        Cart cart = carts.get(customerId);
        if (cart == null) {
            cart = createCart(customerId);
        }
        
        // Check if item already exists in cart
        boolean itemFound = false;
        for (CartItem cartItem : cart.getItems()) {
            if (cartItem.getBookId().equals(item.getBookId())) {
                cartItem.setQuantity(cartItem.getQuantity() + item.getQuantity());
                itemFound = true;
                break;
            }
        }
        
        if (!itemFound) {
            cart.getItems().add(item);
        }
        
        carts.put(customerId, cart);
        return cart;
    }
    
    public Cart updateCartItem(Long customerId, Long bookId, int quantity) {
        Cart cart = getCartByCustomerId(customerId);
        
        boolean itemFound = false;
        for (CartItem cartItem : cart.getItems()) {
            if (cartItem.getBookId().equals(bookId)) {
                cartItem.setQuantity(quantity);
                itemFound = true;
                break;
            }
        }
        
        if (!itemFound) {
            throw new CartNotFoundException("Book with ID " + bookId + " not found in cart.");
        }
        
        carts.put(customerId, cart);
        return cart;
    }
    
    public Cart removeItemFromCart(Long customerId, Long bookId) {
        Cart cart = getCartByCustomerId(customerId);
        
        boolean itemRemoved = cart.getItems().removeIf(item -> item.getBookId().equals(bookId));
        
        if (!itemRemoved) {
            throw new CartNotFoundException("Book with ID " + bookId + " not found in cart.");
        }
        
        carts.put(customerId, cart);
        return cart;
    }
    
    public void clearCart(Long customerId) {
        Cart cart = getCartByCustomerId(customerId);
        cart.getItems().clear();
        carts.put(customerId, cart);
    }
}