package com.saad.restful_bookstore_api.model;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * One line of an order. The price is copied from the book when the order is placed,
 * so later price changes do not alter past orders.
 *
 * @author saadm
 */
@XmlRootElement
public class OrderItem {
    private Long bookId;
    private Integer quantity;
    private Double price;

    public OrderItem() {
    }

    public OrderItem(Long bookId, Integer quantity, Double price) {
        this.bookId = bookId;
        this.quantity = quantity;
        this.price = price;
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

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }
}
