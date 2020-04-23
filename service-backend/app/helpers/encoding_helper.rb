module EncodingHelper
  def filter_four_byte_chars(inp) # 过滤4字节utf8
    inp.to_s.each_char.select {|c| c.bytes.count < 4}.join("")
  end
end
