import React from 'react'
import {Route, withRouter} from 'react-router-dom'
import {$get} from '../../utils/global'

class PrivateRoute extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      hasLoggedIn: true
    }
  }

  componentWillMount() {
    $get('/system/time').then(res => {
      this.setState({
        hasLoggedIn: res.success
      }, () => {
        if (!this.state.hasLoggedIn) {
          const {history} = this.props
          setTimeout(() => {
            history.replace('/admin/login')
          }, 1000)
        }
      })
    })
  }

  render() {
    let {component: Component, ...rest} = this.props
    return this.state.hasLoggedIn ?
      (<Route {...rest} render={(props) => (<Component {...props} />
      )}/>) : (
        <p style={{'width': '100%', 'text-align': 'center', 'fontSize': '20px', 'lineHeight': '50px'}}>请登录</p>
      )
  }

}

export default withRouter(PrivateRoute)