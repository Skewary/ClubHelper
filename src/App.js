import React from 'react'
import './App.css'
import {BrowserRouter as Router, Switch, Redirect, Route} from 'react-router-dom'
import PrivateRoute from './components/privateRoute/privateRoute'
import {Login} from './components/login/login'
import {Container} from './components/container/container'
import {Error404} from './components/error/404'
import {rank} from './components/rank/rank'
import {ActivityPanel} from "./components/activityPanel/activityPanel";
import {ArticlePanel} from "./components/articlePanel/articlePanel";
import {ClubPanel} from "./components/clubPanel/clubPanel";

class App extends React.Component {
    render() {
        return (
            <Router>
              <Switch>
                <Route path={'/'} exact={true} render={() => {
                    return <Redirect to={'/admin/index'}/> //重定向初识界面
                }}/>
                <Route path={'/admin/login'} exact={true} component={Login}/>
                  <Route path={'/admin/rank'} exact={true} component={rank}/>

                  <PrivateRoute path={'/admin'} component={Container}/>
                <Route path={'/error/404'} exact={true} component={Error404}/>
                <Redirect to={'/error/404'}/>

              </Switch>
            </Router>
        )
    }
}

export default App
