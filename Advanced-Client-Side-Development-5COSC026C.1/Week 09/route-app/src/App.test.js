import { render, screen } from '@testing-library/react';
import App from './App';

test('renders nav links and the home page by default', () => {
  render(<App />);
  expect(screen.getByRole('link', { name: 'Home' })).toBeInTheDocument();
  expect(screen.getByRole('link', { name: 'About' })).toBeInTheDocument();
  expect(screen.getByRole('link', { name: 'Contact' })).toBeInTheDocument();
  expect(screen.getByRole('heading', { name: 'Home' })).toBeInTheDocument();
});
