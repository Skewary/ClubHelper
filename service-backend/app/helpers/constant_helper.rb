module ConstantHelper
  module ApplicationConstants
    def constant_keys # 获取常数键
      self.constants
    end

    def constant_values # 获取常数值
      self.constant_keys.collect {|sym| self.const_get(sym)}
    end

    def constant_hash # 获取常数键值hash
      self.constant_keys.collect {|sym| [sym, self.const_get(sym)]}.to_h
    end

    def include_key?(key) # 判断是否包含key
      self.constants.include?(key)
    end

    def include_value?(value) # 判断是否包含数值
      self.constant_values.include?(value)
    end

    def [](data)
      key_to_value(data) || value_to_key(data)
    end

    def key_to_value(key) # key转数值
      begin
        self.const_get key
      rescue
        nil
      end
    end

    def anycase_key_to_value(key) # 任意大小写key转数值
      key_to_value key.to_s.upcase.to_sym
    end

    def anycase_key_array_to_values(key_array) # 任意大小写key数组转为值数组
      (key_array || [])
          .collect {|key| anycase_key_to_value(key)}
          .select {|value| !value.nil?}
    end

    def value_array_to_downcase_keys(value_array) # 值
      (value_array || [])
          .collect {|value| value_to_downcase_key(value)}
          .select {|key| !key.nil?}
    end

    def value_to_key(value) # 数值转symbol格式key
      self.constant_keys.each do |key|
        return key if self.const_get(key) == value
      end
      nil
    end

    def value_to_downcase_key(value) # 数值转小写symbol格式key
      _key = value_to_key value
      if _key.nil?
        nil
      else
        _key.to_s.downcase.to_sym
      end
    end
  end
end
