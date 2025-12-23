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
import com.saad.restful_bookstore_api.model.Author;
import com.saad.restful_bookstore_api.model.Book;
import com.saad.restful_bookstore_api.repository.AuthorRepository;
import com.saad.restful_bookstore_api.repository.BookRepository;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.util.List;

@Path("/authors")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthorResource {
    private AuthorRepository authorRepository = new AuthorRepository();
    private BookRepository bookRepository = new BookRepository();
    
    @GET
    public Response getAllAuthors() {
        List<Author> authors = authorRepository.getAllAuthors();
        return Response.ok(authors).build();
    }
    
    @GET
    @Path("/{id}")
    public Response getAuthorById(@PathParam("id") Long id) {
        Author author = authorRepository.getAuthorById(id);
        return Response.ok(author).build();
    }
    
    @GET
    @Path("/{id}/books")
    public Response getAuthorBooks(@PathParam("id") Long id) {
        // First check if author exists
        authorRepository.getAuthorById(id);
        
        List<Book> books = bookRepository.getBooksByAuthorId(id);
        return Response.ok(books).build();
    }
    
    @POST
    public Response createAuthor(Author author, @Context UriInfo uriInfo) {
        validateAuthor(author);
        
        Author createdAuthor = authorRepository.addAuthor(author);
        URI uri = uriInfo.getAbsolutePathBuilder().path(createdAuthor.getId().toString()).build();
        return Response.created(uri).entity(createdAuthor).build();
    }
    
    @PUT
    @Path("/{id}")
    public Response updateAuthor(@PathParam("id") Long id, Author author) {
        validateAuthor(author);
        
        Author updatedAuthor = authorRepository.updateAuthor(id, author);
        return Response.ok(updatedAuthor).build();
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteAuthor(@PathParam("id") Long id) {
        // First check if author has books
        List<Book> books = bookRepository.getBooksByAuthorId(id);
        if (!books.isEmpty()) {
            throw new InvalidInputException("Cannot delete author with books. Remove books first.");
        }
        
        authorRepository.deleteAuthor(id);
        return Response.noContent().build();
    }
    
    private void validateAuthor(Author author) {
        if (author.getName() == null || author.getName().trim().isEmpty()) {
            throw new InvalidInputException("Author name cannot be empty.");
        }
    }
}