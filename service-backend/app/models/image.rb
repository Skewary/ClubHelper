class Image < ApplicationRecord
  has_many :club_contain_images, dependent: :destroy
  has_many :contained_clubs, through: :club_contain_images, source: :club

  validates :filename, presence: true

  module Category
    extend ApplicationRecord::ApplicationConstants

    PUBLIC = 0
  end
  validates :category, presence: true, inclusion: {in: Category.constant_values}
  validates :token, presence: true, uniqueness: {case_sensitive: true}

  DEFAULT_CATEGORY = Category::PUBLIC
  before_validation do
    self.category ||= DEFAULT_CATEGORY
    self.token ||= timestamp_random_md5
  end

  DEFAULT_URL_EXPIRE = 300 # 地址超时时间
  DEFAULT_MIN_CACHE_EXPIRE = 180
  DEFAULT_MAX_CACHE_EXPIRE = 240
  # 获取文件下载地址（临时地址）
  def download_url!(expire = nil, force: false)
    if force || !$redis_cache.get_object(_url_cache_key).present?
      _url = _raw_download_url expire
      if _url.present?
        _expire = (DEFAULT_MAX_CACHE_EXPIRE - DEFAULT_MIN_CACHE_EXPIRE) * rand + DEFAULT_MIN_CACHE_EXPIRE
        $redis_cache.set_cache(_url_cache_key, _url, _expire)
      end
    else
      _url = $redis_cache.get_object(_url_cache_key)
    end
    _url
  end

  def download_url(expire = nil, force: false)
    begin
      download_url! expire, force: force
    rescue Exception
      nil
    end
  end

  # 使用方法
  # 直接调用Image.upload_image!(path, token, filename)
  # path 是本地文件路径
  # token 是随机标识（可缺省，随机生成）
  # filename 是想要上传的文件名（可缺省，从path自动获取）
  # 返回值为一个Image对象，当且仅当上传成功时才返回Image对象，否则抛出异常
  def Image.upload_image!(path, token = nil, filename = nil)
    ApplicationRecord.transaction do
      _path = Path.new path
      filename ||= (_path % (_path / "..")).to_s
      token ||= timestamp_random_sha1

      image = Image.create! filename: filename, token: token
      _result = UtilsMiddleware.image_upload path, token, filename
      raise Exception.new("Upload Failed - #{_result[:message]}") unless _result[:success]

      image
    end
  end

  # 上传图片（无异常版，出现错误返回nil）
  def Image.upload_image(path, token = nil, filename = nil)
    begin
      upload_image! path, token, filename
    rescue Exception
      nil
    end
  end

  # 此外
  # 图床系统建议采用的模式，是通过请求上传文件（一般的表单文件请求即可）
  # 然后暂时存储到本地的一个文件路径下（推荐使用临时文件系统）
  # 然后通过本上传功能进行上传（filename参数建议填好，以便保留其原本的文件名，以便后期正常显示图片）
  # 上传完毕后，本地删除临时文件（一定要删，本地硬盘就一百G不到，经不起折腾）
  # 次全部过程中，还需做好充分的容错处理（简而言之，出了锅也不可以导致程序crash，而且必须能准确反馈出出锅地点和原因）


  private
  def _url_cache_key
    "image_url_cache_token_#{self.token}"
  end

  def _raw_download_url(expire = nil)
    _result = UtilsMiddleware.image_url(self.token, expire || DEFAULT_URL_EXPIRE)
    raise Exception.new("Get Download Url Failed - #{_result[:message]}") unless _result[:success]

    _data = _result[:data]
    _data[:url]
  end

  include ::UtilsHelper
  extend ::UtilsHelper
end
