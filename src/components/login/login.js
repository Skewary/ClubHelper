import React from 'react'
import {Card, Alert} from 'antd'
import QRCode from 'qrcode.react'

import {$get, $post} from '../../utils/global'
import {ErrorCodes} from '../../config/constants'

import './login.css'

export class Login extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      uuid: null,
      state: 'none',
      error_message: '',
    }
  }

  componentDidMount() {
    $get('/clubs/admin/login/qrcode/request').then(res => {
      let data = res.data
      this.setState({
        uuid: data.uuid
      }, this.listen)
    }).catch(err => {
      console.log(err)
      this.setState({
        state: 'error'
      })
    })
  }

  listen() {
    let {uuid} = this.state
    this.setState({
      state: 'listening'
    })
    this.interval = setInterval(() => {
      $post('/clubs/admin/login/qrcode/check', {
        uuid: uuid
      }).then(res => {
        if (res.success) {
          let user = res.data.user
          let storage = window.localStorage
          storage.setItem('user_id', user.id)
          storage.setItem('username', user.nickname)
          storage.setItem('real_name', user.real_name)
          storage.setItem('avatar_url', user.avatar_url)
          storage.setItem('email', user.email)
          this.props.history.push('/admin/index')
          clearInterval(this.interval)
        } else if (res.code === ErrorCodes.UUID_NOT_EXIST || res.code === ErrorCodes.UUID_HAS_BEEN_USED) {
          this.setState({
            state: 'expired'
          })
          clearInterval(this.interval)
        } else if (res.code === ErrorCodes.UUID_NOT_BIND) {
          // Do nothing but wait...
        }
      }).catch(err => {
        console.log(err)
        this.setState({
          state: 'error'
        })
      })
    }, 1000)
  }

  render() {
    const {uuid, state} = this.state
    return (
      <div className={'login-area'}>
        <Card className={'card'} title="社团管理员扫码登录" headStyle={{textAlign: 'center'}} bordered={false}
              style={{width: 300}}>
                <p>uuid:{uuid}</p>
          <div style={{height: 250, width: 250, padding: 25}}>
            {uuid && <QRCode value={uuid} size={200}/>}
          </div>
        </Card>
        {state === 'expired' && <Alert message={'二维码已过期，请刷新后重试'} type={'error'}/>}
        {state === 'error' && <Alert message={'异常网络错误发生，请稍后重试'} type={'error'}/>}
      </div>
    )
  }
}