module ApplicationHelper
  def response_json(success, code: nil, message: nil, data: nil)
    success = !!success
    {
        success: success,
        code: code || (success ? GlobalErrorCode::SUCCESS : GlobalErrorCode::COMMON_ERROR),
        message: message || (success ? "Success." : "Failed"),
        data: data,
    }
  end

  module WechatErrorCode
    extend ConstantHelper::ApplicationConstants

    BUSY = -1
    SUCCESS = 0
    INVALID_CODE = 40029
    TOO_FREQUENT = 45011
  end

  module GlobalErrorCode
    extend ConstantHelper::ApplicationConstants

    COMMON_ERROR = -1
    SUCCESS = 0
    SYSTEM_ERROR = 1
  end

  module SessionErrorCode
    extend ConstantHelper::ApplicationConstants

    SESSION_WECHAT_REQUEST_FAILED = 100
    SESSION_USER_SAVE_FAILED = 101
    SESSION_LOGIN_FAILED = 102
    SESSION_SET_AVATAR_FAILED = 103
  end

  module AccessErrorCode
    extend ConstantHelper::ApplicationConstants

    ACCESS_NOT_LOGIN = 200
    ACCESS_ALREADY_LOGIN = 201
    ACCESS_DENIED = 202
  end

  module UserErrorCode
    extend ConstantHelper::ApplicationConstants

    USER_NOT_EXIST = 300
    USER_PASSWORD_WRONG = 301
    USER_LOCKED = 302
    USER_CREATE_FAILED = 303
    USER_UPDATE_FAILED = 304
    USER_ALREADY_BIND_WECHAT = 305
    USER_NOT_A_GUEST = 306
    USER_COLLEGE_NOT_EXIST = 307
    USER_POLITICAL_STATUS_NOT_EXIST = 308
    USER_UNIFIED_AUTHENTICATE_FAILED = 309
    USER_GENDER_NOT_EXIST = 310
    USER_PHONE_NUMBER_NOT_PROVIDED = 311
  end

  module ClubErrorCode
    extend ConstantHelper::ApplicationConstants

    CLUB_NOT_EXIST = 400
    JOIN_CLUB_FAILED = 401
  end

  module ActivityErrorCode
    extend ConstantHelper::ApplicationConstants

    ACTIVITY_NOT_EXIST = 500
    PAGE_OUT_OF_RANGE = 501
  end

  module ActivityCommentErrorCode
    extend ConstantHelper::ApplicationConstants

    COMMENT_CREATE_FAILED = 600
    COMMENT_PRO_FAILED = 601
    COMMENT_UNPRO_FAILED = 602
    PAGE_OUT_OF_RANGE = 603
  end

  module ClubCategoryErrorCode
    extend ConstantHelper::ApplicationConstants

    CATEGORY_NOT_EXIST = 700
  end

  module ClubManagementErrorCode
    extend ConstantHelper::ApplicationConstants

    USER_MANAGES_NO_CLUBS = 600
    CLUB_CREATE_FAILED = 601
    CLUB_NOT_EXIST = 602
    CLUB_UPDATE_FAILED = 603
    CLUB_DESTROY_FAILED = 604
    ACTIVITY_CREATE_FAILED = 605
    ACTIVITY_UPDATE_FAILED = 606
    ACTIVITY_NOT_EXIST = 607
    ARTICLE_CREATE_FAILED = 608
    ARTICLE_NOT_EXIST = 609
    UUID_NOT_EXIST = 610
    UUID_HAS_BEEN_USED = 611
    UUID_NOT_BIND = 612
    USER_DOESNT_MANAGE_THIS_CLUB = 613
    IMAGE_TOKEN_NOT_EXIST = 614
    HOST_CLUB_NOT_EXIST = 615
  end

  module ImageOperationErrorCode
    extend ConstantHelper::ApplicationConstants

    IMAGE_NOT_EXIST = 900
    IMAGE_UPLOAD_FAILED = 901
    IMAGE_SAVE_FAILED = 902
    IMAGE_URL_GET_FAILED = 903
    IMAGE_GET_BY_TOKEN_FAILED = 904
  end

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
    if time.nil?
      return ""
    end
    weekday_hash =
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

  def check_administrator(user_id, club_id) #检查是否有社团管理员或者社长权限
    record_admin = UserJoinClub.find_by(user_id: user_id, club_id: club_id, role: UserJoinClub::Role::ADMIN)
    record_master = UserJoinClub.find_by(user_id: user_id, club_id: club_id, role: UserJoinClub::Role::MASTER)
    if record_admin.nil? and record_master.nil?
      render status: 404, json: response_json(
          false,
          message: "User don't have administrator right!"
      ) and yield
      false
    end
    true
  end

  def check_master(user_id, club_id) # 检查是否有社长权限
    record = UserJoinClub.find_by(user_id: user_id, club_id: club_id, role: UserJoinClub::Role::MASTER)
    if record.nil?
      render status: 404, json: response_json(
          false,
          message: "User don't have master right!"
      ) and yield
      false
    end
    true
  end

end
