import React from 'react'
import { $get, $post, $put, img } from '../../utils/global'
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
  Table,
    Pagination,
    Form,
  Input,
  Radio,
  InputNumber, Checkbox, Select,
  Upload,
  message
} from 'antd'

import Highlighter from 'react-highlight-words';
import { SearchOutlined } from '@ant-design/icons';

import './activityPanel.css'

import { Empty } from 'antd'
import moment from 'moment'
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

function handleChange(value) {
    console.log(value); // { key: "lucy", label: "Lucy (101)" }
}

const ActivityUpdateForm = Form.create({ name: 'activity_update' })(
  // eslint-disable-next-line
  class extends React.Component {
    render() {
      const { visible, onCancel, onCreate, form, activity } = this.props
      const { getFieldDecorator } = form
      const children = []
      $get('/clubs/list').then(res => {
        if (res.success) {
          let clubs = res.data.clubs.map(item => {
            return {
              id: item.id,
              name: item.name
            }
          })
          for (let i = 0; i < clubs.length; i++) {
            let club = clubs[i]
            children.push(<Select.Option key={club.name}>{club.name}</Select.Option>)
          }
        }
      })
      return (
        <Modal
          visible={visible}
          title="编辑活动信息"
          okText="确定"
          cancelText={'取消'}
          onCancel={onCancel}
          onOk={onCreate}
        >
          <Form layout="vertical">
            <Form.Item label="活动名称">
              {getFieldDecorator('name', {
                initialValue: activity.name
              })(<Input disabled />)}
            </Form.Item>
            <Form.Item label="活动地点">
                {getFieldDecorator('position', {
                    initialValue: activity.place,
                    rules: [
                        { required: true, message: '请选择活动地点' },
                    ],
                })(
                    <Select placeholder="请选择活动地点">
                        <Select.Option value="沙河-百米跑廊">沙河-百米跑廊</Select.Option>
                        <Select.Option value="沙河-大钟广场">沙河-大钟广场</Select.Option>
                        <Select.Option value="沙河-j1三楼电梯间">沙河-j1三楼电梯间</Select.Option>
                        <Select.Option value="沙河-j1四楼电梯间">沙河-j1四楼电梯间</Select.Option>
                        <Select.Option value="沙河-操场">沙河-操场</Select.Option>
                        <Select.Option value="沙河-网球场">沙河-网球场</Select.Option>
                        <Select.Option value="沙河-四公寓一楼">沙河-四公寓一楼</Select.Option>
                        <Select.Option value="沙河-体育馆三楼羽毛球">沙河-体育馆三楼羽毛球</Select.Option>
                        <Select.Option value="沙河-体育馆三楼乒乓球">沙河-体育馆三楼乒乓球</Select.Option>
                        <Select.Option value="沙河-足球场">沙河-足球场</Select.Option>
                        <Select.Option value="沙河-b0-009">沙河-b0-009</Select.Option>
                        <Select.Option value="沙河-b0-011">沙河-b0-011</Select.Option>
                        <Select.Option value="沙河-雄鹰领飞会议室">沙河-雄鹰领飞会议室</Select.Option>
                        <Select.Option value="沙河-导办小会议室">沙河-导办小会议室</Select.Option>
                        <Select.Option value="本部-体育馆217">本部-体育馆217</Select.Option>
                        <Select.Option value="本部-体育馆148">本部-体育馆148</Select.Option>
                        <Select.Option value="本部-健美操厅">本部-健美操厅</Select.Option>
                        <Select.Option value="本部-百米跑廊1">本部-百米跑廊1</Select.Option>
                        <Select.Option value="本部-百米跑廊2">本部-百米跑廊2</Select.Option>
                        <Select.Option value="本部-百米跑廊3">本部-百米跑廊3</Select.Option>
                        <Select.Option value="本部-体育馆平台1">本部-体育馆平台1</Select.Option>
                        <Select.Option value="本部-体育馆平台2">本部-体育馆平台2</Select.Option>
                        <Select.Option value="本部-羽毛球训练馆">本部-羽毛球训练馆</Select.Option>
                        <Select.Option value="本部-小足球场">本部-小足球场</Select.Option>
                        <Select.Option value="本部-乒乓球馆">本部-乒乓球馆</Select.Option>
                        <Select.Option value="本部-室外羽毛球场">本部-室外羽毛球场</Select.Option>
                        <Select.Option value="本部-逸夫楼前">本部-逸夫楼前</Select.Option>
                        <Select.Option value="本部-操场以及老主楼空地">本部-操场以及老主楼空地</Select.Option>
                        <Select.Option value="本部-知行北楼113">本部-知行北楼113</Select.Option>
                    </Select>
                )}
            </Form.Item>

              <Form.Item label="场地使用日期">
                  {getFieldDecorator('act_date', {
                      rules: [
                          { required: false, message: '请选择场地使用日期' },
                      ],
                  })(
                      <Select >
                          <Select.Option value="2020-06-01">2020-06-01</Select.Option>
                          <Select.Option value="2020-06-02">2020-06-02</Select.Option>
                          <Select.Option value="2020-06-03">2020-06-03</Select.Option>
                          <Select.Option value="2020-06-04">2020-06-04</Select.Option>
                          <Select.Option value="2020-06-05">2020-06-05</Select.Option>
                          <Select.Option value="2020-06-06">2020-06-06</Select.Option>
                          <Select.Option value="2020-06-07">2020-06-07</Select.Option>
                          <Select.Option value="2020-06-08">2020-06-08</Select.Option>
                          <Select.Option value="2020-06-09">2020-06-09</Select.Option>
                          <Select.Option value="2020-06-10">2020-06-10</Select.Option>
                          <Select.Option value="2020-06-11">2020-06-11</Select.Option>
                          <Select.Option value="2020-06-12">2020-06-12</Select.Option>
                          <Select.Option value="2020-06-13">2020-06-13</Select.Option>
                          <Select.Option value="2020-06-14">2020-06-14</Select.Option>
                          <Select.Option value="2020-06-15">2020-06-15</Select.Option>
                          <Select.Option value="2020-06-16">2020-06-16</Select.Option>
                          <Select.Option value="2020-06-17">2020-06-17</Select.Option>
                          <Select.Option value="2020-06-18">2020-06-18</Select.Option>
                          <Select.Option value="2020-06-19">2020-06-19</Select.Option>
                          <Select.Option value="2020-06-20">2020-06-20</Select.Option>
                          <Select.Option value="2020-06-21">2020-06-21</Select.Option>
                          <Select.Option value="2020-06-22">2020-06-22</Select.Option>
                          <Select.Option value="2020-06-23">2020-06-23</Select.Option>
                          <Select.Option value="2020-06-24">2020-06-24</Select.Option>
                          <Select.Option value="2020-06-25">2020-06-25</Select.Option>
                          <Select.Option value="2020-06-26">2020-06-26</Select.Option>
                          <Select.Option value="2020-06-27">2020-06-27</Select.Option>
                          <Select.Option value="2020-06-28">2020-06-28</Select.Option>
                          <Select.Option value="2020-06-29">2020-06-29</Select.Option>
                          <Select.Option value="2020-06-30">2020-06-30</Select.Option>
                      </Select>
                  )}
              </Form.Item>

              <Form.Item label="场地使用开始时间">
                  {getFieldDecorator('beg_time', {
                      rules: [
                          { required: false, message: '请选择场地使用开始时间' },
                      ],
                  })(
                      <Select >
                          <Select.Option value="08:00:00">08:00:00</Select.Option>
                          <Select.Option value="09:00:00">09:00:00</Select.Option>
                          <Select.Option value="10:00:00">10:00:00</Select.Option>
                          <Select.Option value="11:00:00">11:00:00</Select.Option>
                          <Select.Option value="12:00:00">12:00:00</Select.Option>
                          <Select.Option value="13:00:00">13:00:00</Select.Option>
                          <Select.Option value="14:00:00">14:00:00</Select.Option>
                          <Select.Option value="15:00:00">15:00:00</Select.Option>
                          <Select.Option value="16:00:00">16:00:00</Select.Option>
                          <Select.Option value="17:00:00">17:00:00</Select.Option>
                          <Select.Option value="18:00:00">18:00:00</Select.Option>
                          <Select.Option value="19:00:00">19:00:00</Select.Option>
                          <Select.Option value="20:00:00">20:00:00</Select.Option>
                          <Select.Option value="21:00:00">21:00:00</Select.Option>
                          <Select.Option value="22:00:00">22:00:00</Select.Option>
                      </Select>
                  )}
              </Form.Item>

              <Form.Item label="场地使用结束时间">
                  {getFieldDecorator('fin_time', {
                      rules: [
                          { required: false, message: '请选择场地使用结束时间' },
                      ],
                  })(
                      <Select >
                          <Select.Option value="08:00:00">08:00:00</Select.Option>
                          <Select.Option value="09:00:00">09:00:00</Select.Option>
                          <Select.Option value="10:00:00">10:00:00</Select.Option>
                          <Select.Option value="11:00:00">11:00:00</Select.Option>
                          <Select.Option value="12:00:00">12:00:00</Select.Option>
                          <Select.Option value="13:00:00">13:00:00</Select.Option>
                          <Select.Option value="14:00:00">14:00:00</Select.Option>
                          <Select.Option value="15:00:00">15:00:00</Select.Option>
                          <Select.Option value="16:00:00">16:00:00</Select.Option>
                          <Select.Option value="17:00:00">17:00:00</Select.Option>
                          <Select.Option value="18:00:00">18:00:00</Select.Option>
                          <Select.Option value="19:00:00">19:00:00</Select.Option>
                          <Select.Option value="20:00:00">20:00:00</Select.Option>
                          <Select.Option value="21:00:00">21:00:00</Select.Option>
                          <Select.Option value="22:00:00">22:00:00</Select.Option>
                      </Select>
                  )}
              </Form.Item>

            <Form.Item label={'活动文件上传(仅支持zip格式)'}>
                {getFieldDecorator('post_vertical_image', {
                    valuePropName: 'fileList',
                })(
                    <PictureUploader max={1}/>
                )}
            </Form.Item>

            <Form.Item label={'海报图片'}>
                {getFieldDecorator('post_horizontal_image', {
                    valuePropName: 'fileList'
                })(
                    <PictureUploader max={1}/>
                )}
            </Form.Item>


              <Form.Item label="活动描述">
              {getFieldDecorator('description', {
                initialValue: activity.description,
                rules: [{ required: true, message: '请输入活动描述' }],
              })(<Input.TextArea rows={5} />)}
            </Form.Item>
            <Form.Item label="开始时间">
              {getFieldDecorator('start_time')(
                <DatePicker placeholder={'未选择则保持不变'} showTime format="YYYY-MM-DD HH:mm:ss" />,
              )}
            </Form.Item>
            <Form.Item label="结束时间">
              {getFieldDecorator('end_time')(
                <DatePicker placeholder={'未选择则保持不变'} showTime format="YYYY-MM-DD HH:mm:ss" />,
              )}
            </Form.Item>
            <Form.Item label={'活动介绍推送标题'}>
              {getFieldDecorator('introduction_article_title', {
                initialValue: activity.introduction_article_title
              })(
                <Input />
              )}
            </Form.Item>
            <Form.Item label={'活动介绍推送链接'}>
              {getFieldDecorator('introduction_article_url', {
                initialValue: activity.introduction_article_url
              })(
                <Input />
              )}
            </Form.Item>
            <Form.Item label={'活动回顾推送标题'}>
              {getFieldDecorator('retrospect_article_title', {
                initialValue: activity.retrospect_article_title
              })(
                <Input />
              )}
            </Form.Item>
            <Form.Item label={'活动回顾推送链接'}>
              {getFieldDecorator('retrospect_article_url', {
                initialValue: activity.retrospect_article_url
              })(
                <Input />
              )}
            </Form.Item>
            <Form.Item label="活动大致规模（单位：人）">
              {getFieldDecorator('max_people_limit', {
                initialValue: activity.max_people_limit
              })(<InputNumber min={1} max={2000} />)}
            </Form.Item>
            <Form.Item label="是否需要报名" help={'本系统不提供报名功能，建议录入活动介绍的推送，或在活动下方评论区说明报名方式。'}>
              {getFieldDecorator('need_enroll', {
                valuePropName: 'checked',
                initialValue: activity.need_enroll || false
              })(
                <Checkbox>
                  需要报名
                </Checkbox>
              )}
            </Form.Item>
            <Form.Item label={'共同举办的社团（移除自己无效哦）'}>
              {getFieldDecorator('host_clubs', {
                initialValue: activity.host_clubs ? activity.host_clubs.map(item => {
                  return item.name
                }) : []
              })(
                <Select mode={'multiple'} placeholder={'请选择共同举办的社团'}>
                  {children}
                </Select>
              )}
            </Form.Item>
  
                   
          </Form>
        </Modal>
      )
    }
  },
)

