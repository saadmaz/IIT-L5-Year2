// App.js
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import ProductList from './components/ProductList';
import Cart from './components/Cart';
import Checkout from './components/Checkout';

const App = () => {
  const [products, setProducts] = useState([]);
  const [cart, setCart] = useState([]);
  const [user, setUser] = useState(null);
  const [isLoggedIn, setLoggedIn] = useState(false);

  useEffect(() => {
    // Fetch product data from JSON file
    fetch('/products.json')
      .then(response => response.json())
      .then(data => setProducts(data))
      .catch(error => console.error('Error fetching product data:', error));
  }, []);

  const addToCart = product => {
    setCart([...cart, product]);
  };

  const removeFromCart = product => {
    setCart(cart.filter(item => item.id !== product.id));
  };

  const updateQuantity = (product, newQuantity) => {
    const quantity = parseInt(newQuantity, 10);
    if (quantity >= 1) {
      setCart(
        cart.map(item =>
          item.id === product.id ? { ...item, quantity: quantity } : item
        )
      );
    }
  };

  const handleLogin = () => {
    setUser({ username: 'exampleUser' });
    setLoggedIn(true);
  };

  const handleLogout = () => {
    setUser(null);
    setLoggedIn(false);
  };

  const handleCheckout = (selectedDate, cart) => {
    // Implement your checkout logic here
    console.log(`Checkout on ${selectedDate}`);
    console.log('Cart items:', cart);
    // You can clear the cart or perform other checkout-related actions
    setCart([]);
  };

  return (
    <Router>
      <div>
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/cart">Cart</Link>
            </li>
            {isLoggedIn && (
              <li>
                <Link to="/checkout">Checkout</Link>
              </li>
            )}
          </ul>
          <div>
            {!isLoggedIn ? (
              <button onClick={handleLogin}>Login</button>
            ) : (
              <div>
                Welcome, {user && user.username}!{' '}
                <button onClick={handleLogout}>Logout</button>
              </div>
            )}
          </div>
        </nav>

        <Routes>
          <Route path="/cart" element={<Cart cart={cart} removeFromCart={removeFromCart} updateQuantity={updateQuantity} />} />
          <Route path="/checkout" element={<Checkout cart={cart} handleCheckout={handleCheckout} />} />
          <Route path="/" element={<ProductList products={products} addToCart={addToCart} />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
