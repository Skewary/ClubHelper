class Hash
  # hash 合并与覆盖
  def +(x)
    (self.to_a + x.to_a).to_h
  end

  # 删除键
  def remove_key(key)
    tmp = self
    tmp.delete(key)
    tmp
  end

  # 删除多个键
  def remove_keys(keys)
    tmp = self
    keys.each {|key| tmp = tmp.remove_key(key)}
    tmp
  end

  # 转化为字符串hash
  def to_string_hash
    self.collect {|key, value| [key.to_s, value]}.to_h
  end

  # 转化为symbol hash
  def to_sym_hash
    self.collect {|key, value| [key.to_s.to_sym, value]}.to_h
  end

  # 仅保留一部分键（force为true时若不存在强行加上）
  def only_keys(keys, force: false)
    result = {}
    keys.each {|key| result[key] = self[key] if force || self.has_key?(key)}
    result
  end
end

module Enumerable
  def choice # 任意选择
    self.to_a[rand(self.to_a.length)]
  end
end

class String
  # 从json转回来
  def from_json
    JSON.parse(self)
  end

  # 从json转回来，并将所有的key转化为symbol类型
  def from_json_to_sym
    parse_to_sym_processor(JSON.parse(self))
  end

  def wildcard_match?(word)
    !!Regexp.new("^#{self.gsub(/([\\\^\&\[\]\{\}\(\)\.\+])/) {|x| "\\#{$1}"}.gsub("*", ".*").gsub("?", ".{1}")}$").match(word)
  end

  def from_base64
    Object.from_base64 self
  end

  private
  # 递归处理器
  def parse_to_sym_processor(origin_value)
    if origin_value.class == Array
      origin_value.collect {|value| parse_to_sym_processor(value)}
    elsif origin_value.class == Hash
      origin_value.collect {|key, value|
        [key.to_s.to_sym, parse_to_sym_processor(value)]
      }.to_h
    else
      origin_value
    end
  end
end

class Redis::Namespace
  def set_object(key, value)
    set key, object_encode(value)
  end

  def get_object(key)
    _origin = get(key)
    if !_origin.nil?
      object_decode _origin
    else
      nil
    end
  end

  def set_cache(key, value, expire = nil)
    set_object key, value
    expire key, expire.to_i if expire
  end

  def set_cache_expire_at(key, value, expire_at = nil)
    set_object key, value
    expireat key, expire_at.to_i if expire_at
  end

  private
  def object_encode(value)
    Base64.encode64(Marshal.dump(value))
  end

  def object_decode(value)
    Marshal.load(Base64.decode64(value))
  end
end

class Object
  # 深拷贝
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end

  def to_base64
    Base64.encode64(Marshal.dump(self))
  end

  def self.from_base64(base64)
    Marshal.load(Base64.decode64(base64))
  end
end

class ActiveModel::Errors
  def hash_messages
    messages.collect {|key, value|
      [key, full_messages_for(key)]
    }.to_h
  end
end