const ActivityCreateForm = Form.create({ name: 'activity_create' })(
  // eslint-disable-next-line
  class extends React.Component {
    render() {
      const { visible, onCancel, onCreate, form, activity } = this.props
      const { getFieldDecorator } = form
      const children = []
      $get('/clubs/list').then(res => {
        if (res.success) {
          let clubs = res.data.clubs.map(item => {
            return {
              id: item.id,
              name: item.name
            }
          })
          for (let i = 0; i < clubs.length; i++) {
            let club = clubs[i]
            children.push(<Select.Option key={club.name}>{club.name}</Select.Option>)
          }
        }
      })
      return (
        <Modal
          visible={visible}
          title="新建活动"
          okText="确定"
          cancelText={'取消'}
          onCancel={onCancel}
          onOk={onCreate}
        >
          <Form layout="vertical">
            <Form.Item label="活动名称">
              {getFieldDecorator('name', {
                rules: [{ required: true, message: '请输入活动名称' }]
              }
              )(<Input placeholder={'新建活动后，活动名称将不可修改'} />)}
            </Form.Item>
            <Form.Item label="活动地点">
                {getFieldDecorator('position', {
                rules: [
                    { required: true, message: '请选择活动地点' },
                ],
            })(
                <Select >
                    <Select.Option value="沙河-百米跑廊">沙河-百米跑廊</Select.Option>
                    <Select.Option value="沙河-大钟广场">沙河-大钟广场</Select.Option>
                    <Select.Option value="沙河-j1三楼电梯间">沙河-j1三楼电梯间</Select.Option>
                    <Select.Option value="沙河-j1四楼电梯间">沙河-j1四楼电梯间</Select.Option>
                    <Select.Option value="沙河-操场">沙河-操场</Select.Option>
                    <Select.Option value="沙河-网球场">沙河-网球场</Select.Option>
                    <Select.Option value="沙河-四公寓一楼">沙河-四公寓一楼</Select.Option>
                    <Select.Option value="沙河-体育馆三楼羽毛球">沙河-体育馆三楼羽毛球</Select.Option>
                    <Select.Option value="沙河-体育馆三楼乒乓球">沙河-体育馆三楼乒乓球</Select.Option>
                    <Select.Option value="沙河-足球场">沙河-足球场</Select.Option>
                    <Select.Option value="沙河-b0-009">沙河-b0-009</Select.Option>
                    <Select.Option value="沙河-b0-011">沙河-b0-011</Select.Option>
                    <Select.Option value="沙河-雄鹰领飞会议室">沙河-雄鹰领飞会议室</Select.Option>
                    <Select.Option value="沙河-导办小会议室">沙河-导办小会议室</Select.Option>
                    <Select.Option value="本部-体育馆217">本部-体育馆217</Select.Option>
                    <Select.Option value="本部-体育馆148">本部-体育馆148</Select.Option>
                    <Select.Option value="本部-健美操厅">本部-健美操厅</Select.Option>
                    <Select.Option value="本部-百米跑廊1">本部-百米跑廊1</Select.Option>
                    <Select.Option value="本部-百米跑廊2">本部-百米跑廊2</Select.Option>
                    <Select.Option value="本部-百米跑廊3">本部-百米跑廊3</Select.Option>
                    <Select.Option value="本部-体育馆平台1">本部-体育馆平台1</Select.Option>
                    <Select.Option value="本部-体育馆平台2">本部-体育馆平台2</Select.Option>
                    <Select.Option value="本部-羽毛球训练馆">本部-羽毛球训练馆</Select.Option>
                    <Select.Option value="本部-小足球场">本部-小足球场</Select.Option>
                    <Select.Option value="本部-乒乓球馆">本部-乒乓球馆</Select.Option>
                    <Select.Option value="本部-室外羽毛球场">本部-室外羽毛球场</Select.Option>
                    <Select.Option value="本部-逸夫楼前">本部-逸夫楼前</Select.Option>
                    <Select.Option value="本部-操场以及老主楼空地">本部-操场以及老主楼空地</Select.Option>
                    <Select.Option value="本部-知行北楼113">本部-知行北楼113</Select.Option>
                </Select>
            )}
            </Form.Item>

              <Form.Item label="场地使用日期">
                  {getFieldDecorator('act_date', {
                      rules: [
                          { required: true, message: '请选择场地使用日期' },
                      ],
                  })(
                      <Select >
                          <Select.Option value="2020-06-01">2020-06-01</Select.Option>
                          <Select.Option value="2020-06-02">2020-06-02</Select.Option>
                          <Select.Option value="2020-06-03">2020-06-03</Select.Option>
                          <Select.Option value="2020-06-04">2020-06-04</Select.Option>
                          <Select.Option value="2020-06-05">2020-06-05</Select.Option>
                          <Select.Option value="2020-06-06">2020-06-06</Select.Option>
                          <Select.Option value="2020-06-07">2020-06-07</Select.Option>
                          <Select.Option value="2020-06-08">2020-06-08</Select.Option>
                          <Select.Option value="2020-06-09">2020-06-09</Select.Option>
                          <Select.Option value="2020-06-10">2020-06-10</Select.Option>
                          <Select.Option value="2020-06-11">2020-06-11</Select.Option>
                          <Select.Option value="2020-06-12">2020-06-12</Select.Option>
                          <Select.Option value="2020-06-13">2020-06-13</Select.Option>
                          <Select.Option value="2020-06-14">2020-06-14</Select.Option>
                          <Select.Option value="2020-06-15">2020-06-15</Select.Option>
                          <Select.Option value="2020-06-16">2020-06-16</Select.Option>
                          <Select.Option value="2020-06-17">2020-06-17</Select.Option>
                          <Select.Option value="2020-06-18">2020-06-18</Select.Option>
                          <Select.Option value="2020-06-19">2020-06-19</Select.Option>
                          <Select.Option value="2020-06-20">2020-06-20</Select.Option>
                          <Select.Option value="2020-06-21">2020-06-21</Select.Option>
                          <Select.Option value="2020-06-22">2020-06-22</Select.Option>
                          <Select.Option value="2020-06-23">2020-06-23</Select.Option>
                          <Select.Option value="2020-06-24">2020-06-24</Select.Option>
                          <Select.Option value="2020-06-25">2020-06-25</Select.Option>
                          <Select.Option value="2020-06-26">2020-06-26</Select.Option>
                          <Select.Option value="2020-06-27">2020-06-27</Select.Option>
                          <Select.Option value="2020-06-28">2020-06-28</Select.Option>
                          <Select.Option value="2020-06-29">2020-06-29</Select.Option>
                          <Select.Option value="2020-06-30">2020-06-30</Select.Option>
                      </Select>
                  )}
              </Form.Item>

              <Form.Item label="场地使用开始时间">
                  {getFieldDecorator('beg_time', {
                      rules: [
                          { required: true, message: '请选择场地使用开始时间' },
                      ],
                  })(
                      <Select >
                          <Select.Option value="08:00:00">08:00:00</Select.Option>
                          <Select.Option value="09:00:00">09:00:00</Select.Option>
                          <Select.Option value="10:00:00">10:00:00</Select.Option>
                          <Select.Option value="11:00:00">11:00:00</Select.Option>
                          <Select.Option value="12:00:00">12:00:00</Select.Option>
                          <Select.Option value="13:00:00">13:00:00</Select.Option>
                          <Select.Option value="14:00:00">14:00:00</Select.Option>
                          <Select.Option value="15:00:00">15:00:00</Select.Option>
                          <Select.Option value="16:00:00">16:00:00</Select.Option>
                          <Select.Option value="17:00:00">17:00:00</Select.Option>
                          <Select.Option value="18:00:00">18:00:00</Select.Option>
                          <Select.Option value="19:00:00">19:00:00</Select.Option>
                          <Select.Option value="20:00:00">20:00:00</Select.Option>
                          <Select.Option value="21:00:00">21:00:00</Select.Option>
                          <Select.Option value="22:00:00">22:00:00</Select.Option>
                      </Select>
                  )}
              </Form.Item>

              <Form.Item label="场地使用结束时间">
                  {getFieldDecorator('fin_time', {
                      rules: [
                          { required: true, message: '请选择场地使用结束时间' },
                      ],
                  })(
                      <Select >
                          <Select.Option value="08:00:00">08:00:00</Select.Option>
                          <Select.Option value="09:00:00">09:00:00</Select.Option>
                          <Select.Option value="10:00:00">10:00:00</Select.Option>
                          <Select.Option value="11:00:00">11:00:00</Select.Option>
                          <Select.Option value="12:00:00">12:00:00</Select.Option>
                          <Select.Option value="13:00:00">13:00:00</Select.Option>
                          <Select.Option value="14:00:00">14:00:00</Select.Option>
                          <Select.Option value="15:00:00">15:00:00</Select.Option>
                          <Select.Option value="16:00:00">16:00:00</Select.Option>
                          <Select.Option value="17:00:00">17:00:00</Select.Option>
                          <Select.Option value="18:00:00">18:00:00</Select.Option>
                          <Select.Option value="19:00:00">19:00:00</Select.Option>
                          <Select.Option value="20:00:00">20:00:00</Select.Option>
                          <Select.Option value="21:00:00">21:00:00</Select.Option>
                          <Select.Option value="22:00:00">22:00:00</Select.Option>
                      </Select>
                  )}
              </Form.Item>

            <Form.Item label={'活动文件上传(仅支持zip格式)'}>
                {getFieldDecorator('post_vertical_image', {
                    valuePropName: 'fileList',
                })(
                    <PictureUploader max={1}/>
                )}
            </Form.Item>

            <Form.Item label={'海报图片'}>
                {getFieldDecorator('post_horizontal_image', {
                    valuePropName: 'fileList'
                })(
                    <PictureUploader max={1}/>
                )}
            </Form.Item>


              <Form.Item label="活动描述">
              {getFieldDecorator('description', {
                rules: [{ required: true, message: '请输入活动描述' }],
              })(<Input.TextArea rows={5} />)}
            </Form.Item>
            <Form.Item label="开始时间">
              {getFieldDecorator('start_time', {
                rules: [{ required: true, message: '请选择活动开始时间' }]
              }
              )(
                <DatePicker placeholder={'请选择活动开始时间'} showTime format="YYYY-MM-DD HH:mm:ss" />,
              )}
            </Form.Item>
            <Form.Item label="结束时间">
              {getFieldDecorator('end_time')(
                <DatePicker placeholder={'请选择活动结束时间'} showTime format="YYYY-MM-DD HH:mm:ss" />,
              )}
            </Form.Item>
            <Form.Item label={'活动介绍推送标题'}>
              {getFieldDecorator('introduction_article_title')(
                <Input />
              )}
            </Form.Item>
            <Form.Item label={'活动介绍推送链接'}>
              {getFieldDecorator('introduction_article_url')(
                <Input />
              )}
            </Form.Item>
            <Form.Item label={'活动回顾推送标题'}>
              {getFieldDecorator('retrospect_article_title')(
                <Input />
              )}
            </Form.Item>
            <Form.Item label={'活动回顾推送链接'}>
              {getFieldDecorator('retrospect_article_url')(
                <Input />
              )}
            </Form.Item>
            <Form.Item label="活动大致规模（单位：人）">
              {getFieldDecorator('max_people_limit', {})(<InputNumber min={1} max={2000} />)}
            </Form.Item>
            <Form.Item label="是否需要报名" help={'本系统不提供报名功能，建议录入活动介绍的推送，或在活动下方评论区说明报名方式。'}>
              {getFieldDecorator('need_enroll', {
                valuePropName: 'checked',
                initialValue: false
              })(
                <Checkbox>
                  需要报名
                </Checkbox>
              )}
            </Form.Item>
            <Form.Item label={'共同举办的社团'}>
              {getFieldDecorator('host_clubs')(
                <Select mode={'multiple'} placeholder={'请选择共同举办的社团'}>
                  {children}
                </Select>
              )}
            </Form.Item>
          </Form>
        </Modal>
      )
    }
  },
)

