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
import com.saad.restful_bookstore_api.model.Customer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

public class CustomerRepository {
    private static Map<Long, Customer> customers = new HashMap<>();
    private static AtomicLong idCounter = new AtomicLong(1);
    
    static {
        // Initialize with some sample data
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
        if (!customers.containsKey(id)) {
            throw new CustomerNotFoundException("Customer with ID " + id + " does not exist.");
        }
        customer.setId(id);
        customers.put(id, customer);
        return customer;
    }
    
    public void deleteCustomer(Long id) {
        if (!customers.containsKey(id)) {
            throw new CustomerNotFoundException("Customer with ID " + id + " does not exist.");
        }
        customers.remove(id);
    }
}