import React from 'react'
import './App.css'
import {BrowserRouter as Router, Switch, Redirect, Route} from 'react-router-dom'
import PrivateRoute from './components/privateRoute/privateRoute'
import {Login} from './components/login/login'
import {Container} from './components/container/container'
import {Error404} from './components/error/404'

class App extends React.Component {
  render() {
    return (
      <Router>
        <Switch>
          <Route path={'/'} exact={true} render={() => {
            return <Redirect to={'/admin/index'}/>
          }}/>
          <Route path={'/admin/login'} exact={true} component={Login}/>
          <PrivateRoute path={'/admin'} component={Container}/>
          <Route path={'/error/404'} exact={true} component={Error404}/>
          <Redirect to={'/error/404'}/>
        </Switch>
      </Router>
    )
  }
}

export default App