const ActivityReviewForm = Form.create({ name: 'activity_review' })(
  // eslint-disable-next-line
  class extends React.Component {
    render() {
      const { visible, onCancel, onCreate, form, activity } = this.props
      const { getFieldDecorator } = form
      const children = []
      $get('/clubs/list').then(res => {
        if (res.success) {
          let clubs = res.data.clubs.map(item => {
            return {
              id: item.id,
              name: item.name
            }
          })
          for (let i = 0; i < clubs.length; i++) {
            let club = clubs[i]
            children.push(<Select.Option key={club.name}>{club.name}</Select.Option>)
          }
        }
      })
      return (
        <Modal
          visible={visible}
          title="审核活动信息"
          okText="确定"
          cancelText={'取消'}
          onCancel={onCancel}
          onOk={onCreate}
        >
          <Form layout="vertical">
            <Form.Item label="活动名称">
              {getFieldDecorator('name', {
                initialValue: activity.name
              })(<Input disabled />)}
            </Form.Item>
            <Form.Item label="活动地点">
              {getFieldDecorator('position', {
                initialValue: activity.place
              })(<Input disabled/>)}
            </Form.Item>

            <Form.Item label="活动文件">
                {getFieldDecorator('description', {
                    initialValue: img(activity.post_url_vertical)
                })(<Input disabled />)}
            </Form.Item>

            <Form.Item label="活动描述">
              {getFieldDecorator('description', {
                initialValue: activity.description
              })(<Input disabled />)}
            </Form.Item>
            <Form.Item label="开始时间">
              {getFieldDecorator('start_time',{
                initialValue: activity.start_time
              })(<Input disabled /> )}
            </Form.Item>
            <Form.Item label="结束时间">
            {getFieldDecorator('end_time',{
                initialValue: activity.end_time
              })(<Input disabled /> )}
            </Form.Item>
            <Form.Item label={'活动介绍推送标题'}>
              {getFieldDecorator('introduction_article_title', {
                initialValue: activity.introduction_article_title
              })(
                <Input disabled/>
              )}
            </Form.Item>
            <Form.Item label={'活动介绍推送链接'}>
              {getFieldDecorator('introduction_article_url', {
                initialValue: activity.introduction_article_url
              })(
                <Input disabled/>
              )}
            </Form.Item>
            <Form.Item label={'活动回顾推送标题'}>
              {getFieldDecorator('retrospect_article_title', {
                initialValue: activity.retrospect_article_title
              })(
                <Input disabled/>
              )}
            </Form.Item>
            <Form.Item label={'活动回顾推送链接'}>
              {getFieldDecorator('retrospect_article_url', {
                initialValue: activity.retrospect_article_url
              })(
                <Input disabled/>
              )}
            </Form.Item>
            <Form.Item label="活动大致规模（单位：人）">
              {getFieldDecorator('max_people_limit', {
                initialValue: activity.max_people_limit
              })(<Input disabled/>)}
            </Form.Item>
            <Form.Item label="审核结果">
            {getFieldDecorator('review_state', {
                valuePropName: 'checked',
                initialValue: false
              })(
                <Checkbox>
                  通过审核
                </Checkbox>
              )} 
                      
            </Form.Item>
            <Form.Item label="审核理由">
              {getFieldDecorator('review_reason', {
                  rules: [{required: true, message: '请输入审核理由'}],
              })(<Input.TextArea rows={5}/>)}
            </Form.Item>
          </Form>
        </Modal>
      )
    }
  },
)

