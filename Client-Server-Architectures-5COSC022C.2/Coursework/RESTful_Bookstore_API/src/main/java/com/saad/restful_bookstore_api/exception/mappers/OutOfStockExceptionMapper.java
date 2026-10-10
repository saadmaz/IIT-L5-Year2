package com.saad.restful_bookstore_api.exception.mappers;

import com.saad.restful_bookstore_api.exception.OutOfStockException;
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
public class OutOfStockExceptionMapper implements ExceptionMapper<OutOfStockException> {
    private static final Logger LOGGER = Logger.getLogger(OutOfStockExceptionMapper.class.getName());

    @Override
    public Response toResponse(OutOfStockException exception) {
        LOGGER.warning("OutOfStockException: " + exception.getMessage());
        ErrorResponse errorResponse = new ErrorResponse("Out of Stock", exception.getMessage());
        return Response.status(Response.Status.BAD_REQUEST)
                .entity(errorResponse)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}