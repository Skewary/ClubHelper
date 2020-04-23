class SessionController < ApplicationController
  before_action :login_only, only: [:logout, :current, :register_as_student, :set_avatar]
  before_action :unlogin_only, only: [:login, :login_wechat]

  def login # 账户密码登录
    username = params[:username]
    user = User.find_by_username_or_email username
    password = params[:password]

    if user && user.authenticate(password)
      if_remember = params[:remember].to_s.downcase == "yes"
      if user.is_normal?
        log_in user, if_remember
        render status: 200, json: response_json(
            true,
            message: "Login success!"
        )
      else
        render status: 403, json: response_json(
            false,
            code: UserErrorCode::USER_LOCKED,
            message: "User locked."
        )
      end
    else
      render status: 403, json: response_json(
          false,
          code: UserErrorCode::USER_PASSWORD_WRONG,
          message: "User wrong password or account not exist."
      )
    end
  end

  def register # 传统注册
    user = User.new
    user.username = params[:username]
    user.nickname = params[:nickname]
    user.real_name = params[:real_name]
    user.student_id = params[:student_id]
    user.email = params[:email]
    user.gender = User::Gender.anycase_key_to_value(params[:gender])
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    user.open_id = nil

    if user.save # 用户保存成功
      render status: 200, json: response_json(
          true
      )
    else
      render status: 400, json: response_json(
          false,
          code: UserErrorCode::USER_CREATE_FAILED,
          message: "User create failed.",
          data: {
              errors: user.error_messages,
          }
      )
    end
  end

  def login_wechat # 微信登录入口
    code = params[:code]
    response = WechatClient.jscode_to_session code

    errcode = response[:errcode] || WechatErrorCode::SUCCESS
    if errcode == WechatErrorCode::SUCCESS
      open_id = response[:openid]
      session_key = response[:session_key]
      union_id = response[:unionid]

      user = User.find_by(open_id: open_id)
      if user
        if user.is_normal?
          user.open_id = open_id
          user.session_key = session_key
          user.union_id = union_id
          user.save

          log_in user, true
          render status: 200, json: response_json(
              true,
              message: "Login success!"
          )
        else
          render status: 403, json: response_json(
              false,
              code: UserErrorCode::USER_LOCKED,
              message: "User locked."
          )
        end
      else
        render status: 403, json: response_json(
            false,
            code: UserErrorCode::USER_NOT_EXIST,
            message: "User not exist or not bind with wechat."
        )
      end
    else # 微信访问失败
      errcode = response[:errcode]
      errmsg = response[:errmsg]
      render status: 400, json: response_json(
          false,
          code: SessionErrorCode::SESSION_WECHAT_REQUEST_FAILED,
          message: "Session wechat request failed!",
          data: {
              code: errcode,
              message: errmsg
          }
      )
    end
  end

  def bind_wechat # 微信账号绑定
    username = params[:username]
    user = User.all.find_by_username_or_email(username)
    password = params[:password]

    if user.open_id
      render status: 400, json: response_json(
          false,
          code: UserErrorCode::USER_ALREADY_BIND_WECHAT,
          message: "User already bind wechat"
      )
      return
    end

    code = params[:code]
    response = WechatClient.jscode_to_session code

    errcode = response[:errcode] || WechatErrorCode::SUCCESS
    if errcode == WechatErrorCode::SUCCESS # 微信请求成功
      if user.authenticate(password) && user.is_normal? # 密码正确 && 账号正常
        user.open_id = response[:openid]
        user.session_key = response[:session_key]
        user.union_id = response[:unionid]

        if user.save # 用户保存成功
          render status: 200, json: response_json(
              true
          )
        else # 绑定失败
          render status: 400, json: response_json(
              false,
              code: UserErrorCode::USER_UPDATE_FAILED,
              message: "User update failed.",
              data: {
                  errors: user.error_messages,
              }
          )
        end
      else # 密码错误 || 账号被锁
        render status: 400, json: response_json(
            false,
            code: UserErrorCode::USER_PASSWORD_WRONG,
            message: "User password wrong or locked."
        )
      end
    else # 微信请求失败
      errcode = response[:errcode]
      errmsg = response[:errmsg]
      render status: 400, json: response_json(
          false,
          code: SessionErrorCode::SESSION_WECHAT_REQUEST_FAILED,
          message: "Session wechat request failed!",
          data: {
              code: errcode,
              message: errmsg
          }
      )
    end
  end

  def register_wechat # 微信入口注册
    code = params[:code]
    response = WechatClient.jscode_to_session code

    errcode = response[:errcode] || WechatErrorCode::SUCCESS
    if errcode == WechatErrorCode::SUCCESS # 微信请求成功
      user = User.new
      user.username = response[:openid]
      user.nickname = params[:nickname] if params[:nickname].present?

      user.open_id = response[:openid]
      user.session_key = response[:session_key]
      user.union_id = response[:unionid]
      if user.save # 用户信息保存成功
        render status: 200, json: response_json(
            true
        )
      else # 用户信息保存失败
        render status: 400, json: response_json(
            false,
            code: UserErrorCode::USER_CREATE_FAILED,
            message: "User create failed.",
            data: {
                errors: user.error_messages,
            }
        )
      end
    else # 微信请求失败
      errcode = response[:errcode]
      errmsg = response[:errmsg]
      render status: 400, json: response_json(
          false,
          code: SessionErrorCode::SESSION_WECHAT_REQUEST_FAILED,
          message: "Session wechat request failed!",
          data: {
              code: errcode,
              message: errmsg
          }
      )
    end
  end

  def logout # 登出
    forget current_user
    log_out current_user
    render status: 200, json: response_json(
        true
    )
  end

  def register_as_student # 学生信息认证
    user = current_user
    if user.is_guest?
      user.real_name = params[:real_name]
      user.student_id = params[:student_id]
      user.email = params[:email]
      user.gender = User::Gender.anycase_key_to_value(params[:gender])

      college = College.find_by(code: params[:college_code])
      if college
        user.college_id = college.id
      else
        render status: 404, json: response_json(
            false,
            code: UserErrorCode::USER_COLLEGE_NOT_EXIST,
            message: "User college not exist."
        )
        return
      end

      political_status = PoliticalStatus.find_by(code: params[:political_status_code])
      if political_status
        user.political_status_id = political_status.id
      else
        render status: 404, json: response_json(
            false,
            code: UserErrorCode::USER_POLITICAL_STATUS_NOT_EXIST,
            message: "User political status not exist."
        )
        return
      end

      user.role = User::Role::STUDENT
      if user.save
        render status: 200, json: response_json(
            true
        )
      else
        render status: 400, json: response_json(
            false,
            code: UserErrorCode::USER_UPDATE_FAILED,
            message: "User update failed.",
            data: {
                errors: user.error_messages,
            }
        )
      end

    else
      render status: 400, json: response_json(
          false,
          code: UserErrorCode::USER_NOT_A_GUEST,
          message: "User is not a guest."
      )
    end
  end

  def current # 当前用户信息
    user = current_user
    render status: 200, json: response_json(
        true,
        data: {
            user: {
                id: user.id,
                avatar_url: user.avatar_url,
                nickname: user.nickname,
                username: user.username,
                email: user.email,
                role: User::Role.value_to_downcase_key(user.role),
                open_id: user.open_id,
            },
        }
    )
  end

  def set_avatar # 设置头像url
    user = current_user
    user.avatar_url = params[:avatar_url]
    if user.save
      render status: 200, json: response_json(
          true
      )
    else
      render status: 400, json: response_json(
          false,
          code: SessionErrorCode::SESSION_SET_AVATAR_FAILED,
          message: "Set avatar failed."
      )
    end
  end

  protected
  include WechatHelper
  extend WechatHelper
end
