ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# RubyMine

require 'rails/test_help'
#require '../app/helpers/session_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include SessionHelper

  # Add more helper methods to be used by all tests here...
  #part1 将两个辅助函数加载过来准备测试
  def calculate_past_time(time) #输入起始时间，计算当前时间到之前时间的间隔
    past_sec = Time.now - time
    past_day = (past_sec / 3600 / 24).floor
    if past_day < 1
      past_hour = (past_sec / 3600).floor
      if past_hour == 0
        return "刚刚"
      else
        return (past_hour).to_s + "小时前"
      end
    elsif past_day <= 7
      return past_day.to_s + "天前"
    else #超过七天直接开始的日期
      return time.strftime('%m月%d日')
    end
  end

  def activity_time(time)
    weekday_hash=
        {
            Monday: "周一",
            Tuesday: "周二",
            Wednesday: "周三",
            Thursday: "周四",
            Friday: "周五",
            Saturday: "周六",
            Sunday: "周日",
        }
    prefix = time.strftime('%Y-%m-%d %H:%M ')
    #puts time.strftime("%A")
    return prefix + weekday_hash[time.strftime("%A").to_sym]
  end
end
