class ClubsController < ApplicationController
  before_action :login_only, :init
  before_action :check_club, only: [:information, :brief, :members_list, :follow_club, :unfollow_club, :news]
  before_action :judge_admin, only: [:members_list]


  def check_club# 检查输入club id对应的社团是否存在
    id = params[:club_id]
    @club = Club.find_by(id: id)
    if @club.nil?
      render status: 404, json: response_json(
          false,
          code: ClubErrorCode::CLUB_NOT_EXIST,
          message: "Club not found"
      )
      false
    else
      true
    end
  end

  def init
    @user = current_user
  end

  def judge_admin #检查是否是社团的管理员
    if check_administrator(@user.id, @club.id)
      true
    else
      false
    end
  end

  def club_not_found # 返回社团不存在的错误报告信息
    render status: 404, json: response_json(
        false,
        code: ClubErrorCode::CLUB_NOT_EXIST,
        message: "Club not found"
    )
  end

  def followed_list # 返回当前用户关注的社团的简略信息
    count_hash = UserFollowClub.group(:club_id).count
    #list = @user.followed_clubs.map(&:brief_information)
    result = []
    list = @user.followed_clubs
    list.each do |club|
      info = club.brief_information
      info[:followers_count] = count_hash[club.id] || 0
      result.append(info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get follow clubs list successfully!",
        data:
            {
                clubs: result
            }
    )
  end

  def joined_list # 返回当前用户加入的社团的简略信息
    #list = @user.joined_clubs.map(&:detail_information)
    result = []
    count_hash = UserJoinClub.group(:club_id).count
    list = @user.joined_clubs
    list.each do |club|
      info = club.brief_information
      info[:followers_count] = count_hash[club.id] || 0
      result.append(info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get join clubs list successfully!",
        data:
            {
                clubs: result
            }
    )
  end

  def find_by_name # 输入社团名返回对应的社团的详细信息
    name = params[:club_name]
    @club = Club.find_by(name: name) #注意加上@
    if @club.nil?
      club_not_found
    else
      result = @club.brief_information
      result[:followers_count] = @club.follow_users.count
      render status: 200, json: response_json(
          true,
          message: "Get club success",
          data: result
      )
    end
  end

  def information # 返回详细信息
    data = @club.detail_information
    data.store(:is_member, @user.is_member_of_club?(@club))
    data.store(:is_follower, @user.is_follower_of_club?(@club))
    render status: 200, json: response_json(
        true,
        message: "Get club success",
        data: data
    )
  end

  def brief #返回社团的简略信息
    result = @club.brief_information
    result[:followers_count] = @club.follow_users.count
    render status: 200, json: response_json(
        true,
        message: "Get club success",
        data: result
    )
  end

  def news #返回当前社团的所有新闻
    page = params[:page].to_i
    start_pos = (page - 1) * 10
    end_pos = (page) * 10
    if (!@club.is_related_to_wechat)
      render status: 400, json: response_json(
          true,
          message: "club is not related to wechat",
          data:
              {
                  news_list: [],
                  reach_end: true
              }
      )
      return
    end
    list = @club.articles.order(publish_time: :desc).map(&:get_article_information_hash)
    news_length = list.length
    is_end = (news_length <= end_pos) #到达尾部
    if (news_length <= end_pos)
      end_pos = news_length
    end
    render status: 200, json: response_json(
        true,
        message: "Get news success",
        data:
            {
                news_list: list[start_pos...end_pos],
                reach_end: is_end
            }
    )
  end


  def get_all_clubs# 获得所有社团所有关注用户的列表
    count_hash = UserFollowClub.group(:club_id).count#采用先group分组,这样不需要每次查询一个club的时候都进行一次整个表的扫描,解决了1+N问题,转变为1+1问题
    all_club = Club.all
    club_list = []
    all_club.each do |club|
      info = club.brief_information
      info[:followers_count] = count_hash[club.id] || 0
      club_list.append(info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get all clubs successfully",
        data:
            {
                clubs: club_list
            }
    )
  end

  def request_join_club# 用户发出一个请求加入社团
    begin
      club_id = params[:club_id]
      message = params[:content]
      user = current_user
      check_join_club = !UserJoinClub.find_by(club_id: club_id, user_id: user.id).nil?
      check_join_request_club = !UserJoinClubRequest.find_by(club_id: club_id, user_id: user.id, status: UserJoinClubRequest::Status::CONFIRMING).nil?
      #判断是否入社
      if check_join_club || check_join_request_club
        render status: 400, json: response_json(
            false,
            message: "User already join club."
        )
      else
        record = UserJoinClubRequest.create!(user_id: user.id, club_id: club_id, message: message, status: UserJoinClubRequest::Status::CONFIRMING)
        render status: 200, json: response_json(
            true,
            message: "Send join club request success!"
        )
      end
    rescue Exception => e
      render status: 400, json: response_json(
          false,
          message: e.message,
          code: ClubErrorCode::JOIN_CLUB_FAILED
      )
    end
  end

  def join_requests_list#返回用户已经申请加入但未得到应答的社团列表
    request_list = UserJoinClubRequest.where(user_id: @user.id)
    result = []
    request_list.each do |record|
      has_leader = UserJoinClub.find_by(club_id: record.club.id, role: UserJoinClub::Role::MASTER)
      leader = has_leader.nil? ? nil : has_leader.user.get_user_info
      result.append(
          {
              club_information: record.club.detail_information,
              status: UserJoinClubRequest::Status.value_to_key(record.status),
              message: record.message,
              time: activity_time(record.created_at),
              club_leader: leader
          }
      )
    end
    render status: 200, json: response_json(
        true,
        message: "get requests list success!",
        data: {
            requests: result
        }
    )
  end

  def members_list# 返回当前社团的社员信息
    result = @club.user_join_clubs.order(role: :desc)
    list = []
    result.each do |record|
      user = User.find_by(id: record.user_id)
      list.append(
          {
              user_information: user.get_user_info,
              role: UserJoinClub::Role.value_to_key(record.role)
          }
      )
    end
    render status: 200, json: response_json(
        true,
        message: "Get members list success!",
        data: {
            users: list
        }
    )
  end

  def follow_club# 关注一个社团
    @user.follow_club(@club)
  end

  def unfollow_club# 取消关注一个社团
    @user.unfollow_club(@club)
  end

end
