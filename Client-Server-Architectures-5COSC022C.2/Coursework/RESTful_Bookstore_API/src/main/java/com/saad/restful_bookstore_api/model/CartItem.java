/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.model;

/**
 *
 * @author saadm
 */

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class CartItem {
    private Long bookId;
    private int quantity;
    
    public CartItem() {
    }
    
    public CartItem(Long bookId, int quantity) {
        this.bookId = bookId;
        this.quantity = quantity;
    }
    
    // Getters and setters
    public Long getBookId() {
        return bookId;
    }
    
    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}