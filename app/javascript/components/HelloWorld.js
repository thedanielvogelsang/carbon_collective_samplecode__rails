import React from "react"
import PropTypes from "prop-types"
class HelloWorld extends React.Component {

  constructor(props){
    super(props);
    this.handleLogin = this.handleLogin.bind(this);
    this.handleEmailChange = this.handleEmailChange.bind(this);
    this.handlePasswordChange = this.handlePasswordChange.bind(this);
    this.state ={
      isLoading: true,
    }
  }

  handleLogin(){
    return fetch('http://localhost:3000/login', {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          user: {
            email: this.state.email,
            password: this.state.password,
          }
        }),
      })
      .catch((error) =>{
        console.error(error);
      });
  }

  handleEmailChange(e){
    this.setState({
      email: e.target.value
    })
  };

  handlePasswordChange(e){
    this.setState({
      password: e.target.value
    })
  };

  render () {

    return (
      <div>
        Greeting: {this.props.greeting}
        <img src={'../../assets/icon256.png'} />
        <form>
          <input type="text" name="email" placeholder="Email" onChange={this.handleEmailChange}/>
          <input type="password" name="password" placeholder="Password" onChange={this.handlePasswordChange}/>
          <button type="button" onClick={this.handleLogin}>Login</button>
        </form>
      </div>
    );
  }
}

HelloWorld.propTypes = {
  greeting: PropTypes.string
};
export default HelloWorld
