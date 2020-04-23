class MessagesController < ApplicationController
  before_action :login_only, :init

  include MessagesHelper
  extend MessagesHelper

  def init
    @user = current_user
  end

  def update_form_id
    form_id = params[:form_id]
    user_key = TemplateMessageHelper.user_to_key(@user)
    current_form_ids = $redis_cache.get_object(user_key).to_a
    # 此处为了避免边界值问题，把过期时间设置为了6天，实际上小程序的form_id可以有7天的有效期
    $redis_cache.set_cache(user_key, current_form_ids << {form_id: form_id, expire_time: Time.now + 6.days})
    render status: 200, json: response_json(
        true,
        message: 'Form id update success'
    )
  end
end
