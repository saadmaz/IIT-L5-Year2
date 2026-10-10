package com.saad.restful_bookstore_api.resource;

import com.saad.restful_bookstore_api.dao.AuthorDAO;
import com.saad.restful_bookstore_api.dao.BookDAO;
import com.saad.restful_bookstore_api.exception.AuthorNotFoundException;
import com.saad.restful_bookstore_api.exception.BookNotFoundException;
import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.model.Book;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.time.Year;
import java.util.List;
import java.util.logging.Logger;

/**
 * @author saadm
 */
@Path("/books")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class BookResource {
    private static final Logger LOGGER = Logger.getLogger(BookResource.class.getName());

    private final BookDAO bookDAO = new BookDAO();
    private final AuthorDAO authorDAO = new AuthorDAO();

    @GET
    public Response getAllBooks() {
        List<Book> books = bookDAO.getAllBooks();
        if (books.isEmpty()) {
            throw new BookNotFoundException("No books found.");
        }
        books.forEach(this::attachAuthor);
        LOGGER.info("GET /books - returning " + books.size() + " books");
        return Response.ok(books).build();
    }

    @GET
    @Path("/{id}")
    public Response getBookById(@PathParam("id") Long id) {
        Book book = attachAuthor(bookDAO.getBookById(id));
        LOGGER.info("GET /books/" + id + " - found '" + book.getTitle() + "'");
        return Response.ok(book).build();
    }

    @POST
    public Response createBook(Book book, @Context UriInfo uriInfo) {
        validateBook(book);
        authorDAO.getAuthorById(book.getAuthorId());

        Book createdBook = attachAuthor(bookDAO.addBook(book));
        LOGGER.info("POST /books - created book " + createdBook.getId() + " '" + createdBook.getTitle() + "'");
        URI uri = uriInfo.getAbsolutePathBuilder().path(createdBook.getId().toString()).build();
        return Response.created(uri).entity(createdBook).build();
    }

    @PUT
    @Path("/{id}")
    public Response updateBook(@PathParam("id") Long id, Book book) {
        validateBook(book);
        authorDAO.getAuthorById(book.getAuthorId());

        Book updatedBook = attachAuthor(bookDAO.updateBook(id, book));
        LOGGER.info("PUT /books/" + id + " - updated");
        return Response.ok(updatedBook).build();
    }

    @DELETE
    @Path("/{id}")
    public Response deleteBook(@PathParam("id") Long id) {
        bookDAO.deleteBook(id);
        LOGGER.info("DELETE /books/" + id + " - deleted");
        return Response.noContent().build();
    }

    /** Adds the full author details to a book before it is returned. */
    private Book attachAuthor(Book book) {
        try {
            book.setAuthor(authorDAO.getAuthorById(book.getAuthorId()));
        } catch (AuthorNotFoundException e) {
            book.setAuthor(null);
        }
        return book;
    }

    private void validateBook(Book book) {
        if (book == null) {
            throw new InvalidInputException("Request body is required.");
        }
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            throw new InvalidInputException("Book title cannot be empty.");
        }
        if (book.getAuthorId() == null) {
            throw new InvalidInputException("Author ID is required.");
        }
        if (book.getIsbn() == null || book.getIsbn().trim().isEmpty()) {
            throw new InvalidInputException("ISBN cannot be empty.");
        }
        if (book.getPublicationYear() == null) {
            throw new InvalidInputException("Publication year is required.");
        }
        if (book.getPublicationYear() <= 0) {
            throw new InvalidInputException("Publication year must be a positive number.");
        }
        if (book.getPublicationYear() > Year.now().getValue()) {
            throw new InvalidInputException("Publication year cannot be in the future.");
        }
        if (book.getPrice() == null || book.getPrice() <= 0) {
            throw new InvalidInputException("Price is required and must be greater than zero.");
        }
        if (book.getStock() == null || book.getStock() < 0) {
            throw new InvalidInputException("Stock is required and cannot be negative.");
        }
    }
}
