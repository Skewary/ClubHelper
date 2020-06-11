import React from 'react'
import { Modal, Card, Alert, Button, Input, Form, Icon, message } from 'antd'
import QRCode from 'qrcode.react'

import { $get, $post } from '../../utils/global'
import { ErrorCodes } from '../../config/constants'

import './login.css'

export class Login extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      uuid: null,
      state: 'none',
      error_message: '',
      signUpVisible: false,//注册
      signInVisible: false,//登录
      forgetVisible: false
    }
  }

  componentDidMount() {
    console.log('qrcode')
    $get('/clubs/admin/login/qrcode/request').then(res => {
      console.log('qrcode then')
      let data = res.data
      this.setState({
        uuid: data.uuid
      }, this.listen)
    }).catch(err => {
      console.log('qrcode catch')
      console.log(err)
      this.setState({
        state: 'error'
      })
    })
  }
  componentWillUnmount(){
    console.log('login.js unmount')
    clearInterval(this.interval)
  }

  listen() {
    let { uuid } = this.state
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
        console.log('check err...')
        console.log(err)
        this.setState({
          state: 'error'
        })
      })
    }, 10000)
  }

  render() {
    const { uuid, state } = this.state
    let actions = [<label onClick={(e) => {
      this.setState({
        signInVisible: true
      })
    }}>账号密码登录</label>,
    <label onClick={(e) => {
      this.setState({
        signUpVisible: true
      })
    }}>注册</label>]
    return (
      < div className={'login-area'} >
        <Card className={'card'} title="社团管理员登录" headStyle={{ textAlign: 'center' }} bordered={false}
          style={{ width: 300 }} actions={actions}>
          <div style={{ height: 250, width: 250, padding: 25 }}>
            {uuid && <QRCode value={uuid} size={200} />}
          </div>
        </Card>
        {state === 'expired' && <Alert message={'二维码已过期，请刷新后重试'} type={'error'} />}
        {state === 'error' && <Alert message={'异常网络错误发生，请稍后重试'} type={'error'} />}
        <Modal
          okText='没有账号?点击注册'
          width={640}
          title='账号密码登录'
          centered={true}
          onCancel={(e) => {
            this.setState({
              signInVisible: false
            })
          }}
          onOk={(e) => {
            this.setState({
              signUpVisible: true,
              signInVisible: false
            })
          }}
          visible={this.state.signInVisible}
        >
          <MyLoginForm history={this.props.history} />
        </Modal>
        <Modal
          okText='已有账号?点击登录'
          onOk={(e) => {
            this.setState({
              signInVisible: true,
              signUpVisible: false
            })
          }}
          width={640}
          title='账号注册'
          centered={true}
          onCancel={(e) => {
            this.setState({
              signUpVisible: false
            })
          }}
          visible={this.state.signUpVisible}
        >
          <MyRegisterForm history={this.props.history}/>

        </Modal>
      </div >
    )
  }
}

