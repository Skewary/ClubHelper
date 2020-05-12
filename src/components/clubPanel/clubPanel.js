import React from 'react'
import { $get, $put, img } from '../../utils/global'
import {
  Card,
  Modal,
  Icon,
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
  Upload,
  Select,
  Badge
} from 'antd'

import './clubPanel.css'

import { Empty } from 'antd'
import { PictureUploader } from '../pictureUploader/pictureUploader'

const pStyle = {
  fontSize: 16,
  color: 'rgba(0,0,0,0.85)',
  lineHeight: '24px',
  display: 'block',
  marginBottom: 16,
}

const DescriptionItem = ({ title, content }) => (
  <div
    style={{
      fontSize: 14,
      lineHeight: '22px',
      marginBottom: 7,
      color: 'rgba(0,0,0,0.65)',
    }}
  >
    <p
      style={{
        marginRight: 8,
        display: 'inline-block',
        color: 'rgba(0,0,0,0.85)',
      }}
    >
      {title}:
    </p>
    {content}
  </div>
)

const ClubActivityForm = Form.create({ name: 'club_update' })(
  // eslint-disable-next-line
  class extends React.Component {
    render() {
      const { visible, onCancel, onCreate, form, club } = this.props
      const { getFieldDecorator } = form
      const validateTags = (rule, value, callback) => {
        if (!value) {
          callback()
          return
        }
        if (value.length > 3) {
          callback('社团标签不能多于三个')
          return
        }
        for (let i = 0; i < value.length; i++) {
          if (value[i].length < 1 || value[i].length > 4) {
            callback('标签字数应在1~4之间')
            return
          }
        }
        callback()
      }
      return (
        <Modal
          visible={visible}
          title="编辑社团信息"
          okText="确定"
          cancelText={'取消'}
          onCancel={onCancel}
          onOk={onCreate}
        >
          <Form layout="vertical">
            <Form.Item label="社团名称">
              {getFieldDecorator('name', {
                initialValue: club.name
              })(<Input disabled />)}
            </Form.Item>
            <Form.Item label={'社团Logo'}>
              {getFieldDecorator('logo', {
                valuePropName: 'fileList'
              }
              )(
                <PictureUploader max={1} />,
              )}
            </Form.Item>
            <Form.Item label="英文名称">
              {getFieldDecorator('english_name', {
                initialValue: club.english_name
              })(<Input />)}
            </Form.Item>
            <Form.Item label="社团简介">
              {getFieldDecorator('introduction', {
                initialValue: club.introduction
              })(<Input.TextArea rows={5} />)}
            </Form.Item>
            <Form.Item label="微信公众号">
              {getFieldDecorator('wechat_public_account', {
                initialValue: club.wechat_public_account
              })(<Input />)}
            </Form.Item>
            <Form.Item label="QQ群">
              {getFieldDecorator('qq_group_number', {
                initialValue: club.qq_group_number
              })(<Input />)}
            </Form.Item>
            <Form.Item label="社团介绍推文链接">
              {getFieldDecorator('introduction_url', {
                initialValue: club.introduction_url
              })(<Input />)}
            </Form.Item>
            <Form.Item label={'社团标签'}>
              {getFieldDecorator('tags', {
                initialValue: club.tags,
                rules: [
                  { validator: validateTags }
                ]
              })(<Select mode={'tags'} placeholder={'请输入社团标签'} />)}
            </Form.Item>
            <Form.Item label={'社团图集'} help={'如果您提交了新的社团图集，旧社团图集将被完全覆盖'}>
              {getFieldDecorator('album', {
                valuePropName: 'fileList'
              })(
                <PictureUploader max={5} />
              )}
            </Form.Item>
          </Form>
        </Modal>
      )
    }
  },
)

