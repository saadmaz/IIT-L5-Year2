
import React from 'react';
import { Home } from 'lucide-react';
import ThemeToggle from './ThemeToggle';

const Header = () => {
  return (
    <header className="bg-card shadow-sm border-b border-border">
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <div className="bg-primary p-2 rounded-lg">
              <Home className="w-6 h-6 text-primary-foreground" />
            </div>
            <h1 className="text-2xl font-bold text-foreground">PropertyHub</h1>
          </div>
          <ThemeToggle />
        </div>
      </div>
    </header>
  );
};

export default Header;
