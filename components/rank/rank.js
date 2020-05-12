import React from 'react'
import {Layout, Menu, Breadcrumb} from 'antd'
import {BrowserRouter as Router, Redirect, Route, Switch} from 'react-router-dom'
import { Rate } from 'antd';

import {
    Card,
    Modal,
    Icon,
    DatePicker,
    Drawer,
    List,
    Avatar,
    Divider,
    Col,
    Row,
    Button,
    Form,
    Input,
    Radio,
    InputNumber, Checkbox, Select, Typography
} from 'antd'
import './rank.css'
import {$delete} from '../../utils/global'

const {Header, Content, Footer} = Layout
const { TextArea } = Input;

const options = [
    { value: '1', label: '1' },
    { value: '2', label: '2' },
    { value: '3', label: '3' }
];


export class rank extends React.Component {
    gotoIndex() {
        this.props.history.push('/admin/index')
    }

    logout() {
        $delete('/session/logout').then(res => {
            this.props.history.push('/admin/login')
        })
    }
    gotoRank() {
        this.props.history.push('/admin/rank')
    }

    state = {
        visible: false,
        value1: 1,
        value2: 1,
        value3: 1
    };

    showModal = () => {
        this.setState({
            visible: true
        });
    };

    handleOk = e => {
        console.log(e);
        this.setState({
            visible: false,
        });
    };

    handleCancel = e => {
        console.log(e);
        this.setState({
            visible: false,
        });
    };

    onChange1 = k => {
        console.log('radio checked', k.target.value);
        this.setState({
            value1: k.target.value,
        });
    };

    onChange2 = k2 => {
        console.log('radio checked', k2.target.value);
        this.setState({
            value2: k2.target.value,
        });
    };

    onChange3 = k3 => {
        console.log('radio checked', k3.target.value);
        this.setState({
            value3: k3.target.value,
        });
    };

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
                        <Menu.Item onClick={this.gotoRank.bind(this)} key="1">活动评价</Menu.Item>
                        <Menu.Item onClick={this.gotoIndex.bind(this)} key="2">主页</Menu.Item>
                        <Menu.Item onClick={this.logout.bind(this)} key="3">登出</Menu.Item>

                    </Menu>
                </Header>
                <Content style={{padding: '0 50px'}}>
                    <Breadcrumb style={{margin: '16px 0'}}>
                        <Breadcrumb.Item>社联活动评价</Breadcrumb.Item>
                        {/*<Breadcrumb.Item>List</Breadcrumb.Item>*/}
                        {/*<Breadcrumb.Item>App</Breadcrumb.Item>*/}
                    </Breadcrumb>
                    <div style={{background: '#FFF', padding: 10, height: '2000px'}}>
                        <Form layout="vertical">
                            <Form.Item label="社团名称-活动名称">
                                <Select  placeholder={'选择活动'}>
                                    <option value='1'>社团1</option>
                                    <option value='2'>社团2</option>
                                    <option value='3'>社团3</option>

                                </Select>
                            </Form.Item>

                            <Form.Item label="评分">
                                {/*<Select  placeholder={'请从一到五分中选择一个分数'}>
                                    <option value='1'>1</option>
                                    <option value='1.5'>1.5</option>
                                    <option value='2'>2</option>
                                    <option value='2.5'>2.5</option>
                                    <option value='3'>3</option>
                                    <option value='3.5'>3.5</option>
                                    <option value='4'>4</option>
                                    <option value='4.5'>4.5</option>
                                    <option value='5'>5</option>
                                </Select>*/}

                                <div>
                                    <Rate allowClear={false} allowHalf defaultValue={3} />
                                </div>
                                <br/>
                                活动效果：
                                <Radio.Group onChange={this.onChange1} value={this.state.value1}>
                                    <Radio value={1}>满意</Radio>
                                    <Radio value={2}>比较满意</Radio>
                                    <Radio value={3}>一般</Radio>
                                    <Radio value={4}>不满意</Radio>
                                </Radio.Group>
                                <br/>

                                场地管理：
                                <Radio.Group onChange={this.onChange2} value={this.state.value2}>
                                    <Radio value={1}>满意</Radio>
                                    <Radio value={2}>比较满意</Radio>
                                    <Radio value={3}>一般</Radio>
                                    <Radio value={4}>不满意</Radio>
                                </Radio.Group>
                                <br/>

                                人员分配：
                                <Radio.Group onChange={this.onChange3} value={this.state.value3}>
                                    <Radio value={1}>满意</Radio>
                                    <Radio value={2}>比较满意</Radio>
                                    <Radio value={3}>一般</Radio>
                                    <Radio value={4}>不满意</Radio>
                                </Radio.Group>

                            </Form.Item>
                            <Form.Item label="给出您的评分理由">
                                <TextArea rows={4} />

                                {/*<TextField id="filled-basic" label="Filled" variant="filled" />*/}


                            </Form.Item>

                            <Form.Item label="有无建议">
                                <TextArea rows={4} />

                            </Form.Item>

                        </Form>


                           {/* <PrivateRoute path={match.url + '/index'} exact component={ClubPanel}/>
                            <PrivateRoute path={match.url + '/:club_id/activity/index'} exact component={ActivityPanel}/>
                            <PrivateRoute path={match.url + '/:club_id/article/index'} exact component={ArticlePanel}/>*/}
                            {/*<Redirect to={'/error/404'}/>*/}

                            <Button type="primary" onClick={this.showModal}>
                                提交
                            </Button>
                            <Modal
                                title="确认提交"
                                visible={this.state.visible}
                                onOk={this.handleOk}
                                onCancel={this.handleCancel}
                            >
                                <p>您确定要提交吗？</p>

                            </Modal>

                    </div>

                </Content>
                <Footer style={{textAlign: 'center'}}>2020 RogerPirates</Footer>
            </Layout>
        )
    }



}