const ActivityEvaluateForm = Form.create({name: 'activity_evaluate'})(
  // eslint-disable-next-line
  class extends React.Component {
      render() {
          const {visible, onCancel, onCreate, form, activity} = this.props
          const {getFieldDecorator} = form
          const children = []
          $get('/clubs/list').then(res => {
              if (res.success) {
                  let clubs = res.data.clubs.map(item => {
                      return {
                          id: item.id,
                          name: item.name
                      }
                  })
                  for (let i = 0; i < clubs.length; i++) {
                      let club = clubs[i]
                      children.push(<Select.Option key={club.name}>{club.name}</Select.Option>)
                  }
              }
          })
          return (
              <Modal
                  visible={visible}
                  title="活动评价"
                  okText="确定"
                  cancelText={'取消'}
                  onCancel={onCancel}
                  onOk={onCreate}
              >
                  <Form layout="vertical">
                      <Form.Item label="活动名称">
                          {getFieldDecorator('name', {
                              initialValue: activity.name
                          })(<Input disabled/>)}
                      </Form.Item>
                      <Form.Item label="活动评分(1到10打个分数吧)">
                          {getFieldDecorator('rank', {
                              initialValue: "",
                              rules: [{required: true, message: '请输入评分'}],
                          })(<Input.TextArea rows={1}/>)}
                      </Form.Item>
                      <Form.Item label="评分理由">
                          {getFieldDecorator('reason', {
                              initialValue: "",
                              rules: [{required: true, message: '请输入评分理由'}],
                          })(<Input.TextArea rows={5}/>)}
                      </Form.Item>
                      <Form.Item label="有无建议">
                          {getFieldDecorator('suggestion', {
                              initialValue: "",
                              rules: [{required: true, message: '请输入相关建议'}],
                          })(<Input.TextArea rows={5}/>)}
                      </Form.Item>

                  </Form>
              </Modal>
          )
      }
  },
)


