package com.saad.restful_bookstore_api.exception.mappers;

import com.saad.restful_bookstore_api.exception.BookNotFoundException;
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
public class BookNotFoundExceptionMapper implements ExceptionMapper<BookNotFoundException> {
    private static final Logger LOGGER = Logger.getLogger(BookNotFoundExceptionMapper.class.getName());

    @Override
    public Response toResponse(BookNotFoundException exception) {
        LOGGER.warning("BookNotFoundException: " + exception.getMessage());
        ErrorResponse errorResponse = new ErrorResponse("Book Not Found", exception.getMessage());
        return Response.status(Response.Status.NOT_FOUND)
                .entity(errorResponse)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}