package com.saad.restful_bookstore_api.exception;

/**
 * Thrown when an order does not exist, or belongs to a different customer.
 *
 * @author saadm
 */
public class OrderNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public OrderNotFoundException(String message) {
        super(message);
    }
}
