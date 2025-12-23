/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.resource;

/**
 *
 * @author saadm
 */

import com.saad.restful_bookstore_api.exception.AuthorNotFoundException;
import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.model.Book;
import com.saad.restful_bookstore_api.repository.AuthorRepository;
import com.saad.restful_bookstore_api.repository.BookRepository;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.util.Calendar;
import java.util.List;

@Path("/books")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class BookResource {
    private BookRepository bookRepository = new BookRepository();
    private AuthorRepository authorRepository = new AuthorRepository();
    
    @GET
    public Response getAllBooks() {
        List<Book> books = bookRepository.getAllBooks();
        return Response.ok(books).build();
    }
    
    @GET
    @Path("/{id}")
    public Response getBookById(@PathParam("id") Long id) {
        Book book = bookRepository.getBookById(id);
        return Response.ok(book).build();
    }
    
    @POST
    public Response createBook(Book book, @Context UriInfo uriInfo) {
        validateBook(book);
        
        // Check if author exists
        try {
            authorRepository.getAuthorById(book.getAuthorId());
        } catch (AuthorNotFoundException e) {
            throw e;
        }
        
        Book createdBook = bookRepository.addBook(book);
        URI uri = uriInfo.getAbsolutePathBuilder().path(createdBook.getId().toString()).build();
        return Response.created(uri).entity(createdBook).build();
    }
    
    @PUT
    @Path("/{id}")
    public Response updateBook(@PathParam("id") Long id, Book book) {
        validateBook(book);
        
        // Check if author exists
        try {
            authorRepository.getAuthorById(book.getAuthorId());
        } catch (AuthorNotFoundException e) {
            throw e;
        }
        
        Book updatedBook = bookRepository.updateBook(id, book);
        return Response.ok(updatedBook).build();
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteBook(@PathParam("id") Long id) {
        bookRepository.deleteBook(id);
        return Response.noContent().build();
    }
    
    private void validateBook(Book book) {
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            throw new InvalidInputException("Book title cannot be empty.");
        }
        
        if (book.getAuthorId() == null) {
            throw new InvalidInputException("Author ID cannot be null.");
        }
        
        if (book.getIsbn() == null || book.getIsbn().trim().isEmpty()) {
            throw new InvalidInputException("ISBN cannot be empty.");
        }
        
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        if (book.getPublicationYear() > currentYear) {
            throw new InvalidInputException("Publication year cannot be in the future.");
        }
        
        if (book.getPrice() <= 0) {
            throw new InvalidInputException("Price must be greater than zero.");
        }
        
        if (book.getStock() < 0) {
            throw new InvalidInputException("Stock cannot be negative.");
        }
    }
}