export class ActivityPanel extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      clubId: props.match.params.club_id,
      activities: [],
      editVisible: false,
      createVisible: false,
      reviewVisible: false,
      evaluateVisible: false,
      detailVisible: false,
      detail: {},
      pass: false,
      user: {role: "admin" },//admin 社长 root 社联
    }
  }

  componentDidMount() {
    $get('/session/current').then(res => {
      console.log(res)
      this.setState({
        user: {
          role: res.data.user.role
        }
      })
    })
    this.refresh()
  }

  refresh() {
    const { clubId } = this.state
    $get('/clubs/admin/' + clubId + '/activity/index').then(res => {
      if (!res.success) {
        if (res.code === 600) {
          Modal.confirm({
            title: '获取社团活动列表失败',
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
            title: '获取社团活动列表失败',
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
          activities: res.data.activities
        })
      }
    }).catch(err => {
      console.log(err)
    })
  }

  showDetailInfo(id) {
    const { clubId } = this.state
    $get('/clubs/admin/' + clubId + '/activity/' + id).then(res => {
      if (res.success) {
        this.setState({
          detailVisible: true,
          detail: res.data.activity
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

 reviewActivity(id) {
    const { clubId } = this.state
    this.setState({
      detail: {}
    }, () => {
      $get('/clubs/admin/' + clubId + '/activity/' + id).then(res => { //need to change?
        if (res.success) {
          this.setState({
            reviewVisible: true,
            detail: res.data.activity
          })
        }
      })
    })
  }

  evaluateActivity(id) {
    const {clubId} = this.state
    this.setState({
        detail: {}
    }, () => {
        $get('/clubs/admin/' + clubId + '/activity/' + id).then(res => {
            if (res.success) {

                this.setState({
                    evaluateVisible: true,
                    detail: res.data.activity
                })
            }
        })
    })
}

  editActivity(id) {
    const { clubId } = this.state
    this.setState({
      detail: {}
    }, () => {
      $get('/clubs/admin/' + clubId + '/activity/' + id).then(res => {
        if (res.success) {
          this.setState({
            editVisible: true,
            detail: res.data.activity
          })
        }
      })
    })
  }

  createActivity(id) {
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

  handleReviewCancel = () => {
    const form = this.reviewFormRef.props.form
    form.resetFields()
    this.setState({
      reviewVisible: false,
    })
  }

  handleEvaluateCancel = () => {
    const form = this.evaluateFormRef.props.form //由update改为create
    form.resetFields()
    this.setState({
        evaluateVisible: false,
    })
}

  saveUpdateFormRef = (formRef) => {
    this.updateFormRef = formRef
  }

  saveCreateFormRef = (formRef) => {
    this.createFormRef = formRef
  }

 saveEvaluateFormRef = (formRef) => {
    this.evaluateFormRef = formRef      //由update改为create
}

  saveReviewFormRef = (formRef) => {
  this.reviewFormRef = formRef      //一定要由update改为create
}

  handleUpdate = () => {
    const { clubId } = this.state
    const form = this.updateFormRef.props.form
    form.validateFields((err, values) => {
        if (err) {
            return
        }
        const activityId = this.state.detail.id
        const {detail} = this.state

        let post_horizontal_image_token = values.post_horizontal_image && values.post_horizontal_image.length > 0 ?
            values.post_horizontal_image[0].response.data.token : null
        let post_vertical_image_token = values.post_vertical_image && values.post_vertical_image.length > 0 ?
            values.post_vertical_image[0].response.data.token : null

        $get('/activities/pos_time').then(res => {
            var tag = 0;
            if (res.success) {
                let kkk = res.data.pos_time_list;
                for (let i = 0; i < kkk.length; i++) {
                    if (values.position == kkk[i].position && values.act_date == kkk[i].act_date) {
                        if (values.beg_time <= kkk[i].beg_time && values.fin_time >= kkk[i].beg_time) {
                            Modal.confirm({
                                title: '活动信息更新失败',
                                content: '您预订的场地已被他人预约，请选择其他时间或场地',
                                okText: '我知道了',
                                cancelText: '好的'
                            })
                            tag = 1;
                            break;
                        }
                        if (values.beg_time >= kkk[i].beg_time && values.beg_time < kkk[i].fin_time) {
                            Modal.confirm({
                                title: '活动信息更新失败',
                                content: '您预订的场地已被他人预约，请选择其他时间或场地',
                                okText: '我知道了',
                                cancelText: '好的'
                            })
                            tag = 1;
                            break;
                        }
                    }
                }
                if (tag == 0){
                    $put('/clubs/admin/' + clubId + '/activity/' + activityId + '/update', {
                        position: values.position,
                        act_date: values.act_date,
                        beg_time: values.beg_time,
                        fin_time: values.fin_time,
                        description: values.description,
                        start_time: (!!values.start_time ? values.start_time.format('YYYY-MM-DD HH:mm:ss') : undefined) || detail.start_time,
                        end_time: (!!values.end_time ? values.end_time.format('YYYY-MM-DD HH:mm:ss') : undefined) || detail.end_time,
                        post_horizontal_image_token: post_horizontal_image_token,
                        post_vertical_image_token: post_vertical_image_token,
                        introduction_article_title: values.introduction_article_title,
                        introduction_article_url: values.introduction_article_url,
                        retrospect_article_title: values.retrospect_article_title,
                        retrospect_article_url: values.retrospect_article_url,
                        max_people_limit: values.max_people_limit,
                        need_enroll: values.need_enroll,
                        host_clubs: values.host_clubs,
                        activity_pdf: values.activity_pdf
                    }).then((res) => {
                        if (!res.success) {
                            Modal.confirm({
                                title: '活动信息更新失败',
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
                }
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
          let post_horizontal_image_token = values.post_horizontal_image && values.post_horizontal_image.length > 0 ?
              values.post_horizontal_image[0].response.data.token : null
          let post_vertical_image_token = values.post_vertical_image && values.post_vertical_image.length > 0 ?
              values.post_vertical_image[0].response.data.token : null

          $get('/activities/pos_time').then(res => {
              var tag = 0;
              if (res.success) {
                  let kkk = res.data.pos_time_list;
                  for (let i = 0; i < kkk.length; i++) {
                      if (values.position == kkk[i].position && values.act_date == kkk[i].act_date) {
                          if (values.beg_time <= kkk[i].beg_time && values.fin_time >= kkk[i].beg_time) {
                              Modal.confirm({
                                  title: '活动创建失败',
                                  content: '您预订的场地已被他人预约，请选择其他时间或场地',
                                  okText: '我知道了',
                                  cancelText: '好的'
                              })
                              tag = 1;
                              break;
                          }
                          if (values.beg_time >= kkk[i].beg_time && values.beg_time < kkk[i].fin_time) {
                              Modal.confirm({
                                  title: '活动创建失败',
                                  content: '您预订的场地已被他人预约，请选择其他时间或场地',
                                  okText: '我知道了',
                                  cancelText: '好的'
                              })
                              tag = 1;
                              break;
                          }
                      }
                  }
                  if (tag == 0) {
                      $post('/clubs/admin/' + clubId + '/activity', {
                          name: values.name,
                          position: values.position,
                          act_date: values.act_date,
                          beg_time: values.beg_time,
                          fin_time: values.fin_time,
                          description: values.description,
                          start_time: values.start_time.format('YYYY-MM-DD HH:mm:ss'),
                          end_time: !!values.end_time ? values.end_time.format('YYYY-MM-DD HH:mm:ss') : null,
                          post_horizontal_image_token: post_horizontal_image_token,
                          post_vertical_image_token: post_vertical_image_token,
                          introduction_article_title: values.introduction_article_title,
                          introduction_article_url: values.introduction_article_url,
                          retrospect_article_title: values.retrospect_article_title,
                          retrospect_article_url: values.retrospect_article_url,
                          max_people_limit: values.max_people_limit,
                          need_enroll: values.need_enroll,
                          host_clubs: values.host_clubs,
                          review_state: values.review_state,
                          activity_pdf: values.activity_pdf
                      }).then((res) => {
                          if (!res.success) {
                              Modal.confirm({
                                  title: '活动创建失败',
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
                  }
              }
          })
      })
  }


  handleReview = () => {
    const { clubId } = this.state
    const form = this.reviewFormRef.props.form //由update改为create？？？create没反应
    form.validateFields((err, values) => {
      if (err) {
        return
      }
      const activityId = this.state.detail.id
      const { detail } = this.state

      $put('/clubs/admin/' + clubId + '/activity/' + activityId + '/review', {

        review_state: values.review_state,
        review_reason: values.review_reason
      }).then((res) => {
        if (!res.success) {
          Modal.confirm({
            title: '活动审核更新失败',
            content: '请检查您的输入后重试',
            okText: '我知道了',
            cancelText: '好的'
          })
        } else {
          this.setState({ reviewVisible: false }, () => {
            form.resetFields()
            this.refresh()
          })
        }
      })
    })
  }

 handleEvaluate = () => {
    const {clubId} = this.state
    const form = this.evaluateFormRef.props.form //由update改为create
    form.validateFields((err, values) => {
        if (err) {
            return
        }
        const activityId = this.state.detail.id
        const {detail} = this.state

        if (detail.review_state){
            $put('/clubs/admin/' + clubId + '/activity/' + activityId + '/evaluate', {
                rank:values.rank,
                reason:values.reason,
                suggestion:values.suggestion

            }).then((res) => {
                if (!res.success) {
                    Modal.confirm({
                        title: '评价信息更新失败',
                        content: '请检查您的输入后重试',
                        okText: '我知道了',
                        cancelText: '好的'
                    })
                } else {
                    this.setState({evaluateVisible: false}, () => {
                        form.resetFields()
                        this.refresh()
                    })
                }
            })
        } else {
            Modal.confirm({
                title: '评价信息更新失败',
                content: '请先审核活动再进行评价',
                okText: '我知道了',
                cancelText: '好的'
            })
        }

    })


}

  goBack() {
    this.props.history.goBack()
  }

  render() { //change
    let { activities, detail, user } = this.state
    let activitiesView = null
    if (activities.length !== 0) {
      activitiesView = activities.map((activity, index) => {
        return <Card className={'activity-card'} key={index}
                     hoverable={true}
                     cover={<img onClick={this.showDetailInfo.bind(this, activity.id)}
                                 style={{height: 175, width: 350}} alt={'poster'}
                                 src={img(activity.post_url_horizontal)}/>}
                     actions={user.role === 'admin' ? [ ///社长
                      <div onClick={this.editActivity.bind(this, activity.id)}><Icon style={{fontSize: 20}}
                                                        type="edit"/>
                        <div style={{fontSize: 8}}>编辑</div>
                      </div>]
                      : user.role === 'root' ? [ //社联
                        <div onClick={this.reviewActivity.bind(this, activity.id)}><Icon style={{fontSize: 20}}
                                            type="edit"/>
                          <div style={{fontSize: 8}}>审核</div>
                        </div>,
                        <div onClick={this.evaluateActivity.bind(this, activity.id)}><Icon style={{fontSize: 20}}
                                          type="edit"/>
                        <div style={{fontSize: 8}}>评价</div>
                        </div>]
                      :null}
                     bodyStyle={{padding: 20, textAlign: 'center'}}>
          <Card.Meta onClick={this.showDetailInfo.bind(this, activity.id)}
                     title={activity.name} description={activity.place}/>
        </Card>
      })
    } else {
      activitiesView = <Empty />
    }
    return (
      <div className={'activity-container'}>

        {user.role === 'admin' ? [
          <div className={'article-button-wrap'}>
            <Button className={'activity-button'} onClick={this.goBack.bind(this)} shape={'circle'} icon={'left'}
              size={'large'} type={'primary'} />
            <Button className={'activity-button'} onClick={this.createActivity.bind(this)} shape={'circle'} icon={'plus'}
              size={'large'} type="primary" />
        </div>]: user.role === 'root' ? [
           <div className={'article-button-wrap'}>
           <Button className={'activity-button'} onClick={this.goBack.bind(this)} shape={'circle'} icon={'left'}
             size={'large'} type={'primary'} />
       </div>]
       :null}
        <ActivityUpdateForm
          wrappedComponentRef={this.saveUpdateFormRef}
          visible={this.state.editVisible}
          onCancel={this.handleEditCancel}
          onCreate={this.handleUpdate}
          activity={this.state.detail}
        />
        <ActivityCreateForm
          wrappedComponentRef={this.saveCreateFormRef}
          visible={this.state.createVisible}
          onCancel={this.handleCreateCancel}
          onCreate={this.handleCreate}
        />
        <ActivityReviewForm
          wrappedComponentRef={this.saveReviewFormRef}
          visible={this.state.reviewVisible}
          onCancel={this.handleReviewCancel}
          onCreate={this.handleReview}
          activity={this.state.detail}
        />
        <ActivityEvaluateForm
          wrappedComponentRef={this.saveEvaluateFormRef}
          visible={this.state.evaluateVisible}
          onCancel={this.handleEvaluateCancel}
          onCreate={this.handleEvaluate}
          activity={this.state.detail}
        />
        <Drawer
          width={640}
          placement="right"
          closable={false}
          onClose={this.onDetailClose.bind(this)}
          visible={this.state.detailVisible}
        >
          <p style={{ ...pStyle, marginBottom: 24 }}>活动信息</p>
          <p style={pStyle}>基本信息</p>
          <Row>
            <Col span={12}>
              <DescriptionItem title="活动名称" content={detail.name} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="活动地点" content={detail.place} />
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="开始时间" content={detail.start_time} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="结束时间" content={detail.end_time} />
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="关注人数" content={detail.followers_number} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="人数" content={detail.joiner_number} />
            </Col>
          </Row>
          <Divider />
          <p style={pStyle}>活动介绍</p>
          <Row>
            <Col span={24}>
              {detail.description}
            </Col>
          </Row>
          <Divider />
          <p style={pStyle}>其它信息</p>
          <Row>
            <Col span={12}>
              <DescriptionItem title="活动最大人数" content={detail.max_people_limit} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="是否需要报名" content={detail.need_enroll ? '是' : '否'} />
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="活动介绍标题" content={detail.introduction_article_title} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="活动介绍推送链接" content={detail.introduction_article_url} />
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="活动回顾标题" content={detail.retrospect_article_title} />
            </Col>
            <Col span={12}>
              <DescriptionItem title="活动介绍推送链接" content={detail.retrospect_article_url} />
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="活动评分" content={detail.rank}/>
            </Col>
          </Row>
          <Row>
            <Col span={12}>
               <DescriptionItem title="评分理由" content={detail.reason}/>
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="改进建议" content={detail.suggestion}/>
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="审核结果" content={
                detail.review_state === true ? "通过" : "不通过"}/>
            </Col>
          </Row>
          <Row>
            <Col span={12}>
              <DescriptionItem title="审核原因" content={detail.review_reason}/>
            </Col>
              </Row>*
        </Drawer>
        {activitiesView}</div>
    )
  }
}
