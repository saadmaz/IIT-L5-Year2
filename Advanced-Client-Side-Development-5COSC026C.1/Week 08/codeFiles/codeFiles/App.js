// App.js
import React, { useState, useEffect } from 'react';
import SearchBar from './components/SearchBar';
import BookList from './components/BookList';
import FavoriteList from './components/FavoriteList';






const App = () => {
  const [books, setBooks] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [favorites, setFavorites] = useState([]);

  useEffect(() => {
    // Fetch data from books.json or your API
    fetch('/books.json')
      .then((response) => response.json())
      .then((data) => setBooks(data.books))
      .catch((error) => console.error('Error fetching data:', error));
  }, []);

  const handleSearch = (term) => {
    setSearchTerm(term);
  };

  const filteredBooks = books.filter((book) =>
    book.title.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handleAddToFavorites = (book) => {
    setFavorites([...favorites, book]);
  };

  useEffect(() => {
    // Save favorites to local storage whenever it changes
    localStorage.setItem('favorites', JSON.stringify(favorites));
  }, [favorites]);

  useEffect(() => {
    // Load favorites from local storage on component mount
    const savedFavorites = localStorage.getItem('favorites');
    if (savedFavorites) {
      setFavorites(JSON.parse(savedFavorites));
    }
  }, []);

  return (
    <div>
      <SearchBar handleSearch={handleSearch} />
      <BookList books={filteredBooks} handleAddToFavorites={handleAddToFavorites} />
      <FavoriteList favorites={favorites} />
    </div>
  );
};

export default App;