export class ClubPanel extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      needSort: false,
      user: { role: null },//admin 社长 root 社联
      clubs: [],
      editVisible: false,
      detailVisible: false,
      detail: {}
    }
  }

  componentDidMount() {
    $get('/session/current').then(res => {
      console.log(res)
      if (res.success) {
        this.setState({
          user: {
            role: res.data.user.role
          }
        })
      }
    })
    this.refresh()
  }

  refresh() {
    $get('/clubs/admin/index').then(res => {
      console.log('refresh')
      console.log(res.data.clubs)
      if (!res.success) {
        if (res.code !== 200) {
          Modal.confirm({
            title: '获取可管理的社团列表失败',
            content: '也许您并不是社团管理员',
            okText: '我知道了',
            cancelText: '好的'
          })
        }
      } else {
        this.setState({
          clubs: res.data.clubs
        })
      }
    }).catch(err => {
      console.log(err)
    })
  }

  showDetailInfo(id) {
    $get('/clubs/admin/' + id).then(res => {
      if (res.success) {
        this.setState({
          detailVisible: true,
          detail: res.data.club
        })
      }
    })
  }

  onDetailClose() {
    this.setState({
      detailVisible: false,
      detail: {}
    })
  }

  editClub(id) {
    this.setState({
      detail: {}
    }, () => {
      $get('/clubs/admin/' + id).then(res => {
        if (res.success) {
          this.setState({
            editVisible: true,
            detail: res.data.club
          })
        }
      })
    })
  }

  handleEditCancel = () => {
    const form = this.formRef.props.form
    form.resetFields()
    this.setState({
      editVisible: false,
    })
  }

  saveFormRef = (formRef) => {
    this.formRef = formRef
  }

  handleCreate = () => {
    const form = this.formRef.props.form
    form.validateFields((err, values) => {
      if (err) {
        return
      }

      let icon_token = values.logo && values.logo.length > 0 ? values.logo[0].response.data.token : null

      let album_tokens = values.album && values.album.length > 0 ? values.album.map(item => {
        return item.response.data.token
      }) : null

      $put('/clubs/admin/' + this.state.detail.id, {
        icon_token: icon_token,
        english_name: values.english_name,
        introduction: values.introduction,
        qq_group_number: values.qq_group_number,
        wechat_public_account: values.wechat_public_account,
        introduction_url: values.introduction_url,
        tags: values.tags,
        album_tokens: album_tokens
      }).then((res) => {
        if (!res.success) {
          Modal.confirm({
            title: '社团信息更新失败',
            content: '请检查您的输入后重试',
            okText: '我知道了',
            cancelText: '好的'
          })
        } else {
          this.setState({ editVisible: false }, () => {
            form.resetFields()
            this.refresh()
          })
        }
      })
    })
  }

  showActivities(id) {
    this.props.history.push('/admin/' + id + '/activity/index')
  }

  showArticles(id) {
    this.props.history.push('/admin/' + id + '/article/index')
  }

  render() {
    let { clubs, detail, user } = this.state
    let clubsView = null
    if (clubs.length !== 0) {
      clubsView = clubs.map((club, index) => {
        {/*console.log(club)*/ }
        let actions =
          user.role == 'root' ? [
            <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
              <div style={{ fontSize: 8 }}>
                <Badge dot={false}>
                  新闻
                </Badge>
              </div>
            </div>,
            <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
              type="calendar" />
              <div style={{ fontSize: 8 }}>
                <Badge dot={club.applying}>
                  申请
                </Badge>
              </div>
            </div>] :
            user.role = 'admin' ? [
              <div onClick={this.editClub.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                <div style={{ fontSize: 8 }}>编辑</div>
              </div>,
              <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                <div style={{ fontSize: 8 }}>新闻</div>
              </div>,
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                type="calendar" />
                <div style={{ fontSize: 8 }}>活动</div>
              </div>] :
              []
        return <Card className={'club-card'} key={index}
          hoverable={true}
          cover={<img onClick={this.showDetailInfo.bind(this, club.id)}
            style={{ height: 165, width: 165, margin: 5 }} alt={'icon'} src={img(club.icon_url)} />}
          actions={actions}
          bodyStyle={{ padding: 20, textAlign: 'center' }}>
          <Card.Meta onClick={this.showDetailInfo.bind(this, club.id)}
            title={club.name} description={club.category + '，' + club.level + '星级'} />
        </Card>
      })
      if (this.state.needSort && user.role == 'root') {
        //活动+评价
        clubsView = clubs.map((club, index) => {
          if (!(club.applying && club.unevaluated)) {
            return null;
          }
          let actions =
            user.role == 'root' ? [
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                <div style={{ fontSize: 8 }}><Badge dot={club.unevaluated}>
                  评价
                  </Badge></div>
              </div>,
              <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                <div style={{ fontSize: 8 }}>
                  <Badge dot={false}>
                    新闻
                  </Badge>
                </div>
              </div>,
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                type="calendar" />
                <div style={{ fontSize: 8 }}>
                  <Badge dot={club.applying}>
                    申请
                  </Badge>
                </div>
              </div>] :
              user.role = 'admin' ? [
                <div onClick={this.editClub.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                  <div style={{ fontSize: 8 }}>编辑</div>
                </div>,
                <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                  <div style={{ fontSize: 8 }}>新闻</div>
                </div>,
                <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                  type="calendar" />
                  <div style={{ fontSize: 8 }}>活动</div>
                </div>] :
                []
          return <Card className={'club-card'} key={index}
            hoverable={true}
            cover={<img onClick={this.showDetailInfo.bind(this, club.id)}
              style={{ height: 165, width: 165, margin: 5 }} alt={'icon'} src={img(club.icon_url)} />}
            actions={actions}
            bodyStyle={{ padding: 20, textAlign: 'center' }}>
            <Card.Meta onClick={this.showDetailInfo.bind(this, club.id)}
              title={club.name} description={club.category + '，' + club.level + '星级'} />
          </Card>
        })
        //活动
        clubsView.push(clubs.map((club, index) => {
          if (!(club.applying && !club.unevaluated)) {
            return null;
          }
          let actions =
            user.role == 'root' ? [
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                <div style={{ fontSize: 8 }}><Badge dot={club.unevaluated}>
                  评价
                  </Badge></div>
              </div>,
              <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                <div style={{ fontSize: 8 }}>
                  <Badge dot={false}>
                    新闻
                  </Badge>
                </div>
              </div>,
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                type="calendar" />
                <div style={{ fontSize: 8 }}>
                  <Badge dot={club.applying}>
                    申请
                  </Badge>
                </div>
              </div>] :
              user.role = 'admin' ? [
                <div onClick={this.editClub.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                  <div style={{ fontSize: 8 }}>编辑</div>
                </div>,
                <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                  <div style={{ fontSize: 8 }}>新闻</div>
                </div>,
                <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                  type="calendar" />
                  <div style={{ fontSize: 8 }}>活动</div>
                </div>] :
                []
          return <Card className={'club-card'} key={index}
            hoverable={true}
            cover={<img onClick={this.showDetailInfo.bind(this, club.id)}
              style={{ height: 165, width: 165, margin: 5 }} alt={'icon'} src={img(club.icon_url)} />}
            actions={actions}
            bodyStyle={{ padding: 20, textAlign: 'center' }}>
            <Card.Meta onClick={this.showDetailInfo.bind(this, club.id)}
              title={club.name} description={club.category + '，' + club.level + '星级'} />
          </Card>
        }))
        //评价
        clubsView.push(clubs.map((club, index) => {
          if (!(!club.applying && club.unevaluated)) {
            return null;
          }
          let actions =
            user.role == 'root' ? [
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                <div style={{ fontSize: 8 }}><Badge dot={club.unevaluated}>
                  评价
                  </Badge></div>
              </div>,
              <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                <div style={{ fontSize: 8 }}>
                  <Badge dot={false}>
                    新闻
                  </Badge>
                </div>
              </div>,
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                type="calendar" />
                <div style={{ fontSize: 8 }}>
                  <Badge dot={club.applying}>
                    申请
                  </Badge>
                </div>
              </div>] :
              user.role = 'admin' ? [
                <div onClick={this.editClub.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                  <div style={{ fontSize: 8 }}>编辑</div>
                </div>,
                <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                  <div style={{ fontSize: 8 }}>新闻</div>
                </div>,
                <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                  type="calendar" />
                  <div style={{ fontSize: 8 }}>活动</div>
                </div>] :
                []
          return <Card className={'club-card'} key={index}
            hoverable={true}
            cover={<img onClick={this.showDetailInfo.bind(this, club.id)}
              style={{ height: 165, width: 165, margin: 5 }} alt={'icon'} src={img(club.icon_url)} />}
            actions={actions}
            bodyStyle={{ padding: 20, textAlign: 'center' }}>
            <Card.Meta onClick={this.showDetailInfo.bind(this, club.id)}
              title={club.name} description={club.category + '，' + club.level + '星级'} />
          </Card>
        }))
        //双非
        clubsView.push(clubs.map((club, index) => {
          if (!(!club.applying && !club.unevaluated)) {
            return null;
          }
          let actions =
            user.role == 'root' ? [
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                <div style={{ fontSize: 8 }}><Badge dot={club.unevaluated}>
                  评价
                  </Badge></div>
              </div>,
              <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                <div style={{ fontSize: 8 }}>
                  <Badge dot={false}>
                    新闻
                  </Badge>
                </div>
              </div>,
              <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                type="calendar" />
                <div style={{ fontSize: 8 }}>
                  <Badge dot={club.applying}>
                    申请
                  </Badge>
                </div>
              </div>] :
              user.role = 'admin' ? [
                <div onClick={this.editClub.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="edit" />
                  <div style={{ fontSize: 8 }}>编辑</div>
                </div>,
                <div onClick={this.showArticles.bind(this, club.id)}><Icon style={{ fontSize: 20 }} type="tags" />
                  <div style={{ fontSize: 8 }}>新闻</div>
                </div>,
                <div onClick={this.showActivities.bind(this, club.id)}><Icon style={{ fontSize: 20 }}
                  type="calendar" />
                  <div style={{ fontSize: 8 }}>活动</div>
                </div>] :
                []
          return <Card className={'club-card'} key={index}
            hoverable={true}
            cover={<img onClick={this.showDetailInfo.bind(this, club.id)}
              style={{ height: 165, width: 165, margin: 5 }} alt={'icon'} src={img(club.icon_url)} />}
            actions={actions}
            bodyStyle={{ padding: 20, textAlign: 'center' }}>
            <Card.Meta onClick={this.showDetailInfo.bind(this, club.id)}
              title={club.name} description={club.category + '，' + club.level + '星级'} />
          </Card>
        }))
      }
    } else {
      clubsView = <Empty />
    }
    return (
      <div className={'club-container'}>
        {/* 
        <Button onClick={() => {
          let newRole = 'admin'
          if (this.state.user.role != 'root') {
            newRole = 'root'
          }
          this.setState({
            user: { role: newRole }
          })
        }}>root/admin</Button>
        <Button onClick={() => {
          let newSort = false
          if (this.state.needSort != true) {
            newSort = true
          }
          this.setState({
            needSort: newSort
          })
        }}>排序/不排序</Button>
      */}
        <ClubActivityForm
          wrappedComponentRef={this.saveFormRef}
          visible={this.state.editVisible}
          onCancel={this.handleEditCancel}
          onCreate={this.handleCreate}
          club={this.state.detail}
        />
        <Drawer
          width={640}
          placement="right"
          closable={false}
          onClose={this.onDetailClose.bind(this)}
          visible={this.state.detailVisible}
        >
          <p style={{ ...pStyle, marginBottom: 24 }}>社团信息</p>
          <p style={pStyle}>基本信息</p>
          <Row>
            <Col span={12}>
              <DescriptionItem title="社团名称" content={detail.name} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="英文名称" content={detail.english_name} />
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="类别" content={detail.category} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="星级" content={detail.level} />
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="关注人数" content={detail.followers_count} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="社内人数" content={detail.members_count} />
            </Col>
          </Row>
          <Divider />
          <p style={pStyle}>社团简介</p>
          <Row>
            <Col span={24}>
              {detail.introduction}
            </Col>
          </Row>
          <Divider />
          <p style={pStyle}>联系方式</p>
          <Row>
            <Col span={12}>
              <DescriptionItem title="微信公众号" content={detail.wechat_public_account} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="QQ群号" content={detail.qq_group_number} />
            </Col>
          </Row>
          <Row>
            <Col span={24}>
              <DescriptionItem
                title="社团介绍推文链接"
                content={
                  <a href={detail.introduction_url}>
                    {detail.introduction_url}
                  </a>
                }
              />
            </Col>
          </Row>
        </Drawer>
        {clubsView}</div>)
  }
}
