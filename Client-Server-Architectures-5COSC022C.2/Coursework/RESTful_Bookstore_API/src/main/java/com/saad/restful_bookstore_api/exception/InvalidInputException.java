package com.saad.restful_bookstore_api.exception;

/**
 * @author saadm
 */
public class InvalidInputException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    
    public InvalidInputException(String message) {
        super(message);
    }
}