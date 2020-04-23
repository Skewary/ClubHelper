class ActivitiesEvaluateController < ApplicationController
  before_action :login_only, :init
  before_action :check_admin
  before_action :check_activity

  def get_evaluation
    club_list = @activity.clubs # ROR特性,从model中直接读取相应的多对多映射值,也可以通过查映射表的方法获得
    host_clubs = []
    club_list.each do |club| # list.each do |sym|语句相当于for sym in club_list,循环遍历
      host_clubs.append(
        club_id: club.id,
        club_name: club.name,
        club_logo: club.icon_url
      )
    end
    render status: 200, json: response_json( # 使用顶层封装好的返回规范格式,将数据data层进行封装即可
      true,
      message: 'Get activity success',
      data: {
        activity_detail: @activity.get_activity_information_hash,
        followers_count: @activity.follow_users.count,
        is_follow: @user.is_follower_of_activity?(@activity),
        is_like: @user.is_pro_activity?(@activity),
        like_count: @activity.pro_users.count,
        host_clubs: host_clubs,
        other:
              {
                introduction_article_title: @activity.introduction_article_title,
                introduction_article_url: @activity.introduction_article_url,
                retrospect_article_url: @activity.retrospect_article_url,
                retrospect_article_title: @activity.retrospect_article_title,
                message_push_time: @activity.message_push_time
              }
        # other为beta新加内容
      }
    )
  end

  def check_activity # 检查输入的活动id是否真的存在
    @activity = Activity.find_by(id: params[:activity_id]) # 查询语句,find类查询语句只能返回一个结果(首个结果)
    if @activity.nil?
      render status: 404, json: response_json(
        false,
        code: ActivityErrorCode::ACTIVITY_NOT_EXIST,
        message: 'Activity not found'
      )
      false
    else
      true
    end
  end

  def check_admin # 判断是不是管理员
    club_id = params[:club_id]
    check_administrator(@user.id, club_id) { return false }
    true
  end

  def init
    @user = current_user
  end
end
