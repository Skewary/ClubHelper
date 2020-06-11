import React from 'react'
import './App.css'
import {HashRouter as Router, Switch, Redirect, Route} from 'react-router-dom'
import PrivateRoute from './components/privateRoute/privateRoute'
import {Login} from './components/login/login'
import {Container} from './components/container/container'
import {Error404} from './components/error/404'
import {$delete} from './utils/global'

class App extends React.Component {
    // listener(e){
    //     e.preventDefault();
    //     e.returnValue = '离开当前页后，登录状态将不可恢复' // 浏览器有可能不会提示这个信息，会按照固定信息提示
    //     $delete('/session/logout')
    // }
    // nb
    // componentDidMount() {
    //     window.addEventListener('beforeunload', this.listener)
    // }

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