function hasErrors(fieldsError) {
  return Object.keys(fieldsError).some(field => fieldsError[field]);
}
class LoginForm extends React.Component {
  componentDidMount() {
    // To disabled submit button at the beginning.
    this.props.form.validateFields();
  }
  handleSubmit = e => {
    e.preventDefault();
    this.props.form.validateFields((err, values) => {
      if (!err) {
        let tmpData = {
          username: values.username,
          password: values.password,
          remember: 'no'
        }
        $post('/session/login', tmpData).then(res => {
          console.log('login then...')
          if (res.success) {
            message.success('登录成功')
            console.log(res)
            let user = res.data.user
            let storage = window.localStorage
            storage.setItem('user_id', user.id)
            storage.setItem('username', user.nickname)
            storage.setItem('real_name', user.real_name)
            storage.setItem('avatar_url', user.avatar_url)
            storage.setItem('email', user.email)
            this.props.history.push('/admin/index')
            clearInterval(this.interval)
          } else if (res.code == ErrorCodes.USER_PASSWORD_WRONG) {
            message.error('登录失败：用户名或密码错误')
            this.props.history.push('/admin/index')
          } else if (res.code == ErrorCodes.USER_LOCKED) {
            message.error('登录失败：用户被锁')
          } else {
            message.error('登陆失败：未知错误')
          }
        }).catch(err => {
          console.log('login catchs...')
          console.log(err)
          this.setState({
            state: 'error'
          })
        })
        console.log('Received values of form: ', tmpData);
      }
    });
  };
  render() {
    const { getFieldDecorator, getFieldsError, getFieldError, isFieldTouched } = this.props.form;
    // Only show error after a field is touched.
    const usernameError = isFieldTouched('username') && getFieldError('username');
    const passwordError = isFieldTouched('password') && getFieldError('password');
    return (
      <Form onSubmit={this.handleSubmit}>
        <Form.Item validateStatus={usernameError ? 'error' : ''} help={usernameError || ''}>
          {getFieldDecorator('username', {
            rules: [{ required: true, message: 'Please input your username!' }],
          })(
            <Input
              prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
              placeholder="Username"
            />,
          )}
        </Form.Item>
        <Form.Item validateStatus={passwordError ? 'error' : ''} help={passwordError || ''}>
          {getFieldDecorator('password', {
            rules: [{ required: true, message: 'Please input your Password!' }],
          })(
            <Input
              prefix={<Icon type="lock" style={{ color: 'rgba(0,0,0,.25)' }} />}
              type="password"
              placeholder="Password"
            />,
          )}
        </Form.Item>
        <Form.Item>
          <Button type="primary" htmlType="submit" disabled={hasErrors(getFieldsError())}>
            登录
          </Button>
        </Form.Item>
      </Form>
    );
  }
}
class RegisterForm extends React.Component {
  componentDidMount() {
    // To disabled submit button at the beginning.
    this.props.form.validateFields();
  }
  handleSubmit = e => {
    e.preventDefault();
    this.props.form.validateFields((err, values) => {
      if (!err) {
        let tmpData = {
          username: values.username,
          real_name: values.realName,
          student_id: values.studentId,
          email: values.email,
          gender: 'secret',
          password: values.password,
          password_confirmation: values.confirmPassword
        }
        $post('/session/register', tmpData).then(res => {
          console.log('reg then...')
          if (res.success) {
            message.success('注册成功')
          } else {
            message.error('注册失败')
            this.props.history.push('/admin/index')

          }
        }).catch(err => {
          console.log('reg catch...')
          console.log(err)
          this.setState({
            state: 'error'
          })
        })
        console.log('Received values of form: ', tmpData);
      }
    });
  };
  render() {
    const { getFieldDecorator, getFieldsError, getFieldError, isFieldTouched } = this.props.form;
    // Only show error after a field is touched.
    const usernameError = isFieldTouched('username') && getFieldError('username');
    const passwordError = isFieldTouched('password') && getFieldError('password');
    const confirmPasswordError = isFieldTouched('confirmPassword') && getFieldError('confirmPassword');

    const realNameError = isFieldTouched('realName') && getFieldError('realName');
    const studentIdError = isFieldTouched('studentId') && getFieldError('studentId');
    const emailError = isFieldTouched('email') && getFieldError('email');
    const wxidError = isFieldTouched('wxid') && getFieldError('wxid');
    
    return (
      <Form onSubmit={this.handleSubmit}>
        <Form.Item validateStatus={usernameError ? 'error' : ''} help={usernameError || ''}>
          {getFieldDecorator('username', {
            rules: [{ required: true, message: 'Please input your username!' }],
          })(
            <Input
              prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
              placeholder="Username"
            />,
          )}
        </Form.Item>
        <Form.Item validateStatus={wxidError ? 'error' : ''} help={wxidError || ''}>
          {getFieldDecorator('wxid', {
            rules: [{ required: true, message: 'Please input your wechat number!' }],
          })(
            <Input
              prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
              placeholder="WeChat Number"
            />,
          )}
        </Form.Item>
        <Form.Item validateStatus={realNameError ? 'error' : ''} help={realNameError || ''}>
          {getFieldDecorator('realName', {
            rules: [{ required: true, message: 'Please input your realName!' }],
          })(
            <Input
              prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
              placeholder="realName"
            />,
          )}
        </Form.Item>
        <Form.Item validateStatus={studentIdError ? 'error' : ''} help={studentIdError || ''}>
          {getFieldDecorator('studentId', {
            rules: [{ required: true, message: 'Please input your studentId!' }],
          })(
            <Input
              prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
              placeholder="studentId"
            />,
          )}
        </Form.Item>
        <Form.Item validateStatus={emailError ? 'error' : ''} help={emailError || ''}>
          {getFieldDecorator('email', {
            rules: [{ required: true, message: 'Please input your email!' }],
          })(
            <Input
              prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
              placeholder="email"
            />,
          )}
        </Form.Item>
        <Form.Item validateStatus={passwordError ? 'error' : ''} help={passwordError || ''}>
          {getFieldDecorator('password', {
            rules: [{ required: true, message: 'Please input your Password!' }],
          })(
            <Input
              prefix={<Icon type="lock" style={{ color: 'rgba(0,0,0,.25)' }} />}
              type="password"
              placeholder="Password"
            />,
          )}
        </Form.Item>
        <Form.Item validateStatus={confirmPasswordError ? 'error' : ''} help={confirmPasswordError || ''}>
          {getFieldDecorator('confirmPassword', {
            rules: [{ required: true, message: 'Please input your Passwor Again!' }],
          })(
            <Input
              prefix={<Icon type="lock" style={{ color: 'rgba(0,0,0,.25)' }} />}
              type="password"
              placeholder="Confirm Password"
            />,
          )}
        </Form.Item>
        <Form.Item>
          <Button type="primary" htmlType="submit" disabled={hasErrors(getFieldsError())}>
            注册
          </Button>
        </Form.Item>
      </Form>
    );
  }
}
const MyLoginForm = Form.create({ name: 'login' })(LoginForm);
const MyRegisterForm = Form.create({ name: 'register' })(RegisterForm);
