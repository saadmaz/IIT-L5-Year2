/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.saad.restful_bookstore_api.repository;

/**
 *
 * @author saadm
 */

import com.saad.restful_bookstore_api.exception.BookNotFoundException;
import com.saad.restful_bookstore_api.model.Book;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

public class BookRepository {
    private static Map<Long, Book> books = new HashMap<>();
    private static AtomicLong idCounter = new AtomicLong(1);
    
    static {
        // Initialize with some sample data
        Book book1 = new Book(idCounter.getAndIncrement(), "The Great Gatsby", 1L, "978-3-16-148410-0", 1925, 12.99, 50);
        Book book2 = new Book(idCounter.getAndIncrement(), "To Kill a Mockingbird", 2L, "978-3-16-148410-1", 1960, 14.99, 30);
        
        books.put(book1.getId(), book1);
        books.put(book2.getId(), book2);
    }
    
    public List<Book> getAllBooks() {
        return new ArrayList<>(books.values());
    }
    
    public Book getBookById(Long id) {
        Book book = books.get(id);
        if (book == null) {
            throw new BookNotFoundException("Book with ID " + id + " does not exist.");
        }
        return book;
    }
    
    public List<Book> getBooksByAuthorId(Long authorId) {
        List<Book> authorBooks = new ArrayList<>();
        for (Book book : books.values()) {
            if (book.getAuthorId().equals(authorId)) {
                authorBooks.add(book);
            }
        }
        return authorBooks;
    }
    
    public Book addBook(Book book) {
        book.setId(idCounter.getAndIncrement());
        books.put(book.getId(), book);
        return book;
    }
    
    public Book updateBook(Long id, Book book) {
        if (!books.containsKey(id)) {
            throw new BookNotFoundException("Book with ID " + id + " does not exist.");
        }
        book.setId(id);
        books.put(id, book);
        return book;
    }
    
    public void deleteBook(Long id) {
        if (!books.containsKey(id)) {
            throw new BookNotFoundException("Book with ID " + id + " does not exist.");
        }
        books.remove(id);
    }
    
    public void updateStock(Long id, int quantity) {
        Book book = getBookById(id);
        book.setStock(book.getStock() - quantity);
        books.put(id, book);
    }
}