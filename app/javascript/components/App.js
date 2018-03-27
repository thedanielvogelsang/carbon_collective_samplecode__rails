// using an older version of react-router because that's what I'm familure with
import React, { Component } from 'react';
// import logo from './logo.svg';
import './app.css';
import 'react-bootstrap'
import { BrowserRouter as Router, Route } from 'react-router-dom';
import Landing from './Landing.js';

// const Test = () => (
//   <div>
//     <h1>Hello World</h1>
//   </div>
// );
class App extends Component {
  render() {
    return (
      <div className="App">
        <Router>
          <Route path="/" component={Landing}/>
        </Router>
      </div>
    );
  }
}

export default App;
