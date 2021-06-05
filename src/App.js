import React, {Component } from 'react'
import Header from './components/Header.js'
import Body from './components/Body.js'
import axios from 'axios'

class App extends Component {
  constructor(props){
    super(props)
    this.state = {
      posts: []
    }

  }
  componentDidMount(){
    axios.get('https://jsonplaceholder.typicode.com/posts')
    .then(response => {
      this.setState({
        posts:response.data
      })
      console.log(response.data)
    })
  }
  render(){
  return (
    <div className="container">
      <Header></Header>
      <Body></Body>
    </div>
  )
}
}


/*
class App extends React.Component {
  render(){
   return <h1>Hello from a class</h1>
  }
}
*/


export default App;
