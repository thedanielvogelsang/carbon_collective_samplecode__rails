import React, { Component } from 'react';
import Topbar from './Topbar.js';
import './landing.css';

class Landing extends Component {
  render() {
    return (
      <div id="landing">
          <Topbar action={
            <button>Login</button>
          }/>

        <main>
          <img src="../../assets/earth_lights_space.jpg"/>
          <p>
            My work explores the relationship between postmodern discourse and vegetarian ethics.

            With influences as diverse as Rousseau and Roy Lichtenstein, new variations are crafted from both orderly and random textures.

            Ever since I was a postgraduate I have been fascinated by the endless oscillation of the zeitgeist. What starts out as hope soon becomes debased into a carnival of distress, leaving only a sense of decadence and the chance of a new reality.

            As momentary derivatives become distorted through studious and personal practice, the viewer is left with an epitaph for the possibilities of our era.
          </p>
        </main>

      </div>
    ); // return
  } // render
}

export default Landing;
