package com.saad.restful_bookstore_api.model;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author saadm
 */
@XmlRootElement
public class ErrorResponse {
    private String error;
    private String message;
    
    public ErrorResponse() {
    }
    
    public ErrorResponse(String error, String message) {
        this.error = error;
        this.message = message;
    }
    
    // Getters and setters
    public String getError() {
        return error;
    }
    
    public void setError(String error) {
        this.error = error;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
}
