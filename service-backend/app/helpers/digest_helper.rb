module DigestHelper
  def sha1(raw_text) # 计算sha1
    Digest::SHA1.hexdigest(raw_text)
  end

  def md5(raw_text) # 计算md5
    Digest::MD5.hexdigest(raw_text)
  end
end
