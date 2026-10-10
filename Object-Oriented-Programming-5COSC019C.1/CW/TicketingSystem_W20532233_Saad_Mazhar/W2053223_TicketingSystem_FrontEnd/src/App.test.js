import { render, screen } from '@testing-library/react';
import App from './App';

test('renders the home page', () => {
  render(<App />);
  expect(screen.getByText(/experience the best events near you/i)).toBeInTheDocument();
  expect(screen.getByRole('button', { name: /explore the events/i })).toBeInTheDocument();
});
