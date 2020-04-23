class UsersController < ApplicationController
  before_action :login_only, :init #, except: [:add_club_category, :add_club]
  before_action :guest_only, only: [:unified_authenticate]
  before_action :judge_admin, only: [:get_all_joining_user, :accept_member, :reject_member,
                                     :user_remove_member, :get_joining_user_info]
  before_action :judge_master, only: [:add_admin, :delete_admin, :show_all_admin]

  include UtilsHelper

  def init
    @user = current_user
  end

  def judge_admin#判断是不是管理员
    club_id = params[:club_id]
    check_administrator(@user.id, club_id) {return false}
    true
  end

  def judge_master#判断是不是社长
    club_id = params[:club_id]
    check_master(@user.id, club_id) {return false} # 检查社长权限
    true
  end

  def get_current_user_information#获得当前用户的信息
    render status: 200, json: response_json(
        true,
        message: "Get current user's information successfully!",
        data:
            {
                data: @user.get_user_info
            }
    )
  end

  def get_my_follow_club # 获得当前用户关注社团的简略信息
    club_list = []
    result_clubs = UserFollowClub.where(:user_id => @user.id)
    count_hash = UserFollowClub.group(:club_id).count
    result_clubs.each do |record|
      @club = Club.find_by(id: record.club_id)
      info = @club.brief_information
      info[:followers_count] = count_hash[@club.id]
      club_list.append(info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get user's following clubs successfully!",
        data:
            {
                data_list: club_list
            }
    )
  end

  def get_my_join_club # 获得当前参加社团的简略信息
    club_list = []
    result_clubs = UserJoinClub.where(:user_id => @user.id)
    count_hash = UserFollowClub.group(:club_id).count
    puts result_clubs.length
    result_clubs.each do |record|
      @club = Club.find_by(id: record.club_id)
      info = @club.brief_information
      info[:followers_count] = count_hash[@club.id]
      club_list.append(info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get user's joining clubs successfully!",
        data:
            {
                data_list: club_list
            }
    )
  end

  def get_my_follow_activity # 到那个用户关注的活动
    activity_list = []
    result_activities = UserFollowActivity.where(:user_id => @user.id)
    count_hash = UserFollowActivity.group(:activity_id).count
    result_activities.each do |record|
      @activity = Activity.find_by(id: record.activity_id)
      activity_info = @activity.get_activity_information_hash
      activity_info[:followers_count] = count_hash[@activity.id]
      activity_list.append(activity_info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get user's following activities successfully!",
        data:
            {
                data_list: activity_list
            }
    )
  end

  def get_my_join_activity # 当前用户报名参加的活动
    activity_list = []
    result_activities = UserJoinActivity.where(:user_id => @user.id)
    count_hash = UserJoinActivity.group(:activity_id).count
    result_activities.each do |record|
      @activity = Activity.find_by(id: record.activity_id)
      activity_info = @activity.get_activity_information_hash
      activity_info[:followers_count] = count_hash[@activity.id]
      activity_list.append(activity_info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get user's following activities successfully!",
        data:
            {
                data_list: activity_list
            }
    )
  end

  def add_my_follow_club #增加我的关注社团
    club_id = params[:club_id]
    UserFollowClub.find_or_create_by(
        club_id: club_id,
        user_id: @user.id
    )
    render status: 200, json: response_json(
        true,
        message: "Add user's following club successfully!"
    )
  end

  def remove_my_follow_club # 删除我的关注社团
    club_id = params[:club_id]
    record = UserFollowClub.find_by(
        club_id: club_id,
        user_id: @user.id
    )
    if record.nil?
      render status: 404, json: response_json(
          false,
          message: "User don't follow club!"
      )
    else
      record.destroy
      render status: 200, json: response_json(
          true,
          message: "Delete user's following club successfully!"
      )
    end
  end

  def add_my_follow_activity # 增加我关注的活动
    activity_id = params[:activity_id]
    UserFollowActivity.find_or_create_by(
        activity_id: activity_id,
        user_id: @user.id
    )
    render status: 200, json: response_json(
        true,
        message: "Add user's following activity successfully!"
    )
  end

  def remove_my_follow_activity # 删除我关注的活动
    activity_id = params[:activity_id]
    record = UserFollowActivity.find_by(
        activity_id: activity_id,
        user_id: @user.id
    )
    if record.nil?
      render status: 404, json: response_json(
          false,
          message: "User don't follow activity!"
      )
    else
      record.destroy
      render status: 200, json: response_json(
          true,
          message: "Delete user's following activity successfully!"
      )
    end
  end

  def add_admin # 社长增加管理员
    club_id = params[:club_id]
    user_id = params[:user_id]
    if user_id == @user.id.to_s
      render status: 404, json: response_json(
          false,
          message: "Master can not set himself the administrator!"
      )
      return
    end
    result = UserJoinClub.find_by(user_id: user_id, club_id: club_id)
    if result.nil? # 找不到社员记录
      UserJoinClub.create(user_id: user_id, club_id: club_id, role: UserJoinClub::Role::ADMIN)
      request = UserJoinClubRequest.find_by(user_id: user_id, club_id: club_id)
      if not request.nil?
        request.update(status: UserJoinClubRequest::Status::ACCEPTED)
      end
    else # 现在已经设社员就直接把role换成管理员
      result.update(role: UserJoinClub::Role::ADMIN)
    end
    render status: 200, json: response_json(
        true,
        message: "Add administrator successfully!"
    )
  end

  def delete_admin # 删除管理员,将相应的用户降为普通社员
    club_id = params[:club_id]
    user_id = params[:user_id]
    result = UserJoinClub.find_by(user_id: user_id, club_id: club_id, role: UserJoinClub::Role::ADMIN)
    if result.nil?
      render status: 404, json: response_json(
          false,
          message: "Target user is not the administrator of this club!"
      )
    else
      result.update(role: UserJoinClub::Role::MEMBER)
      render status: 200, json: response_json(
          true,
          message: "Remove administrator successfully!"
      )
    end

  end

  def show_all_admin # 查看所有管理员
    club_id = params[:club_id]
    record_list = UserJoinClub.where(club_id: club_id, role: UserJoinClub::Role::ADMIN)
    user_list = []
    record_list.each do |record|
      info = record.user.get_user_info
      info[:admin_list] = record.user.get_admin_list
      user_list.append(info)
    end

    render status: 200, json: response_json(
        true,
        message: "Get all administrator of this club successfully!",
        data:
            {
                users: user_list
            }
    )
  end

  def get_user_info # 准备增加管理员的时候添加的相关信息,普通借口查询用户信息
    user_id = params[:user_id]
    user = User.find_by(id: user_id)
    if user.nil?
      render status: 404, json: response_json(
          false,
          message: "User doesn't exist!"
      )
    end
    info = user.get_user_info
    info[:admin_list] = user.get_admin_list
    render status: 200, json: response_json(
        true,
        message: "Get user information successfully!",
        data:
            info
    )
  end

  def get_all_joining_user # 某个社团当前正在申请入社的所有用户信息id列表(管理员可见)
    club_id = params[:club_id]
    user_id_list = []
    record_list = UserJoinClubRequest.where(club_id: club_id, status: UserJoinClubRequest::Status::CONFIRMING)
    record_list.each do |record|
      info = record.user.get_user_info
      info[:reason] = record.message
      user_id_list.append(info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get all joining users of this club  successfully!",
        data:
            {
                joining_users: user_id_list
            }
    )

  end

  def accept_member # 社长或管理员批准入社
    club_id = params[:club_id]
    user_id = params[:user_id]
    record = UserJoinClubRequest.find_by(club_id: club_id, user_id: user_id, status: UserJoinClubRequest::Status::CONFIRMING)
    if record.nil?
      render status: 404, json: response_json(
          false,
          message: "User doesn't apply for joining this club!"
      )
    else
      record.update(status: UserJoinClubRequest::Status::ACCEPTED)#首先讲当前入社信息转换成通过
      join_record = UserJoinClub.find_or_create_by(user_id: user_id, club_id: club_id)#无论是不是已经有过入社记录,都创建一个
      join_record.update(role: UserJoinClub::Role::MEMBER)#讲对应的状态信息变为member成员
      render status: 200, json: response_json(
          true,
          message: "Accept a club member successfully!"
      )
    end
  end

  def reject_member # 社长社员拒绝入社请求
    club_id = params[:club_id]
    user_id = params[:user_id]
    record = UserJoinClubRequest.find_by(club_id: club_id, user_id: user_id, status: UserJoinClubRequest::Status::CONFIRMING)
    if record.nil?
      render status: 404, json: response_json(
          false,
          message: "User doesn't apply for joining club!"
      )
    else
      record.update(status: UserJoinClubRequest::Status::REJECTED)
      render status: 200, json: response_json(
          true,
          message: "Reject a club member successfully!"
      )
    end
  end

  def user_remove_member # 社长以及管理员强制删除成员
    club_id = params[:club_id]
    user_id = params[:user_id]
    record = UserJoinClub.find_by(club_id: club_id, user_id: user_id)
    if record.nil?
      render status: 404, json: response_json(
          false,
          message: "User isn't a member of club!"
      )
    else
      record.destroy
      render status: 200, json: response_json(
          true,
          message: "Remove a club member successfully!"
      )
    end
  end

  def get_joining_user_info # 社长用于查找希望加入社团的用户的信息
    club_id = params[:club_id]
    user_id = params[:user_id]
    record = UserJoinClubRequest.find_by(club_id: club_id, user_id: user_id, status: UserJoinClubRequest::Status::CONFIRMING)
    if record.nil?
      render status: 404, json: response_json(
          false,
          message: "User don't apply for joining club!"
      )
    else
      info = record.user.get_user_info
      info[:admin_list] = record.user.get_admin_list
      render status: 200, json: response_json(
          true,
          message: "Remove a club member successfully!",
          data:
              {
                  user_info: info,
                  reason: record.message # 入社申请理由
              }
      )
    end
  end

  def all_admin_clubs # 当前用户为管理员的所有社团id列表
    count_hash = UserFollowClub.group(:club_id).count
    club_list = []
    record_list = UserJoinClub.where(user_id: @user.id, role: UserJoinClub::Role::ADMIN)
    record_list.each do |record|
      brief_info = record.club.brief_information
      brief_info[:followers_count] = count_hash[record.club.id] || 0
      club_list.append(brief_info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get my admin clubs successfully!",
        data:
            {
                admin_clubs: club_list
            }
    )

  end

  def apply_proprieter # 申请社长,而且一旦成功会把上一任卸掉
    club_id = params[:club_id]
    code = params[:code]
    apply_success = redis_get(club_id).eql?(code)
    if apply_success
      redis_remove_keys(club_id)
      last_master_record = UserJoinClub.find_by(club_id: club_id, role: UserJoinClub::Role::MASTER)
      if not last_master_record.nil? # 有上一任社长,降为管理员
        last_master_record.update(role: UserJoinClub::Role::ADMIN)
      end
      # 当前用户自动成为社长
      current_user_record = UserJoinClub.find_or_create_by(user_id: @user.id, club_id: club_id)
      current_user_record.update(role: UserJoinClub::Role::MASTER)
      request = UserJoinClubRequest.find_by(user_id: @user.id, club_id: club_id)
      if not request.nil? # 如果此时此时用户已经发送申请请求加入,则自动通过请求
        request.update(status: UserJoinClubRequest::Status::ACCEPTED)
      end
    end
    render status: 200, json: response_json(
        true,
        message: "Successfully!",
        data:
            {
                request_success: apply_success
            }
    )

  end



  def all_cheif_club # 当前用户为社长的所有社团id列表
    count_hash = UserFollowClub.group(:club_id).count
    club_list = []
    record_list = UserJoinClub.where(user_id: @user.id, role: UserJoinClub::Role::MASTER)
    record_list.each do |record|
      brief_info = record.club.brief_information
      brief_info[:followers_count] = count_hash[record.club.id] || 0
      club_list.append(brief_info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get my master clubs successfully!",
        data:
            {
                chief_clubs: club_list
            }
    )
  end

  def apply_master_token # 申请一个社团的token
    club_id = params[:club_id]
    key_len = 8
    code = rand(36 ** key_len).to_s(36)
    redis_set_cache(club_id, code, 600)
    render status: 200, json: response_json(
        true,
        message: "Refresh token successfully (valid in 10 minute)!",
        data:
            {
                code: redis_get(club_id)
            }
    )
  end

  def complete_information#用户完善自己的相关信息
    record = User.find_by_id(@user.id)
    puts record.attributes.deep_symbolize_keys
    record.update({
                      gender: params[:gender],
                      political_status_id: params[:political_status_id],
                      phone_number: params[:phone],
                      role: User::Role::STUDENT,
                  }
    )
    puts record.attributes.deep_symbolize_keys
    render status: 200, json: response_json(
        true,
        message: "Complete information successfully!",
    )
  end

  def all_colleges# 返回所有学院的信息
    data = []
    College.find_each do |record|
      data.append(
          {
              id: record.id,
              name: record.name,
          }
      )
    end
    render status: 200, json: response_json(
        true,
        message: "Get all colleges successfully!",
        data:
            {
                college_list: data
            }
    )

  end

  def all_politicalstatus#返回所有政治面貌
    data = []
    PoliticalStatus.find_each do |record|
      data.append(
          {
              id: record.id,
              name: record.name,
          }
      )
    end
    render status: 200, json: response_json(
        true,
        message: "Get all political status successfully!",
        data:
            {
                status_list: data
            }
    )

  end

  def add_club_category#<社联可用> 增加社团的类别
    name = params[:name]
    record = ClubCategory.find_by_name(name)
    if not record.nil?
      render status: 404, json: response_json(
          false,
          message: "Category already exist!",
          data:
              {
                  id: record.id
              }
      )
    else
      new_rec = ClubCategory.create(name: name)
      render status: 200, json: response_json(
          true,
          message: "Add new category successfully!",
          data:
              {
                  id: new_rec.id
              }
      )
    end
  end

  def add_club #增加新的社团
    name = params[:name]
    star = params[:level]
    category_name = params[:category]
    category_record = ClubCategory.find_by_name(category_name)
    if category_record.nil?
      render status: 404, json: response_json(
          false,
          message: "ClubCategory name does not exist!"
      )
      return
    end
    category = category_record.id
    new_club = Club.create(name: name, level: star, club_category_id: category);
    if new_club.nil?
      render status: 404, json: response_json(
          false,
          message: "Fail to add club!"
      )
    else
      render status: 200, json: response_json(
          true,
          message: "Add new club successfully!",
          data:
              {
                  id: new_club.id
              }
      )
    end
  end

  def show_all_club#显示所有的社团
    club_list = {}
    Club.find_each do |record|
      puts record.name.class
      club_list[record.name] = record.id
    end
    render status: 200, json: response_json(
        true,
        message: "successfully!",
        data:
            {
                clubs: club_list
            }
    )

  end

  private def guest_only#判断是不是guest
    unless @user.is_guest?
      render status: 403, json: response_json(
          false,
          code: UserErrorCode::USER_NOT_A_GUEST,
          message: 'User is not a guest'
      )
      false
    end
    true
  end

  def unified_authenticate#统一认证
    username = params[:username]
    password = params[:password]
    _res = UtilsMiddleware.authenticate(username, password)
    _success = _res[:success]
    if _success
      _data = _res[:data]
      _student_id = _data[:student_id]
      _real_name = _data[:real_name]
      _department = _data[:department]
      _college_id = College.find_by(name: _department).id
      _gender = User::Gender.anycase_key_to_value(params[:gender])
      _political_status = PoliticalStatus.find_by(code: params[:political_status_code])
      _phone_number = params[:phone_number]
      if !_gender
        render status: 400, json: response_json(
            false,
            code: UserErrorCode::USER_GENDER_NOT_EXIST,
            message: 'User gender not exist(must be 1-male or 2-female)'
        )
        return
      end
      if !_political_status
        render status: 400, json: response_json(
            false,
            code: UserErrorCode::USER_POLITICAL_STATUS_NOT_EXIST,
            message: 'User political status not exist'
        )
        return
      end
      if !_phone_number
        render status: 400, json: response_json(
            false,
            code: UserErrorCode::USER_PHONE_NUMBER_NOT_PROVIDED,
            message: 'User phone number not provided.'
        )
        return
      end
      @user.student_id = _student_id
      @user.real_name = _real_name
      @user.college_id = _college_id
      @user.phone_number = _phone_number
      @user.gender = _gender
      @user.political_status_id = _political_status.id
      @user.role = User::Role::STUDENT
      if @user.save
        render status: 200, json: response_json(
            true,
            data: {
                student_id: _student_id,
                real_name: _real_name,
                department: _department,
                college_id: _college_id
            },
            message: 'Unified authenticate success.'
        )
      else
        render status: 400, json: response_json(
            false,
            code: UserErrorCode::USER_UPDATE_FAILED,
            message: 'User update failed',
            data: {
                message: @user.error_messages
            }
        )
      end
    else
      render status: 400, json: response_json(
          false,
          code: UserErrorCode::USER_UNIFIED_AUTHENTICATE_FAILED,
          data: {
              error_message: _res[:message]
          },
          message: 'Unified authenticate failed.'
      )
    end
  end

  def update_club_level#更改社团的星级
    club_id = params[:club_id]
    club = Club.find_by(id: club_id)
    if club.nil?
      render status: 400, json: response_json(
          false,
          message: 'Club not exist!'
      )
      return
    end
    club.update(level: params[:new_level])
    render status: 200, json: response_json(
        true,
        message: "Update club level successfully!",
        data:
            {
                club: club.brief_information
            }
    )
  end

  def edit_phone_number
    begin
    @user.update!(phone_number: params[:phone_number])
    render status: 200, json: response_json(
        true,
        message: "Update phone number successfully!"
    )
    rescue Exception => e
      render status: 400, json: response_json(
          false,
          message: e.message,
      )
    end
  end

  def edit_political_status
    begin
      @user.update!(political_status_id: params[:political_status_code])
      render status: 200, json: response_json(
          true,
          message: "Update political status successfully!"
      )
    rescue Exception => e
      render status: 400, json: response_json(
          false,
          code: UserErrorCode::USER_POLITICAL_STATUS_NOT_EXIST,
          message: 'User political status not exist'
      )
    end
  end

end
