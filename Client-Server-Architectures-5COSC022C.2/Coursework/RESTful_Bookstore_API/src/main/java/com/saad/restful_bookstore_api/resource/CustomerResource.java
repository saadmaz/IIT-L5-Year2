/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.resource;

/**
 *
 * @author saadm
 */

import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.model.Customer;
import com.saad.restful_bookstore_api.repository.CustomerRepository;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.util.List;
import java.util.regex.Pattern;

@Path("/customers")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CustomerResource {
    private CustomerRepository customerRepository = new CustomerRepository();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    
    @GET
    public Response getAllCustomers() {
        List<Customer> customers = customerRepository.getAllCustomers();
        return Response.ok(customers).build();
    }
    
    @GET
    @Path("/{id}")
    public Response getCustomerById(@PathParam("id") Long id) {
        Customer customer = customerRepository.getCustomerById(id);
        return Response.ok(customer).build();
    }
    
    @POST
    public Response createCustomer(Customer customer, @Context UriInfo uriInfo) {
        validateCustomer(customer);
        
        Customer createdCustomer = customerRepository.addCustomer(customer);
        URI uri = uriInfo.getAbsolutePathBuilder().path(createdCustomer.getId().toString()).build();
        return Response.created(uri).entity(createdCustomer).build();
    }
    
    @PUT
    @Path("/{id}")
    public Response updateCustomer(@PathParam("id") Long id, Customer customer) {
        validateCustomer(customer);
        
        Customer updatedCustomer = customerRepository.updateCustomer(id, customer);
        return Response.ok(updatedCustomer).build();
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteCustomer(@PathParam("id") Long id) {
        customerRepository.deleteCustomer(id);
        return Response.noContent().build();
    }
    
    private void validateCustomer(Customer customer) {
        if (customer.getName() == null || customer.getName().trim().isEmpty()) {
            throw new InvalidInputException("Customer name cannot be empty.");
        }
        
        if (customer.getEmail() == null || customer.getEmail().trim().isEmpty()) {
            throw new InvalidInputException("Email cannot be empty.");
        }
        
        if (!EMAIL_PATTERN.matcher(customer.getEmail()).matches()) {
            throw new InvalidInputException("Invalid email format.");
        }
        
        if (customer.getPassword() == null || customer.getPassword().length() < 6) {
            throw new InvalidInputException("Password must be at least 6 characters long.");
        }
    }
}