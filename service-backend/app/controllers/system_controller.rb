class SystemController < ApplicationController
  before_action :login_only#判断当前用户是否处于已经登录的状态

  def system_time # 服务器系统时间
    time = Time.now
    render status: 200, json: response_json(
        true,
        data: {
            timestamp: time.to_i,
            time: strftime(time),
        }
    )
  end
end
