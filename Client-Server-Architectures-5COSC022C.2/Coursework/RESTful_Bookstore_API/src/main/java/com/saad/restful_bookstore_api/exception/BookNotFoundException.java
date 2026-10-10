package com.saad.restful_bookstore_api.exception;

/**
 * @author saadm
 */
public class BookNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    
    public BookNotFoundException(String message) {
        super(message);
    }
}