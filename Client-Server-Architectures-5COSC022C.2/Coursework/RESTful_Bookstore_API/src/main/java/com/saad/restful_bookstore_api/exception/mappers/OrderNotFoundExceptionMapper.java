package com.saad.restful_bookstore_api.exception.mappers;

import com.saad.restful_bookstore_api.exception.OrderNotFoundException;
import com.saad.restful_bookstore_api.model.ErrorResponse;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;
import java.util.logging.Logger;

/**
 * @author saadm
 */
@Provider
public class OrderNotFoundExceptionMapper implements ExceptionMapper<OrderNotFoundException> {
    private static final Logger LOGGER = Logger.getLogger(OrderNotFoundExceptionMapper.class.getName());

    @Override
    public Response toResponse(OrderNotFoundException exception) {
        LOGGER.warning("404 Order Not Found: " + exception.getMessage());
        ErrorResponse errorResponse = new ErrorResponse("Order Not Found", exception.getMessage());
        return Response.status(Response.Status.NOT_FOUND)
                .entity(errorResponse)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}
