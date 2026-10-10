package com.saad.restful_bookstore_api.resource;

import com.saad.restful_bookstore_api.dao.CartDAO;
import com.saad.restful_bookstore_api.dao.CustomerDAO;
import com.saad.restful_bookstore_api.exception.CustomerNotFoundException;
import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.model.Customer;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.util.List;
import java.util.logging.Logger;
import java.util.regex.Pattern;

/**
 * @author saadm
 */
@Path("/customers")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CustomerResource {
    private static final Logger LOGGER = Logger.getLogger(CustomerResource.class.getName());
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final CartDAO cartDAO = new CartDAO();

    @GET
    public Response getAllCustomers() {
        List<Customer> customers = customerDAO.getAllCustomers();
        if (customers.isEmpty()) {
            throw new CustomerNotFoundException("No customers found.");
        }
        LOGGER.info("GET /customers - returning " + customers.size() + " customers");
        return Response.ok(customers).build();
    }

    @GET
    @Path("/{id}")
    public Response getCustomerById(@PathParam("id") Long id) {
        Customer customer = customerDAO.getCustomerById(id);
        LOGGER.info("GET /customers/" + id + " - found '" + customer.getName() + "'");
        return Response.ok(customer).build();
    }

    @POST
    public Response createCustomer(Customer customer, @Context UriInfo uriInfo) {
        validateCustomer(customer);
        Customer createdCustomer = customerDAO.addCustomer(customer);
        LOGGER.info("POST /customers - created customer " + createdCustomer.getId());
        URI uri = uriInfo.getAbsolutePathBuilder().path(createdCustomer.getId().toString()).build();
        return Response.created(uri).entity(createdCustomer).build();
    }

    @PUT
    @Path("/{id}")
    public Response updateCustomer(@PathParam("id") Long id, Customer customer) {
        validateCustomer(customer);
        Customer updatedCustomer = customerDAO.updateCustomer(id, customer);
        LOGGER.info("PUT /customers/" + id + " - updated");
        return Response.ok(updatedCustomer).build();
    }

    @DELETE
    @Path("/{id}")
    public Response deleteCustomer(@PathParam("id") Long id) {
        customerDAO.deleteCustomer(id);
        cartDAO.deleteCart(id);
        LOGGER.info("DELETE /customers/" + id + " - deleted with their cart");
        return Response.noContent().build();
    }

    private void validateCustomer(Customer customer) {
        if (customer == null) {
            throw new InvalidInputException("Request body is required.");
        }
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
