package com.saad.restful_bookstore_api.dao;

import com.saad.restful_bookstore_api.exception.CustomerNotFoundException;
import com.saad.restful_bookstore_api.model.Customer;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * In-memory storage for customers. Lookups of a missing ID throw CustomerNotFoundException.
 *
 * @author saadm
 */
public class CustomerDAO {
    private static final Map<Long, Customer> customers = new ConcurrentHashMap<>();
    private static final AtomicLong idCounter = new AtomicLong(1);

    static {
        Customer customer1 = new Customer(idCounter.getAndIncrement(), "John Doe", "john@example.com", "password123");
        Customer customer2 = new Customer(idCounter.getAndIncrement(), "Jane Smith", "jane@example.com", "password456");
        customers.put(customer1.getId(), customer1);
        customers.put(customer2.getId(), customer2);
    }

    public List<Customer> getAllCustomers() {
        return new ArrayList<>(customers.values());
    }

    public Customer getCustomerById(Long id) {
        Customer customer = customers.get(id);
        if (customer == null) {
            throw new CustomerNotFoundException("Customer with ID " + id + " does not exist.");
        }
        return customer;
    }

    public Customer addCustomer(Customer customer) {
        customer.setId(idCounter.getAndIncrement());
        customers.put(customer.getId(), customer);
        return customer;
    }

    public Customer updateCustomer(Long id, Customer customer) {
        getCustomerById(id);
        customer.setId(id);
        customers.put(id, customer);
        return customer;
    }

    /** @return the deleted customer */
    public Customer deleteCustomer(Long id) {
        Customer customer = getCustomerById(id);
        customers.remove(id);
        return customer;
    }
}
