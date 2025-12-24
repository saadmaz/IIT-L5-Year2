// Cart.js
import React from 'react';

const Cart = ({ cart, removeFromCart, updateQuantity }) => {
  return (
    <div>
      <h2>Shopping Cart</h2>
      <ul>
        {cart.map((item) => (
          <li key={item.id}>
            {item.name} - ${item.price}{' '}
            <input
              type="number"
              min="1"
              value={item.quantity}
              onChange={(e) => updateQuantity(item, e.target.value)}
            />{' '}
            <button onClick={() => removeFromCart(item)}>Remove</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default Cart;
