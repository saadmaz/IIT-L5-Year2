package com.saad.restful_bookstore_api.model;

import javax.xml.bind.annotation.XmlRootElement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * A completed purchase created from a customer's cart.
 *
 * @author saadm
 */
@XmlRootElement
public class Order {
    public static final String PLACED = "PLACED";
    public static final List<String> STATUSES = Arrays.asList(PLACED, "PROCESSING", "SHIPPED", "DELIVERED");

    private Long id;
    private Long customerId;
    private Date orderDate;
    private Double totalAmount;
    private String status;
    private List<OrderItem> items;

    public Order() {
        this.items = new ArrayList<>();
        this.orderDate = new Date();
        this.status = PLACED;
    }

    public Order(Long id, Long customerId) {
        this();
        this.id = id;
        this.customerId = customerId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
}
