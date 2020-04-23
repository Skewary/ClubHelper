import React from 'react'
import {Button, Card} from 'antd'

import './404.css'

export class Error404 extends React.Component {
    gotoIndex = () => {
        this.props.history.push('/admin/index')
    }

    render() {
        return <div className={'not-found-area'}>
            <Card className={'not-found-card'} headStyle={{textAlign: 'center'}} bordered={false}
                  style={{width: 500}} cover={<img alt={'404'}
                                                   src={'https://club-app-public-1259249016.cos.ap-beijing.myqcloud.com/images/global/404.jpeg'}/>}>
            </Card>
            <Button type={'primary'} onClick={this.gotoIndex}>点击跳转到主页</Button>
        </div>
    }
}
