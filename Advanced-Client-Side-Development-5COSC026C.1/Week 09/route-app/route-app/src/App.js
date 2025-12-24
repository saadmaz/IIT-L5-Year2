import logo from './logo.svg';
import './App.css';
import Nav from './Nav';
import Home from './Home';
import About from './About';
import Contact from './Contact';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'

function App() {
  return (
    <Router>
      <div>
        <Nav />
        <div className="content">
          <Routes>
            <Route exact path='/' element={<Home />} />
            <Route exact path='/about' element={<About />} />
            <Route exact path='/contact' element={<Contact />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;
