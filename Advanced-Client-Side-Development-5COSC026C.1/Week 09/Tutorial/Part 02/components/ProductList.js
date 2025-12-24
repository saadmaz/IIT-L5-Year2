// ProductList.js
import React, { useState } from 'react';

const ProductList = ({ products, addToCart }) => {
  const [quantities, setQuantities] = useState({});

  const handleQuantityChange = (productId, event) => {
    const newQuantities = { ...quantities, [productId]: parseInt(event.target.value, 10) };
    setQuantities(newQuantities);
  };

  return (
    <div>
      <h2>Product List</h2>
      <ul>
        {products.map((product) => (
          <li key={product.id}>
            {product.name} - ${product.price}{' '}
            <input
              type="number"
              min="1"
              value={quantities[product.id] || 1}
              onChange={(e) => handleQuantityChange(product.id, e)}
            />{' '}
            <button onClick={() => addToCart({ ...product, quantity: quantities[product.id] || 1 })}>
              Add to Cart
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ProductList;
