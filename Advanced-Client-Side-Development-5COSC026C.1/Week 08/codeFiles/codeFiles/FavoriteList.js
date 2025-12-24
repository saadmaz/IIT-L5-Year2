// FavoriteList.js
import React from 'react';

const FavoriteList = ({ favorites }) => {
  return (
    <div>
      <h2>Favorite Books</h2>
      <ul>
        {favorites.map((book) => (
          <li key={book.title}>{book.title} by {book.author}</li>
        ))}
      </ul>
    </div>
  );
};

export default FavoriteList;
