package com.saad.restful_bookstore_api.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * A book in the store. Wrapper types are used so a field missing from the JSON
 * arrives as null and can be rejected, instead of silently becoming 0.
 *
 * @author saadm
 */
@XmlRootElement
public class Book {
    private Long id;
    private String title;
    private Long authorId;
    private String isbn;
    private Integer publicationYear;
    private Double price;
    private Integer stock;

    // Filled in by BookResource on the way out; ignored if a client sends it
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private Author author;

    public Book() {
    }

    public Book(Long id, String title, Long authorId, String isbn, Integer publicationYear, Double price, Integer stock) {
        this.id = id;
        this.title = title;
        this.authorId = authorId;
        this.isbn = isbn;
        this.publicationYear = publicationYear;
        this.price = price;
        this.stock = stock;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Long getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Long authorId) {
        this.authorId = authorId;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public Integer getPublicationYear() {
        return publicationYear;
    }

    public void setPublicationYear(Integer publicationYear) {
        this.publicationYear = publicationYear;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public Author getAuthor() {
        return author;
    }

    public void setAuthor(Author author) {
        this.author = author;
    }
}
