package com.saad.restful_bookstore_api.resource;

import com.saad.restful_bookstore_api.dao.AuthorDAO;
import com.saad.restful_bookstore_api.dao.BookDAO;
import com.saad.restful_bookstore_api.exception.AuthorNotFoundException;
import com.saad.restful_bookstore_api.exception.BookNotFoundException;
import com.saad.restful_bookstore_api.exception.InvalidInputException;
import com.saad.restful_bookstore_api.model.Author;
import com.saad.restful_bookstore_api.model.Book;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.net.URI;
import java.util.List;
import java.util.logging.Logger;

/**
 * @author saadm
 */
@Path("/authors")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthorResource {
    private static final Logger LOGGER = Logger.getLogger(AuthorResource.class.getName());

    private final AuthorDAO authorDAO = new AuthorDAO();
    private final BookDAO bookDAO = new BookDAO();

    @GET
    public Response getAllAuthors() {
        List<Author> authors = authorDAO.getAllAuthors();
        if (authors.isEmpty()) {
            throw new AuthorNotFoundException("No authors found.");
        }
        LOGGER.info("GET /authors - returning " + authors.size() + " authors");
        return Response.ok(authors).build();
    }

    @GET
    @Path("/{id}")
    public Response getAuthorById(@PathParam("id") Long id) {
        Author author = authorDAO.getAuthorById(id);
        LOGGER.info("GET /authors/" + id + " - found '" + author.getName() + "'");
        return Response.ok(author).build();
    }

    @GET
    @Path("/{id}/books")
    public Response getAuthorBooks(@PathParam("id") Long id) {
        authorDAO.getAuthorById(id);
        List<Book> books = bookDAO.getBooksByAuthorId(id);
        if (books.isEmpty()) {
            throw new BookNotFoundException("Author with ID " + id + " has no books.");
        }
        LOGGER.info("GET /authors/" + id + "/books - returning " + books.size() + " books");
        return Response.ok(books).build();
    }

    @POST
    public Response createAuthor(Author author, @Context UriInfo uriInfo) {
        validateAuthor(author);
        Author createdAuthor = authorDAO.addAuthor(author);
        LOGGER.info("POST /authors - created author " + createdAuthor.getId() + " '" + createdAuthor.getName() + "'");
        URI uri = uriInfo.getAbsolutePathBuilder().path(createdAuthor.getId().toString()).build();
        return Response.created(uri).entity(createdAuthor).build();
    }

    @PUT
    @Path("/{id}")
    public Response updateAuthor(@PathParam("id") Long id, Author author) {
        validateAuthor(author);
        Author updatedAuthor = authorDAO.updateAuthor(id, author);
        LOGGER.info("PUT /authors/" + id + " - updated");
        return Response.ok(updatedAuthor).build();
    }

    @DELETE
    @Path("/{id}")
    public Response deleteAuthor(@PathParam("id") Long id) {
        authorDAO.getAuthorById(id);
        if (!bookDAO.getBooksByAuthorId(id).isEmpty()) {
            throw new InvalidInputException("Cannot delete an author who still has books. Delete their books first.");
        }
        authorDAO.deleteAuthor(id);
        LOGGER.info("DELETE /authors/" + id + " - deleted");
        return Response.noContent().build();
    }

    private void validateAuthor(Author author) {
        if (author == null) {
            throw new InvalidInputException("Request body is required.");
        }
        if (author.getName() == null || author.getName().trim().isEmpty()) {
            throw new InvalidInputException("Author name cannot be empty.");
        }
    }
}
