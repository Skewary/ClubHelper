module RandomizeHelper
  def timestamp_random_md5(time = Time.now)
    "#{timestamp time}_#{random_md5}"
  end

  def timestamp_random_sha1(time = Time.now)
    "#{timestamp time}_#{random_sha1}"
  end

  def random_md5
    md5 random_urlsafe_base64
  end

  def random_sha1
    sha1 random_urlsafe_base64
  end

  def random_base64(length = 128)
    SecureRandom.base64(length)
  end

  def random_urlsafe_base64(length = 128)
    SecureRandom.urlsafe_base64(length)
  end

  private
  include DigestHelper

  def timestamp(time = Time.now)
    time.strftime('%Y_%m_%d_%H_%M_%S')
  end
end
