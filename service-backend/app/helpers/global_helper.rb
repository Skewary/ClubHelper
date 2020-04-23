module GlobalHelper
  include ConstantHelper
  extend ConstantHelper
  include DigestHelper
  extend DigestHelper
  include RandomizeHelper
  extend RandomizeHelper
  include SessionHelper
  extend SessionHelper
  include ApplicationHelper
  extend ApplicationHelper

  def strftime(datetime) # 时间格式化
    datetime.strftime('%Y-%m-%d %H:%M:%S')
  end
end
