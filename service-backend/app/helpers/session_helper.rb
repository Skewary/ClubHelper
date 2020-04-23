module SessionHelper
  # 用户登录
  def log_in(user, _remember = true)
    session[:user_id] = user.id
    remember user if _remember
  end

  # 当前用户
  # noinspection RailsChecklist05
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user, false
        @current_user = user
      end
    end

    if @current_user && !@current_user.is_normal?
      log_out @current_user
      @current_user = nil
    end

    @current_user
  end


  # 是否登录
  def logged_in?
    current_user.present?
  end

  # 退出当前用户
  def log_out(user = current_user)
    forget user
    session.delete(:user_id)
    @current_user = nil
  end

  # 在持久会话中记住用户
  def remember(user = current_user)
    if user
      user.remember
      length = 7.days
      cookies.signed[:user_id] = {
          value: user.id,
          expires: length.from_now.utc
      }
      cookies[:remember_token] = {
          value: user.remember_token,
          expires: length.from_now.utc
      }
    end
  end

  # 忘记持久会话
  def forget(user = current_user)
    user.forget if user
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end


