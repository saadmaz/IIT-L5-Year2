// Checkout.js
import React, { useState } from 'react';

const Checkout = ({ cart, handleCheckout }) => {
  const [selectedDate, setSelectedDate] = useState('');

  const handleDateChange = (event) => {
    setSelectedDate(event.target.value);
  };

  return (
    <div>
      <h2>Checkout</h2>
      <form>
        <label>
          Select a date:
          <input
            type="date"
            value={selectedDate}
            onChange={handleDateChange}
          />
        </label>
        <button type="button" onClick={() => handleCheckout(selectedDate, cart)}>
          Checkout
        </button>
      </form>
    </div>
  );
};

export default Checkout;
