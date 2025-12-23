/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.exception;

/**
 *
 * @author saadm
 */

public class AuthorNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    
    public AuthorNotFoundException(String message) {
        super(message);
    }
}