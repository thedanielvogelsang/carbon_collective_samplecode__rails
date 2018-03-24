import React, { Component } from 'react';
import './topbar.css';
class Topbar extends Component {
  render() {
    return (
      <div>
        <header>
          <div class="side-buffer">
            <img src="./img/Entypo_d83c(0)_128.png"/>
          </div>
          <h1>carbon collective</h1>
          <div class="side-buffer">
            {this.props.action}
          </div>
        </header>
      </div>
    ); // return()
  } // render(){}
}

export default Topbar;
