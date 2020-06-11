import React from 'react'
import {Upload, message, Button, Icon} from 'antd'

export class PictureUploader extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      fileList: [],
      max: this.props.max
    }
  }

  componentWillReceiveProps(nextProps, nextContext) {
    if (!nextProps.fileList) {
      this.setState({
        fileList: []
      })
    }
  }

  handleChange = info => {
    let fileList = [...info.fileList]
    const {max} = this.state
    fileList = fileList.slice(-max)
    this.setState({
      fileList: fileList
    })
    const onChange = this.props.onChange
    if (onChange) {
      onChange(fileList)
    }
  }

  beforeUpload = file => {
    const tooLarge = file.size > 1 * 1024 * 1024
    if (tooLarge) {
      message.error('图片大小必需在1MB以内，否则将无法提交成功')
    }
    return !tooLarge
  }

  render() {
    const props = {
      name: 'image',
      action: '/api/image',
      onChange: this.handleChange,
      withCredentials: true,
      listType: 'picture',
      accept: '.jpg,.jpeg,.png,.svg,.zip',
      beforeUpload: this.beforeUpload
    }
    return (
      <Upload {...props} fileList={this.state.fileList}>
        <Button>
          <Icon type={'upload'}/>点此上传
        </Button>
      </Upload>
    )
  }

}