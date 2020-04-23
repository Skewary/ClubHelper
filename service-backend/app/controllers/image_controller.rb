class ImageController < ApplicationController
  before_action :login_only
  before_action :_find_image, except: [:upload]

  private

  include TempHelper

  def _find_image # 查找相关的image,判断image是不是已经存在
    @image = Image.find_by(token: params[:token])
    if @image
      true
    else
      render status: 400, json: response_json(
          false,
          code: ImageOperationErrorCode::IMAGE_NOT_EXIST,
          message: 'Image not found.'
      )
      false
    end
  end

  public

  def upload #上传图片
    file = params[:image]
    puts file
    tmpdir = get_temp_dir
    image = Image.create! filename: file.original_filename

    begin
      filepath = (Path.new(tmpdir) / image.filename).to_s
      File.open(filepath, 'wb') do |f|
        f.write(file.read)
      end
    rescue Exception => exception # 上传文件失败,提示错误信息
      render status: 400, json: response_json(
          false,
          code: ImageOperationErrorCode::IMAGE_UPLOAD_FAILED,
          message: 'Image upload failed.',
          data: {
              class: exception.class.to_s,
              message: exception.message
          }
      )
      return
    end

    begin
      image = Image.upload_image!(filepath)
    rescue Exception => exception
      render status: 400, json: response_json(
          false,
          code: ImageOperationErrorCode::IMAGE_SAVE_FAILED,
          message: 'Image save failed.',
          data: {
              class: exception.class.to_s,
              message: exception.message
          }
      )
      return
    end

    remove_tmp_dir tmpdir
    render status: 200, json: response_json(
        true,
        data: {
            token: image.token
        }
    )
  end

  IMAGE_EXPIRE_TIME = 1200
  IMAGE_CACHE_EXPIRE_TIME = (IMAGE_EXPIRE_TIME * 0.9).to_i

  def get #通过输入的下载url下载图片
    _url = @image.download_url
    unless _url
      render status: 400, json: response_json(
          false,
          code: ImageOperationErrorCode::IMAGE_GET_BY_TOKEN_FAILED,
          message: 'Image get by token failed.'
      )
    end
    redirect_to _url
  end

end
