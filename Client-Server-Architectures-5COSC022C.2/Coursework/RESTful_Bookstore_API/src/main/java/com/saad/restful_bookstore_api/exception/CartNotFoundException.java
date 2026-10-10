package com.saad.restful_bookstore_api.exception;

/**
 * @author saadm
 */
public class CartNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    
    public CartNotFoundException(String message) {
        super(message);
    }
}