package com.saad.restful_bookstore_api.exception;

/**
 * @author saadm
 */
public class OutOfStockException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    
    public OutOfStockException(String message) {
        super(message);
    }
}