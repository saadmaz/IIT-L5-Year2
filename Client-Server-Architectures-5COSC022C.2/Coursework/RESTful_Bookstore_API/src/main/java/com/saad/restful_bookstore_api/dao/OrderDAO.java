package com.saad.restful_bookstore_api.dao;

import com.saad.restful_bookstore_api.exception.OrderNotFoundException;
import com.saad.restful_bookstore_api.model.Order;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

/**
 * In-memory storage for orders. An order only "exists" for the customer who placed it,
 * so every lookup takes both IDs.
 *
 * @author saadm
 */
public class OrderDAO {
    private static final Map<Long, Order> orders = new ConcurrentHashMap<>();
    private static final AtomicLong idCounter = new AtomicLong(1);

    public List<Order> getOrdersByCustomerId(Long customerId) {
        return orders.values().stream()
                .filter(order -> order.getCustomerId().equals(customerId))
                .collect(Collectors.toList());
    }

    public Order getOrder(Long customerId, Long orderId) {
        Order order = orders.get(orderId);
        if (order == null || !order.getCustomerId().equals(customerId)) {
            throw new OrderNotFoundException("Order with ID " + orderId + " does not exist for customer " + customerId + ".");
        }
        return order;
    }

    public Order createOrder(Order order) {
        order.setId(idCounter.getAndIncrement());
        orders.put(order.getId(), order);
        return order;
    }

    public Order updateStatus(Long customerId, Long orderId, String status) {
        Order order = getOrder(customerId, orderId);
        order.setStatus(status);
        return order;
    }

    /** @return the deleted order */
    public Order deleteOrder(Long customerId, Long orderId) {
        Order order = getOrder(customerId, orderId);
        orders.remove(orderId);
        return order;
    }
}
