package com.saad.restful_bookstore_api.exception;

/**
 * @author saadm
 */
public class CustomerNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    
    public CustomerNotFoundException(String message) {
        super(message);
    }
}