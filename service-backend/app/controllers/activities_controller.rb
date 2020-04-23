class ActivitiesController < ApplicationController
  before_action :login_only, :init # 对所有的方法前会检查是否登录以及进行当前用户的赋值
  before_action :check_activity, only: [:follow_activity, :unfollow_activity, :like_activity, :dislike_activity, :information]
  # only子句指定某些方法前执行检查方法
  def check_activity # 检查输入的活动id是否真的存在
    @activity = Activity.find_by(id: params[:activity_id]) # 查询语句,find类查询语句只能返回一个结果(首个结果)
    if @activity.nil?
      render status: 404, json: response_json(
          false,
          code: ActivityErrorCode::ACTIVITY_NOT_EXIST,
          message: "Activity not found"
      )
      false
    else
      true
    end
  end

  #before_action :init

  def init
    @user = current_user
    # @user = User.first
  end

  #获取活动的详细信息
  def information
    club_list = @activity.clubs # ROR特性,从model中直接读取相应的多对多映射值,也可以通过查映射表的方法获得
    host_clubs = []
    club_list.each do |club| # list.each do |sym|语句相当于for sym in club_list,循环遍历
      host_clubs.append(
          {
              club_id: club.id,
              club_name: club.name,
              club_logo: club.icon_url
          }
      )
    end
    render status: 200, json: response_json(# 使用顶层封装好的返回规范格式,将数据data层进行封装即可
        true,
        message: "Get activity success",
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
            #other为beta新加内容
        }
    )
  end

  #获取按照点赞人数排序的活动{id: id,like_count:like_count}列表
  def sortby_like_count_activity_id_list
    activity_id_list = Activity.ids
    #follow_hash_count = UserFollowActivity.where(activity_id: activity_id_list).group(:activity_id).count
    like_hash_count = UserProActivity.where(activity_id: activity_id_list).group(:activity_id).count
    sorted_list = []
    activity_id_list.each do |id|
      sorted_list.append(
          {
              id: id,
              like_count: like_hash_count[id] || 0
          }
      )
    end
    sorted_list.sort_by! {|item| item[:like_count]}.reverse!
    sorted_list
  end

  #按照点赞人数排序,返回活动的相关信息
  def hottest_activities_list
    count = params[:count].to_i
    # id_list = sortby_like_count_activity_id_list.map {|item| item[:id]}
    # result = []
    #activity_list = Activity.where(id: id_list).where("start_time > ?", Time.now)[0..count]
    activity_list = sortby_like_count_activity_id_list
                        .map {|item| Activity.find_by(id: item[:id]).get_activity_information_hash}
    # activity_list = Activity.where(id: id_list)[0..count]
    # activity_list.each do |activity|
    #   result.append(activity.get_activity_information_hash)
    # end
    render status: 200, json: response_json(
        true,
        message: "Get hottest activities successfully!",
        data:
            {
                activities: activity_list[0..count]
            }
    )
  end

  # 按照请求的页编码以及页返回当前Club的活动(按照时间顺序返回)
  def club_activities_list_per_page
    id = params[:club_id]
    club = Club.find_by(id: id)
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    count = club.activities.count
    if page > (count * 1.0 / per_page).ceil
      render status: 400, json: response_json(
          false,
          code: ActivityErrorCode::PAGE_OUT_OF_RANGE,
          message: "Page out of range"
      )
    else
      activity_id_list = club.activities.ids
      is_follow_hash = UserFollowActivity.where(user_id: @user.id, activity_id: activity_id_list).group(:activity_id).count
      follow_hash_count = UserFollowActivity.where(activity_id: activity_id_list).group(:activity_id).count
      is_like_hash = UserProActivity.where(user_id: @user.id, activity_id: activity_id_list).group(:activity_id).count
      like_hash_count = UserProActivity.where(activity_id: activity_id_list).group(:activity_id).count
      start_pos = (page - 1) * per_page
      result_list = activity_id_list[start_pos..(start_pos + per_page - 1)]
      is_end = (page == (count * 1.0 / per_page).ceil)
      result = []
      result_list.each do |id|
        host_clubs = []
        activity = Activity.find_by(id: id)
        activity.clubs.each do |club|
          host_clubs.append(
              {
                  club_id: club.id,
                  club_name: club.name,
                  club_logo: club.icon_url
              }
          )
        end
        result.append(
            {
                activity_detail: activity.get_activity_information_hash,
                host_clubs: host_clubs,
                is_like: !(is_like_hash[activity.id].nil?),
                like_count: like_hash_count[activity.id] || 0,
                is_follow: !(is_follow_hash[activity.id].nil?),
                followers_count: follow_hash_count[activity.id] || 0
            }
        )
      end
      render status: 200, json: response_json(
          true,
          data:
              {
                  activities: result,
                  reach_end: is_end,
                  total_count: count
              }
      )
    end
  end

  #用户关注的活动 按页获取 按开始时间排序
  def followed_list_per_page
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    count = @user.followed_activities.ids.count
    if page > (count * 1.0 / per_page).ceil
      render status: 400, json: response_json(
          false,
          code: ActivityErrorCode::PAGE_OUT_OF_RANGE,
          message: "Page out of range!"
      )
    else
      start_pos = (page - 1) * per_page
      is_end = (page == (count * 1.0 / per_page).ceil)
      activity_list = @user.followed_activities.order(start_time: :desc, id: :desc)
                          .limit(per_page).offset(start_pos)
      id_list = activity_list.map(&:id)
      result = []
      follow_hash_count = UserFollowActivity.where(activity_id: id_list).group(:activity_id).count
      like_hash_count = UserProActivity.where(activity_id: id_list).group(:activity_id).count
      is_like_hash = UserProActivity.where(user_id: @user.id).group(:activity_id).count
      activity_list.each do |activity|
        id = activity.id
        host_clubs = []
        activity.clubs.each do |club|
          host_clubs.append(
              {
                  club_id: club.id,
                  club_name: club.name,
                  club_logo: club.icon_url
              }
          )
        end
        result.append(
            {
                activity_detail: activity.get_activity_information_hash,
                host_clubs: host_clubs,
                followers_count: follow_hash_count[id] || 0,
                like_count: like_hash_count[id] || 0,
                is_like: !is_like_hash[id].nil?
            }
        )
      end
      render status: 200, json: response_json(
          true,
          message: "Get follow activities list successfully!",
          data:
              {
                  activities: result,
                  reach_end: is_end,
                  total_count: count
              }
      )
    end
  end

  # 用户新关注一个活动
  def follow_activity
    @user.follow_activity(@activity)
  end

  # 用户取消关注一个活动
  def unfollow_activity
    @user.unfollow_activity(@activity)
  end

  # 用户点赞一个活动
  def like_activity
    @user.pro_activity(@activity)
  end

  #用户取消点赞一个活动
  def dislike_activity
    @user.unpro_activity(@activity)
  end

  #按照请求的页码数以及每页数目返回活动相关列表(按照点赞的人数进行排序)
  def list_hot_sorted_per_page
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    count = Activity.count
    if page > (count * 1.0 / per_page).ceil
      render status: 400, json: response_json(
          false,
          code: ActivityErrorCode::PAGE_OUT_OF_RANGE,
          message: "Page out of range"
      )
    else
      activity_id_likecount_list = sortby_like_count_activity_id_list
      is_follow_hash = UserFollowActivity.where(user_id: @user.id).group(:activity_id).count
      follow_hash_count = UserFollowActivity.group(:activity_id).count
      is_like_hash = UserProActivity.where(user_id: @user.id).group(:activity_id).count
      start_pos = (page - 1) * per_page
      result_list = activity_id_likecount_list[start_pos..(start_pos + per_page - 1)]
      is_end = (page == (count * 1.0 / per_page).ceil)
      result = []
      result_list.each do |item|
        host_clubs = []
        activity = Activity.find_by(id: item[:id])
        activity.clubs.each do |club|
          host_clubs.append(
              {
                  club_id: club.id,
                  club_name: club.name,
                  club_logo: club.icon_url
              }
          )
        end
        result.append(
            {
                activity_detail: activity.get_activity_information_hash,
                host_clubs: host_clubs,
                is_like: !(is_like_hash[activity.id].nil?),
                like_count: item[:like_count],
                is_follow: !(is_follow_hash[activity.id].nil?),
                followers_count: follow_hash_count[activity.id] || 0
            }
        )
      end
      render status: 200, json: response_json(
          true,
          data:
              {
                  activities: result,
                  reach_end: is_end,
                  total_count: count
              }
      )
    end
  end

  #按照活动开始的时间进行排序
  def list_time_sorted_per_page
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    count = Activity.count
    if page > (count * 1.0 / per_page).ceil
      render status: 400, json: response_json(
          false,
          code: ActivityErrorCode::PAGE_OUT_OF_RANGE,
          message: "Page out of range"
      )
    else
      follow_hash_count = UserFollowActivity.group(:activity_id).count
      is_follow_hash = UserFollowActivity.where(user_id: @user.id).group(:activity_id).count
      like_hash_count = UserProActivity.group(:activity_id).count
      is_like_hash = UserProActivity.where(user_id: @user.id).group(:activity_id).count
      result = []
      start_pos = (page - 1) * per_page
      is_end = (page == (count * 1.0 / per_page).ceil)
      activity_list = Activity.order(start_time: :desc, id: :desc).limit(per_page).offset(start_pos)
      activity_list.each do |activity|
        host_clubs = []
        activity.clubs.each do |club|
          host_clubs.append(
              {
                  club_id: club.id,
                  club_name: club.name,
                  club_logo: club.icon_url
              }
          )
        end
        result.append(
            {
                activity_detail: activity.get_activity_information_hash,
                host_clubs: host_clubs,
                followers_count: follow_hash_count[activity.id] || 0,
                is_follow: !(is_follow_hash[activity.id].nil?),
                like_count: like_hash_count[activity.id] || 0,
                is_like: !(is_like_hash[activity.id].nil?)
            }
        )
      end
      render status: 200, json: response_json(
          true,
          data:
              {
                  activities: result,
                  reach_end: is_end,
                  total_count: count
              }
      )
    end
  end

  #返回活动列表的快照
  def list_snapshot
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    count = Activity.count
    if page > (count * 1.0 / per_page).ceil
      render status: 400, json: response_json(
          false,
          code: ActivityErrorCode::PAGE_OUT_OF_RANGE,
          message: "Page out of range"
      )
    else
      result = []
      start_pos = (page - 1) * per_page
      #todo:
      is_end = (page == (count * 1.0 / per_page).ceil)
      activity_list = Activity.order(start_time: :desc, id: :desc).limit(per_page).offset(start_pos)
      activity_list.each do |activity|
        host_clubs = []
        activity.clubs.each do |club|
          host_clubs.append(
              {
                  club_id: club.id,
                  club_name: club.name,
                  club_logo: club.icon_url,
                  club_category: club.club_category
              }
          )
        end
        result.append(
            {
                id: activity.id,
                name: activity.name,
                host_clubs: host_clubs
            }
        )
      end
      render status: 200, json: response_json(
          true,
          data:
              {
                  activities: result,
                  reach_end: is_end,
                  total_count: count
              }
      )
    end
  end

  def get_wxacode
    activity_id = params[:activity_id]
    response = WechatClient.get_wxacode activity_id

    errcode = response.respond_to?(:key?) && response[:errcode] || WechatErrorCode::SUCCESS
    if errcode == WechatErrorCode::SUCCESS #请求成功
      render status: 200, json: response_json(
          true,
          message: "Get wxacode succesfully!",
          data:
              {
                  wxacode: response
              }
      )
    else #请求失败
      errcode = response[:errcode]
      errmsg = response[:errmsg]
      render status: 400, json: response_json(
          false,
          message: "wxacode wechat request failed!",
          data: {
              code: errcode,
              message: errmsg
          }
      )
    end
  end

  protected

  include WechatHelper
  extend WechatHelper

end
