package com.saad.restful_bookstore_api.exception.mappers;

import com.saad.restful_bookstore_api.exception.InvalidInputException;
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
public class InvalidInputExceptionMapper implements ExceptionMapper<InvalidInputException> {
    private static final Logger LOGGER = Logger.getLogger(InvalidInputExceptionMapper.class.getName());

    @Override
    public Response toResponse(InvalidInputException exception) {
        LOGGER.warning("InvalidInputException: " + exception.getMessage());
        ErrorResponse errorResponse = new ErrorResponse("Invalid Input", exception.getMessage());
        return Response.status(Response.Status.BAD_REQUEST)
                .entity(errorResponse)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}