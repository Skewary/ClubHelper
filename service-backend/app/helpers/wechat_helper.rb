module WechatHelper
  class WechatClient
    private

    include HTTParty
    base_uri $wechat_host
    APPID = $wechat_appid
    APPSEC = $wechat_secret
    APP_INFO = {
        appid: APPID,
        secret: APPSEC,
    }

    private

    def self.no_nil(**params) # 去除nil参数
      params.select {|key, value| !value.nil?}
    end

    def self.add_sid(**params) # 添加key && id
      no_nil(**(APP_INFO + params))
    end

    def self.sym_data(response) # 解析symbol格式数据
      JSON.parse response, symbolize_names: true
    end

    public

    # auth.code2Session
    # 登录凭证校验。通过 wx.login() 接口获得临时登录凭证 code 后传到开发者服务器调用此接口完成登录流程。
    def self.jscode_to_session(js_code)
      sym_data get "/sns/jscode2session", query: add_sid(
          js_code: js_code,
          grant_type: :authorization_code
      )
    end

    public

    # 获取小程序码，适用于需要的码数量极多的业务场景。通过该接口生成的小程序码，永久有效，数量暂无限制。
    def self.get_wxacode(activity_id)
      require 'base64'
      page = "pages/activity_details/activity_details"
      response = post "/wxa/getwxacodeunlimit?access_token=#{get_access_token}", body: no_nil(
          page: page,
          scene: activity_id
      ).to_json, headers: {'Content-Type' => 'application/json'}
      return Base64.strict_encode64(response.parsed_response)
    end

    # 从微信服务器获取access token，并将其值存储至redis中，每小时刷新一次
    def self.fetch_access_token
      response = get '/cgi-bin/token', query: add_sid(
          grant_type: :client_credential
      )
      response.parsed_response
    end

    # 从redis中获取最新的有效access token
    def self.get_access_token
      $redis_cache.get_object(:access_token)
    end

    # 从用户的form_id池中取出一个form_id，并清除掉已过期的form_id
    include MessagesHelper

    def self.get_form_id(user)
      user_key = TemplateMessageHelper.user_to_key(user)
      form_ids = $redis_cache.get_object(user_key).to_a.reject {|form_id| Time.now > form_id[:expire_time]}
      form_id = form_ids.shift.to_h[:form_id]
      $redis_cache.set_cache(user_key, form_ids)
      return form_id
    end

    # 发送模板消息
    def self.send_template_message(user, template_id, data = nil, page = nil)
      form_id = get_form_id(user)
      if form_id
        response = post "/cgi-bin/message/wxopen/template/send?access_token=#{get_access_token}", body: no_nil(
            touser: user.open_id,
            template_id: template_id,
            data: data,
            page: page,
            form_id: form_id
        ).to_json, headers: {'Content-Type' => 'application/json'}
        response = response.parsed_response
        return {
            err_code: response['errcode'],
            err_msg: response['errmsg']
        }
      else
        return {
            err_code: -1,
            err_msg: "User #{user.id} has no form id."
        }
      end
    end
  end
end
