class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
  def login_only # 需要先登录,许多需要用到当前用户信息的借口都需要先进行是否登录的检查
    if current_user
      true
    else
      render status: 403, json: response_json(
          false,
          code: AccessErrorCode::ACCESS_NOT_LOGIN,
          message: "Please login first."
      )
      false
    end
  end

  def unlogin_only # 需要未登录,判断是否 当前用户没有登陆的状态
    if !current_user
      true
    else
      render status: 400, json: response_json(
          false,
          code: AccessErrorCode::ACCESS_ALREADY_LOGIN,
          message: "Already logged in."
      )
      false
    end
  end

  def root_only # 需要root权限,判断用户是否获得root权限
    if login_only
      if current_user.is_root?
        true
      else
        render status: 403, json: response_json(
            false,
            code: AccessErrorCode::ACCESS_DENIED,
            message: "Access denied."
        )
        false
      end
    else
      false
    end
  end

  protected
  include GlobalHelper
  extend GlobalHelper
end
