// BookList.js
import React from 'react';

const BookList = ({ books, handleAddToFavorites }) => {
  return (
    <ul>
      {books.map((book) => (
        <li key={book.title}>
          {book.title} by {book.author}
          <button onClick={() => handleAddToFavorites(book)}>Add to Favorites</button>
        </li>
      ))}
    </ul>
  );
};

export default BookList;
