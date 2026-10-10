package com.saad.restful_bookstore_api.dao;

import com.saad.restful_bookstore_api.exception.BookNotFoundException;
import com.saad.restful_bookstore_api.model.Book;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

/**
 * In-memory storage for books. Lookups of a missing ID throw BookNotFoundException.
 *
 * @author saadm
 */
public class BookDAO {
    private static final Map<Long, Book> books = new ConcurrentHashMap<>();
    private static final AtomicLong idCounter = new AtomicLong(1);

    static {
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
        return books.values().stream()
                .filter(book -> authorId.equals(book.getAuthorId()))
                .collect(Collectors.toList());
    }

    public Book addBook(Book book) {
        book.setId(idCounter.getAndIncrement());
        books.put(book.getId(), book);
        return book;
    }

    public Book updateBook(Long id, Book book) {
        getBookById(id);
        book.setId(id);
        books.put(id, book);
        return book;
    }

    /** @return the deleted book */
    public Book deleteBook(Long id) {
        Book book = getBookById(id);
        books.remove(id);
        return book;
    }

    /** Changes stock by {@code change}: negative when an order is placed, positive when one is cancelled. */
    public synchronized void adjustStock(Long id, int change) {
        Book book = getBookById(id);
        book.setStock(book.getStock() + change);
    }
}
