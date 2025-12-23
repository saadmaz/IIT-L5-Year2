/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.repository;

/**
 *
 * @author saadm
 */

import com.saad.restful_bookstore_api.exception.AuthorNotFoundException;
import com.saad.restful_bookstore_api.model.Author;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

public class AuthorRepository {
    private static Map<Long, Author> authors = new HashMap<>();
    private static AtomicLong idCounter = new AtomicLong(1);
    
    static {
        // Initialize with some sample data
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
        if (!authors.containsKey(id)) {
            throw new AuthorNotFoundException("Author with ID " + id + " does not exist.");
        }
        author.setId(id);
        authors.put(id, author);
        return author;
    }
    
    public void deleteAuthor(Long id) {
        if (!authors.containsKey(id)) {
            throw new AuthorNotFoundException("Author with ID " + id + " does not exist.");
        }
        authors.remove(id);
    }
}