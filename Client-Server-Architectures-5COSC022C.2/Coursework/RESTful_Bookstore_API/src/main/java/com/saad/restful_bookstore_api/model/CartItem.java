package com.saad.restful_bookstore_api.model;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * One book and its quantity inside a customer's cart.
 *
 * @author saadm
 */
@XmlRootElement
public class CartItem {
    private Long bookId;
    private Integer quantity;

    public CartItem() {
    }

    public CartItem(Long bookId, Integer quantity) {
        this.bookId = bookId;
        this.quantity = quantity;
    }

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
