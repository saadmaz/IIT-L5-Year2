/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.repository;

/**
 *
 * @author saadm
 */

import com.saad.restful_bookstore_api.exception.CustomerNotFoundException;
import com.saad.restful_bookstore_api.model.Order;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

public class OrderRepository {
    private static Map<Long, Order> orders = new HashMap<>();
    private static AtomicLong idCounter = new AtomicLong(1);
    
    public List<Order> getAllOrders() {
        return new ArrayList<>(orders.values());
    }
    
    public List<Order> getOrdersByCustomerId(Long customerId) {
        return orders.values().stream()
                .filter(order -> order.getCustomerId().equals(customerId))
                .collect(Collectors.toList());
    }
    
    public Order getOrderById(Long id) {
        return orders.get(id);
    }
    
    public Order getOrderByIdAndCustomerId(Long id, Long customerId) {
        Order order = orders.get(id);
        if (order == null || !order.getCustomerId().equals(customerId)) {
            return null;
        }
        return order;
    }
    
    public Order createOrder(Order order) {
        order.setId(idCounter.getAndIncrement());
        orders.put(order.getId(), order);
        return order;
    }
}