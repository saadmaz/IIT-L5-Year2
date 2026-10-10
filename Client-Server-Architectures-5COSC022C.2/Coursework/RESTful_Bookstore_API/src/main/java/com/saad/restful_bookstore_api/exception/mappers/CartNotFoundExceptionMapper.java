package com.saad.restful_bookstore_api.exception.mappers;

import com.saad.restful_bookstore_api.exception.CartNotFoundException;
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
public class CartNotFoundExceptionMapper implements ExceptionMapper<CartNotFoundException> {
    private static final Logger LOGGER = Logger.getLogger(CartNotFoundExceptionMapper.class.getName());

    @Override
    public Response toResponse(CartNotFoundException exception) {
        LOGGER.warning("CartNotFoundException: " + exception.getMessage());
        ErrorResponse errorResponse = new ErrorResponse("Cart Not Found", exception.getMessage());
        return Response.status(Response.Status.NOT_FOUND)
                .entity(errorResponse)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}