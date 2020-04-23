class ClubManagementController < ApplicationController
  before_action :login_only, :init, except: [:get_qrcode, :check_qrcode]
  before_action :manager_only, except: [:get_qrcode, :bind_qrcode, :check_qrcode, :verify_qrcode]
  before_action :root_only, only: [:club_create]
  before_action :_find_club, only:
      [:club_profile, :club_update,
       :activity_index, :activity_create, :activity_profile, :activity_update,
       :article_index, :article_create, :article_profile, :article_update]
  before_action :_find_activity, only: [:activity_profile, :activity_update]
  before_action :_find_article, only: [:article_profile, :article_update]

  include WechatHelper
  extend WechatHelper

  private def _find_club
    @club = Club.find_by_id(params[:club_id])
    if @club
      true
    else
      render status: 404, json: response_json(
          false,
          code: ClubManagementErrorCode::CLUB_NOT_EXIST,
          message: 'Club not exist.'
      )
      false
    end
  end

  private def _find_activity
    @activity = @club.activities.find_by_id(params[:activity_id])
    if @activity
      true
    else
      render status: 404, json: response_json(
          false,
          code: ClubManagementErrorCode::ACTIVITY_NOT_EXIST,
          message: 'Activity not exist.'
      )
      false
    end
  end

  private def _find_article
    @article = @club.articles.find_by_id(params[:article_id])
    if @article
      true
    else
      render status: 404, json: response_json(
          false,
          code: ClubManagementErrorCode::ARTICLE_NOT_EXIST,
          message: 'Article not exist'
      )
      false
    end
  end

  def init
    @user = current_user
  end

  def manager_only
    return true if current_user.is_root?
    all_clubs = UserJoinClub.user_managing_clubs(@user).order(id: :desc)
    if all_clubs.empty?
      render status: 403, json: response_json(
          false,
          code: ClubManagementErrorCode::USER_MANAGES_NO_CLUBS,
          message: 'User manages no clubs.'
      )
      return false
    end
    unless UserJoinClub.user_managing_clubs(@user).where(club_id: params[:club_id])
      render status: 403, json: response_json(
          false,
          code: ClubManagementErrorCode::USER_DOESNT_MANAGE_THIS_CLUB,
          message: 'User does not manages this club.'
      )
      return false
    end
    true
  end

  def club_index
    if params[:page] && params[:per_page]
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 30).to_i
      all_clubs = if @user.is_root?
                    Club.all
                  else
                    UserJoinClub.user_managing_clubs(@user).order(id: :desc)
                  end
      total_count = all_clubs.count
      total_pages = (total_count * 1.0 / per_page).ceil
      clubs = all_clubs.offset((page - 1) * per_page).limit(per_page)
      render status: 200, json: response_json(
          true,
          data: {
              page: page,
              per_page: per_page,
              total_count: total_count,
              total_pages: total_pages,
              clubs: clubs.collect(&:brief_information)
          },
          message: 'Get managing club list successfully.'
      )
    else
      clubs = if @user.is_root?
                Club.all
              else
                UserJoinClub.user_managing_clubs(@user).order(id: :desc)
              end
      render status: 200, json: response_json(
          true,
          data: {
              clubs: clubs.collect(&:brief_information)
          },
          message: 'Get managing club list without paginate successfully.'
      )
    end

  end

  def club_create # TODO: Club create is not in the requirements list, so this method is not totally implemented yet.
    club = Club.new
    # club.icon_url=params[:icon_url] TODO: Image hosting service is not implemented yet
    club.english_name = params[:english_name]
    # club.label=params[:label] TODO: This field does not exist in the club model
    club.video_url = params[:video_url]
    club.qq_group_number = params[:qq_group_number]
    club.wechat_public_account = params[:wechat_public_account]
    club.introduction = params[:introduction]
    # club.introduction_article_url = params[:introduction_article_url] TODO: This field does not exist in the club model

    if club.save
      render status: 200, json: response_json(
          true,
          data: {
              club_id: club.id,
          },
          message: 'Club created successfully.'
      )
    else
      render status: 400, json: response_json(
          false,
          code: ClubManagementErrorCode::CLUB_CREATE_FAILED,
          message: 'Club create failed.',
          data: {
              errors: club.error_messages
          }
      )
    end
  end

  def club_profile
    render status: 200, json: response_json(
        true,
        data: {
            club: @club.detail_information
        }
    )
  end

  def club_update
    _icon_image = Image.find_by(token: params[:icon_token]) and @club.icon_image_id = _icon_image.id
    @club.english_name = params[:english_name]
    @club.qq_group_number = params[:qq_group_number].presence
    @club.wechat_public_account = params[:wechat_public_account].presence
    @club.introduction = params[:introduction]
    @club.introduction_url = params[:introduction_url]
    @club.tags = params[:tags]
    album_tokens = params[:album_tokens]
    if album_tokens.presence
      ClubContainImage.where(club_id: @club.id).destroy_all
      album_tokens.each do |token|
        image = Image.find_by(token: token)
        unless image
          render status: 400, json: response_json(
              false,
              code: ClubManagementErrorCode::IMAGE_TOKEN_NOT_EXIST,
              message: 'Image token not exist.',
              data: {
                  token: token
              }
          )
          return
        end
        club_contain_image = ClubContainImage.new
        club_contain_image.club_id = @club.id
        club_contain_image.image_id = image.id
        club_contain_image.save
      end
    end
    if @club.save
      render status: 200, json: response_json(
          true,
          data: {
              club_id: @club.id
          }
      )
    else
      render status: 400, json: response_json(
          false,
          code: ClubManagementErrorCode::CLUB_UPDATE_FAILED,
          message: 'Club profile update failed.',
          data: {
              errors: @club.error_messages
          }
      )
    end
  end

  def activity_index
    if params[:page] && params[:per_page]
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 30).to_i
      all_activities = @club.activities.order(id: :desc)
      total_count = all_activities.count
      total_pages = (total_count * 1.0 / per_page).ceil
      activities = all_activities.offset((page - 1) * per_page).limit(per_page)
      render status: 200, json: response_json(
          true,
          data: {
              page: page,
              per_page: per_page,
              total_count: total_count,
              total_pages: total_pages,
              activities: activities.collect(&:get_activity_information_hash)
          },
          message: 'Get club activities successfully.'
      )
    else
      activities = @club.activities.order(id: :desc)
      render status: 200, json: response_json(
          true,
          data: {
              activities: activities.collect(&:get_activity_information_hash)
          },
          message: 'Get club activities without paginate successfully.'
      )
    end
  end

  # TODO: Need to add activity related clubs field
  def activity_create
    activity = Activity.new
    activity.name = params[:name]
    activity.position = params[:position]
    activity.description = params[:description]
    activity.start_time = params[:start_time]
    activity.end_time = params[:end_time]
    _post_horizontal_image = Image.find_by(token: params[:post_horizontal_image_token]) and
        activity.post_horizontal_image_id = _post_horizontal_image.id
    _post_vertical_image = Image.find_by(token: params[:post_vertical_image_token]) and
        activity.post_vertical_image_id = _post_vertical_image.id
    activity.max_people_limit = params[:max_people_limit]
    activity.need_enroll = params[:need_enroll]
    activity.introduction_article_url = params[:introduction_article_url].presence
    activity.introduction_article_title = params[:introduction_article_title].presence
    activity.retrospect_article_url = params[:retrospect_article_url].presence
    activity.retrospect_article_title = params[:retrospect_article_title].presence

    # activity.message_push_time = (params[:message_push_time] || 24).to_i.hours

    if activity.save
      club_to_activity = ClubToActivity.new
      club_to_activity.club_id = @club.id
      club_to_activity.activity_id = activity.id
      if club_to_activity.save
        _host_clubs = params[:host_clubs]
        if _host_clubs
          _host_clubs.each do |club_name|
            club = Club.find_by(name: club_name)
            unless club
              render status: 200, json: response_json(
                  false,
                  code: ClubManagementErrorCode::HOST_CLUB_NOT_EXIST,
                  message: 'Host club not exist',
              )
              return
            end
            unless club == @club
              club_to_activity = ClubToActivity.new
              club_to_activity.club_id = club.id
              club_to_activity.activity_id = activity.id
              club_to_activity.save!
            end
          end
        end
        render status: 200, json: response_json(
            true,
            data: {
                activity_id: activity.id
            },
            message: 'Activity created successfully.'
        )
      else
        activity.destroy
        render status: 400, json: response_json(
            false,
            code: ClubManagementErrorCode::ACTIVITY_CREATE_FAILED,
            message: 'Activity create failed.',
            data: {
                errors: activity.error_messages
            }
        )
      end
    else
      render status: 400, json: response_json(
          false,
          code: ClubManagementErrorCode::ACTIVITY_CREATE_FAILED,
          message: 'Activity create failed.',
          data: {
              errors: activity.error_messages
          }
      )
    end
  end

  def activity_profile
    render status: 200, json: response_json(
        true,
        data: {
            activity: @activity.get_activity_information_hash
        }
    )
  end

  def activity_update
    @activity.position = params[:position]
    @activity.description = params[:description]
    if @activity.start_time != params[:start_time]
      UserFollowActivity.where(activity_id: @activity.id).each do |record|
        record.notified = false
        record.save
      end
    end
    @activity.start_time = params[:start_time]
    @activity.end_time = params[:end_time]
    _post_horizontal_image = Image.find_by(token: params[:post_horizontal_image_token]) and
        @activity.post_horizontal_image_id = _post_horizontal_image.id
    _post_vertical_image = Image.find_by(token: params[:post_vertical_image_token]) and
        @activity.post_vertical_image_id = _post_vertical_image.id
    @activity.max_people_limit = params[:max_people_limit]
    @activity.need_enroll = params[:need_enroll]
    @activity.introduction_article_url = params[:introduction_article_url].presence
    @activity.introduction_article_title = params[:introduction_article_title].presence
    @activity.retrospect_article_url = params[:retrospect_article_url].presence
    @activity.retrospect_article_title = params[:retrospect_article_title].presence
    # @activity.message_push_time = (params[:message_push_time] || 24).to_i.hours

    _host_clubs = params[:host_clubs]
    if _host_clubs
      _host_clubs.each do |club_name|
        club = Club.find_by(name: club_name)
        unless club
          render status: 200, json: response_json(
              false,
              code: ClubManagementErrorCode::HOST_CLUB_NOT_EXIST,
              message: 'Host club not exist',
          )
          return
        end
        unless @activity.clubs.include? club
          club_to_activity = ClubToActivity.new
          club_to_activity.club_id = club.id
          club_to_activity.activity_id = @activity.id
          club_to_activity.save!
        end
      end
    end

    if @activity.save
      render status: 200, json: response_json(
          true,
          data: {
              activity_id: @activity.id
          }
      )
    else
      render status: 400, json: response_json(
          false,
          code: ClubManagementErrorCode::ACTIVITY_UPDATE_FAILED,
          message: 'Activity profile update failed.',
          data: {
              errors: @activity.error_messages
          }
      )
    end
  end

  def article_index
    if params[:page] && params[:per_page]
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 30).to_i
      all_articles = @club.articles.order(id: :desc)
      total_count = all_articles.count
      total_pages = (total_count * 1.0 / per_page).ceil
      articles = all_articles.offset((page - 1) * per_page).limit(per_page)
      render statue: 200, json: response_json(
          true,
          data: {
              page: page,
              per_page: per_page,
              total_count: total_count,
              total_pages: total_pages,
              articles: articles.collect(&:get_article_information_hash)
          },
          message: 'Get club articles successfully.'
      )
    else
      articles = @club.articles.order(id: :desc)
      render status: 200, json: response_json(
          true,
          data: {
              articles: articles.collect(&:get_article_information_hash)
          },
          message: 'Get club articles without paginate successfully.'
      )
    end
  end

  def article_create
    article = Article.new
    article.title = params[:title]
    article.publish_time = Time.now.in_time_zone(+8.hours)
    _cover_image = Image.find_by(token: params[:cover_image_token]) and article.cover_image_id = _cover_image.id
    article.original_url = params[:original_url]
    article.club_id = @club.id

    if article.save
      render status: 200, json: response_json(
          true,
          data: {
              article_id: article.id
          },
          message: 'Article created successfully'
      )
    else
      render statue: 400, json: response_json(
          false,
          code: ClubManagementErrorCode::ARTICLE_CREATE_FAILED,
          message: 'Article create failed',
          data: {
              errors: article.error_messages
          }
      )
    end
  end

  def article_profile
    render status: 200, json: response_json(
        true,
        data: {
            article: @article.get_article_information_hash
        }
    )
  end

  def article_update
    @article.original_url = params[:original_url]
    _cover_image = Image.find_by(token: params[:cover_image_token]) and @article.cover_image_id = _cover_image.id

    if @article.save
      render status: 200, json: response_json(
          true,
          data: {
              article_id: @article.id
          },
          message: 'Article updated successfully'
      )
    else
      render statue: 400, json: response_json(
          false,
          code: ClubManagementErrorCode::ARTICLE_CREATE_FAILED,
          message: 'Article update failed',
          data: {
              errors: @article.error_messages
          }
      )
    end
  end

  def get_qrcode
    uuid = SecureRandom.uuid
    $redis_cache.set_cache(uuid, true, 5.minutes)
    render status: 200, json: response_json(
        true,
        data: {
            uuid: uuid
        },
        message: 'Get uuid successfully.'
    )
  end

  def bind_qrcode
    uuid = params[:uuid]
    code = params[:code]
    cached_uuid = $redis_cache.get_object(uuid)
    unless cached_uuid
      render status: 400, json: response_json(
          false,
          data: {
              uuid: uuid
          },
          code: ClubManagementErrorCode::UUID_NOT_EXIST,
          message: 'Uuid not exist.'
      )
      return
    end
    if !!cached_uuid != cached_uuid
      render status: 400, json: response_json(
          false,
          data: {
              uuid: uuid
          },
          code: ClubManagementErrorCode::UUID_HAS_BEEN_USED,
          message: 'Uuid has been used.'
      )
      return
    end
    $redis_cache.set_cache(uuid, code, 5.minutes)
    render status: 200, json: response_json(
        true,
        message: 'User bind with uuid successfully.'
    )
  end

  def verify_qrcode
    uuid = params[:uuid]
    cached_uuid = $redis_cache.get_object(uuid)
    unless cached_uuid
      render status: 400, json: response_json(
          false,
          data: {
              uuid: uuid
          },
          code: ClubManagementErrorCode::UUID_NOT_EXIST,
          message: 'Uuid not exist.'
      )
      return
    end
    if !!cached_uuid != cached_uuid
      render status: 400, json: response_json(
          false,
          data: {
              uuid: uuid
          },
          code: ClubManagementErrorCode::UUID_HAS_BEEN_USED,
          message: 'Uuid has been used.'
      )
      return
    end
    render status: 200, json: response_json(
        true,
        data: {
            uuid: uuid
        },
        message: 'Uuid exists.'
    )
  end

  def check_qrcode
    uuid = params[:uuid]
    code = $redis_cache.get_object(uuid)
    unless code
      render status: 400, json: response_json(
          false,
          data: {
              uuid: uuid
          },
          code: ClubManagementErrorCode::UUID_NOT_EXIST,
          message: 'Uuid not exist.'
      )
      return
    end
    if !!code == code
      render status: 400, json: response_json(
          false,
          data: {
              uuid: uuid
          },
          code: ClubManagementErrorCode::UUID_NOT_BIND,
          message: 'Uuid not bind.'
      )
      return
    end

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

          log_in user, false
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
                  }
              },
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
    else
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

end
