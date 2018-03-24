import React from "react"
import PropTypes from "prop-types"
class HelloWorld extends React.Component {
  render () {
    return (
      <React.Fragment>
        Greeting: {this.props.greeting}
        <img src={'../../assets/icon256.png'} />
      </React.Fragment>
    );
  }
}

HelloWorld.propTypes = {
  greeting: PropTypes.string
};
export default HelloWorld
