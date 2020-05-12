import React from 'react'
import {Layout, Menu, Breadcrumb} from 'antd'
import {BrowserRouter as Router, Redirect, Route, Switch} from 'react-router-dom'
import {ClubPanel} from '../clubPanel/clubPanel'
import PrivateRoute from '../../components/privateRoute/privateRoute'

import './container.css'
import {ActivityPanel} from '../activityPanel/activityPanel'
import {$delete} from '../../utils/global'
import {ArticlePanel} from '../articlePanel/articlePanel'

const {Header, Content, Footer} = Layout

export class Container extends React.Component {
  gotoIndex() {
    this.props.history.push('/admin/index')
  }

  logout() {
    $delete('/session/logout').then(res => {
      this.props.history.push('/admin/login')
    })
  }

  render() {
    let {match} = this.props
    return (
      <Layout className="layout">
        <Header>
          <div className="logo"/>
          <Menu
            theme="dark"
            mode="horizontal"
            defaultSelectedKeys={['1']}
            style={{lineHeight: '64px'}}
          >
            <Menu.Item onClick={this.gotoIndex.bind(this)} key="1">主页</Menu.Item>
            <Menu.Item onClick={this.logout.bind(this)} key="2">登出</Menu.Item>
          </Menu>
        </Header>
        <Content style={{padding: '0 50px'}}>
          <Breadcrumb style={{margin: '16px 0'}}>
            <Breadcrumb.Item>社团管理</Breadcrumb.Item>
            {/*<Breadcrumb.Item>List</Breadcrumb.Item>*/}
            {/*<Breadcrumb.Item>App</Breadcrumb.Item>*/}
          </Breadcrumb>
          <div style={{background: '#fff', padding: 24}}>
            <Switch>
              <PrivateRoute path={match.url + '/index'} exact component={ClubPanel}/>
              <PrivateRoute path={match.url + '/:club_id/activity/index'} exact component={ActivityPanel}/>
              <PrivateRoute path={match.url + '/:club_id/article/index'} exact component={ArticlePanel}/>
              <Redirect to={'/error/404'}/>
            </Switch>
          </div>
        </Content>
        <Footer style={{textAlign: 'center'}}>BuaaClubs ©2019 Created by BuaaRedSun</Footer>
      </Layout>
    )
  }
}