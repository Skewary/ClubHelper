import React from 'react'
import {$get, $post, $put, img} from '../../utils/global'
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
  InputNumber, Checkbox
} from 'antd'
import {PictureUploader} from '../pictureUploader/pictureUploader'

import './articlePanel.css'

import {Empty} from 'antd'
import moment from 'moment'

const pStyle = {
  fontSize: 16,
  color: 'rgba(0,0,0,0.85)',
  lineHeight: '24px',
  display: 'block',
  marginBottom: 16,
}

const DescriptionItem = ({title, content}) => (
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

const ArticleUpdateForm = Form.create({name: 'article_update'})(
  // eslint-disable-next-line
  class extends React.Component {
    render() {
      const {visible, onCancel, onCreate, form, article} = this.props
      const {getFieldDecorator} = form
      return (
        <Modal
          visible={visible}
          title="编辑新闻信息"
          okText="确定"
          cancelText={'取消'}
          onCancel={onCancel}
          onOk={onCreate}
        >
          <Form layout="vertical">
            <Form.Item label="新闻标题">
              {getFieldDecorator('title', {
                initialValue: article.news_title
              })(<Input disabled/>)}
            </Form.Item>
            <Form.Item label="新闻链接">
              {getFieldDecorator('original_url', {
                initialValue: article.news_url,
                rules: [{required: true, message: '请输入新闻链接'}],
              })(<Input/>)}
            </Form.Item>
            <Form.Item label={'封面图片'}>
              {getFieldDecorator('cover_image', {
                valuePropName: 'fileList',
              })(
                <PictureUploader max={1}/>
              )}
            </Form.Item>
          </Form>
        </Modal>
      )
    }
  },
)

const ArticleCreateForm = Form.create({name: 'article_create'})(
  // eslint-disable-next-line
  class extends React.Component {
    render() {
      const {visible, onCancel, onCreate, form, article} = this.props
      const {getFieldDecorator} = form
      return (
        <Modal
          visible={visible}
          title="新建新闻"
          okText="确定"
          cancelText={'取消'}
          onCancel={onCancel}
          onOk={onCreate}
        >
          <Form layout="vertical">
            <Form.Item label="新闻标题">
              {getFieldDecorator('title', {
                  rules: [{required: true, message: '请输入新闻标题'}]
                }
              )(<Input placeholder={'新建新闻后，新闻标题将不可修改'}/>)}
            </Form.Item>
            <Form.Item label="新闻链接">
              {getFieldDecorator('original_url', {
                rules: [{required: true, message: '请输入新闻链接'}],
              })(<Input/>)}
            </Form.Item>
            <Form.Item label={'封面图片'}>
              {getFieldDecorator('cover_image', {
                valuePropName: 'fileList',
                rules: [{required: true, message: '请上传封面图片'}],
              })(
                <PictureUploader max={1}/>
              )}
            </Form.Item>
          </Form>
        </Modal>
      )
    }
  },
)

export class ArticlePanel extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      clubId: props.match.params.club_id,
      articles: [],
      editVisible: false,
      createVisible: false,
      detailVisible: false,
      detail: {}
    }
  }

  componentDidMount() {
    this.refresh()
  }

  refresh() {
    const {clubId} = this.state
    $get('/clubs/admin/' + clubId + '/article/index').then(res => {
      if (!res.success) {
        if (res.code === 600) {
          Modal.confirm({
            title: '获取社团新闻列表失败',
            content: '您并不拥有任何社团管理员权限',
            okText: '我知道了',
            cancelText: '好的',
            onOk: () => {
              this.props.history.push('/admin/index')
            },
            onCancel: () => {
              this.props.history.push('/admin/index')
            }
          })
        } else if (res.code === 613) {
          Modal.confirm({
            title: '获取社团新闻列表失败',
            content: '您并不拥有管理这个社团的权限',
            okText: '我知道了',
            cancelText: '好的',
            onOk: () => {
              this.props.history.push('/admin/index')
            },
            onCancel: () => {
              this.props.history.push('/admin/index')
            }
          })
        } else if (res.code === 602) {
          Modal.confirm({
            title: '社团不存在',
            content: '请返回上一页重试',
            okText: '我知道了',
            cancelText: '好的',
            onOk: () => {
              this.props.history.push('/admin/index')
            },
            onCancel: () => {
              this.props.history.push('/admin/index')
            }
          })
        }
      } else {
        this.setState({
          articles: res.data.articles
        })
      }
    }).catch(err => {
      console.log(err)
    })
  }

  showDetailInfo(id) {
    const {clubId} = this.state
    $get('/clubs/admin/' + clubId + '/article/' + id).then(res => {
      if (res.success) {
        this.setState({
          detailVisible: true,
          detail: res.data.article
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

  editArticle(id) {
    const {clubId} = this.state
    this.setState({
      detail: {}
    }, () => {
      $get('/clubs/admin/' + clubId + '/article/' + id).then(res => {
        if (res.success) {
          this.setState({
            editVisible: true,
            detail: res.data.article
          })
        }
      })
    })
  }

  createArticle(id) {
    this.setState({
      detail: {},
      createVisible: true
    })
  }

  handleEditCancel = () => {
    const form = this.updateFormRef.props.form
    form.resetFields()
    this.setState({
      editVisible: false,
    })
  }

  handleCreateCancel = () => {
    const form = this.createFormRef.props.form
    form.resetFields()
    this.setState({
      createVisible: false
    })
  }

  saveUpdateFormRef = (formRef) => {
    this.updateFormRef = formRef
  }

  saveCreateFormRef = (formRef) => {
    this.createFormRef = formRef
  }

  handleUpdate = () => {
    const {clubId} = this.state
    const form = this.updateFormRef.props.form
    form.validateFields((err, values) => {
      if (err) {
        return
      }
      const articleId = this.state.detail.id
      const {detail} = this.state
      let cover_image_token = values.cover_image && values.cover_image.length > 0 ? values.cover_image[0].response.data.token : null
      $put('/clubs/admin/' + clubId + '/article/' + articleId, {
        original_url: values.original_url,
        cover_image_token: cover_image_token
      }).then((res) => {
        if (!res.success) {
          Modal.confirm({
            title: '新闻信息更新失败',
            content: '请检查您的输入后重试',
            okText: '我知道了',
            cancelText: '好的'
          })
        } else {
          this.setState({editVisible: false}, () => {
            form.resetFields()
            this.refresh()
          })
        }
      })
    })
  }

  handleCreate = () => {
    const {clubId} = this.state
    const form = this.createFormRef.props.form
    form.validateFields((err, values) => {
      if (err) {
        return
      }
      let cover_image_token = values.cover_image && values.cover_image.length > 0 ? values.cover_image[0].response.data.token : null
      $post('/clubs/admin/' + clubId + '/article', {
        title: values.title,
        original_url: values.original_url,
        cover_image_token: cover_image_token
      }).then((res) => {
        if (!res.success) {
          Modal.confirm({
            title: '新闻创建失败',
            content: '请检查您的输入后重试',
            okText: '我知道了',
            cancelText: '好的'
          })
        } else {
          this.setState({createVisible: false}, () => {
            form.resetFields()
            this.refresh()
          })
        }
      })
    })
  }

  goBack() {
    this.props.history.goBack()
  }

  render() {
    let {articles, detail} = this.state
    let articlesView = null
    if (articles.length !== 0) {
      articlesView = articles.map((article, index) => {
        return <Card className={'article-card'} key={index}
                     hoverable={true}
                     cover={<img onClick={this.showDetailInfo.bind(this, article.id)}
                                 style={{height: 175, width: 350}} alt={'poster'}
                                 src={img(article.news_picture)}/>}
                     actions={[
                       <div onClick={this.editArticle.bind(this, article.id)}><Icon style={{fontSize: 20}}
                                                                                    type="edit"/>
                         <div style={{fontSize: 8}}>编辑</div>
                       </div>]}
                     bodyStyle={{padding: 20, textAlign: 'center'}}>
          <Card.Meta onClick={this.showDetailInfo.bind(this, article.id)}
                     title={article.news_title}/>
        </Card>
      })
    } else {
      articlesView = <Empty/>
    }
    return (
      <div className={'article-container'}>
        <div className={'article-button-wrap'}>
          <Button className={'article-button'} onClick={this.goBack.bind(this)} shape={'circle'} icon={'left'}
                  size={'large'} type={'primary'}/>
          <Button className={'article-button'} onClick={this.createArticle.bind(this)} shape={'circle'} icon={'plus'}
                  size={'large'} type="primary"/>
        </div>
        <ArticleUpdateForm
          wrappedComponentRef={this.saveUpdateFormRef}
          visible={this.state.editVisible}
          onCancel={this.handleEditCancel}
          onCreate={this.handleUpdate}
          article={this.state.detail}
        />
        <ArticleCreateForm
          wrappedComponentRef={this.saveCreateFormRef}
          visible={this.state.createVisible}
          onCancel={this.handleCreateCancel}
          onCreate={this.handleCreate}
        />
        <Drawer
          width={640}
          placement="right"
          closable={false}
          onClose={this.onDetailClose.bind(this)}
          visible={this.state.detailVisible}
        >
          <p style={{...pStyle, marginBottom: 24}}>新闻信息</p>
          <p style={pStyle}>基本信息</p>
          <Row>
            <Col span={24}>
              <DescriptionItem title="新闻标题" content={detail.news_title}/>
            </Col>
          </Row>
          <Row>
            <Col span={24}>
              <DescriptionItem title="新闻链接" content={detail.news_url}/>
            </Col>
          </Row>
          {/*<Row>*/}
          {/*  <Col span={12}>*/}
          {/*    <DescriptionItem title="关注人数" content={detail.followers_number}/>*/}
          {/*  </Col>*/}
          {/*  <Col span={12}>*/}
          {/*    <DescriptionItem title="人数" content={detail.joiner_number}/>*/}
          {/*  </Col>*/}
          {/*</Row>*/}
          <Divider/>
        </Drawer>
        {articlesView}</div>)
  }
}