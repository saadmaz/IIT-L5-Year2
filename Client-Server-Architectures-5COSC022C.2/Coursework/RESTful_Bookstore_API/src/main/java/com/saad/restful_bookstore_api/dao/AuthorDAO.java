package com.saad.restful_bookstore_api.dao;

import com.saad.restful_bookstore_api.exception.AuthorNotFoundException;
import com.saad.restful_bookstore_api.model.Author;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * In-memory storage for authors. Lookups of a missing ID throw AuthorNotFoundException.
 *
 * @author saadm
 */
public class AuthorDAO {
    private static final Map<Long, Author> authors = new ConcurrentHashMap<>();
    private static final AtomicLong idCounter = new AtomicLong(1);

    static {
        Author author1 = new Author(idCounter.getAndIncrement(), "F. Scott Fitzgerald", "American novelist");
        Author author2 = new Author(idCounter.getAndIncrement(), "Harper Lee", "American novelist");
        authors.put(author1.getId(), author1);
        authors.put(author2.getId(), author2);
    }

    public List<Author> getAllAuthors() {
        return new ArrayList<>(authors.values());
    }

    public Author getAuthorById(Long id) {
        Author author = authors.get(id);
        if (author == null) {
            throw new AuthorNotFoundException("Author with ID " + id + " does not exist.");
        }
        return author;
    }

    public Author addAuthor(Author author) {
        author.setId(idCounter.getAndIncrement());
        authors.put(author.getId(), author);
        return author;
    }

    public Author updateAuthor(Long id, Author author) {
        getAuthorById(id);
        author.setId(id);
        authors.put(id, author);
        return author;
    }

    /** @return the deleted author */
    public Author deleteAuthor(Long id) {
        Author author = getAuthorById(id);
        authors.remove(id);
        return author;
    }
}
