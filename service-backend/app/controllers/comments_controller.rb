class CommentsController < ApplicationController
  before_action :login_only,:user_init # 每个接口执行前都先检查是否登录

  def user_init
    @user = current_user
  end

  def new #创建一个新的社团评论
    begin
      content = params[:content]
      comment = @user.activity_comments.create!(content: content, activity_id: params[:activity_id])
      render status: 200, json: response_json(
          true,
          message: "Create comment success!",
          data: {
              activity_comment_id: comment.id
          }
      )
    rescue Exception => e
      render status: 400, json: response_json(
          false,
          message: e.message,
          code: ActivityErrorCode::COMMENT_CREATE_FAILED
      )
    end
  end

  def pro_comment#点赞一个社团评论
    begin
      comment = ActivityComment.find_by(id: params[:comment_id])
      @user.pro_activity_comment(comment)
      render status: 200, json: response_json(
          true,
          message: "Pro comment success!",
          data: {
              activity_comment_id: comment.id
          }
      )
    rescue Exception => e
      render status: 400, json: response_json(
          false,
          message: e.message,
          code: ActivityErrorCode::COMMENT_PRO_FAILED
      )
    end
  end

  def unpro_comment#取消点赞一个社团评论
    begin
      comment = ActivityComment.find_by(id: params[:comment_id])
      @user.unpro_activity_comment(comment)
      render status: 200, json: response_json(
          true,
          message: "Unpro comment success!",
      )
    rescue Exception => e
      render status: 400, json: response_json(
          false,
          message: e.message,
          code: ActivityErrorCode::COMMENT_UNPRO_FAILED
      )
    end
  end


  def list_comments#列出社团所有的评论
    activity = Activity.find_by(id: params[:activity_id])
    comments_list = activity.comments.all.order(created_at: :desc)
    id_list = comments_list.ids
    pro_comment_hash_count = UserProActivityComment.where(activity_comments_id: id_list)
                                 .group(:activity_comment_id).count
    pro_comment_hash = UserProActivityComment.where(user_id: @user.id, activity_comment_id: id_list)
                           .group(:activity_comment_id).count
    result = []

    comments_list.each do |comment|
      comment_id = comment.id
      result.append(
          {
              comment_id: comment_id,
              content: comment.content,
              like_count: pro_comment_hash_count[comment_id].nil? ? 0 : pro_comment_hash_count[comment_id],
              is_like: !(pro_comment_hash[comment_id].nil?),
              time: calculate_past_time(comment.created_at),
              user_name: comment.user.nickname,
              user_protrait: comment.user.avatar_url
          }
      )
    end

    render status: 200, json: response_json(
        true,
        data:
            {
                comments: result,
            }
    )
  end

  def list_comments_per_page#按照页编码和每页数目列出所有的评论
    activity = Activity.find_by(id: params[:activity_id])
    count = activity.comments.count
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    if page > (count * 1.0 / per_page).ceil
      render status: 400, json: response_json(
          false,
          code: ActivityCommentErrorCode::PAGE_OUT_OF_RANGE,
          message: "Page out of range"
      )
    else
      is_end = (page == (count * 1.0 / per_page).ceil)
      user = current_user
      start_pos = (page - 1) * per_page

      comment_id_list = activity.comments.all.order(created_at: :desc).limit(per_page).offset(start_pos).ids
      pro_comment_hash_count = UserProActivityComment.where(activity_comment_id: comment_id_list).group(:activity_comment_id).count
      pro_comment_hash = UserProActivityComment.where(activity_comment_id: comment_id_list)
                             .where(user_id: user.id).group(:activity_comment_id).count
      result = []

      comment_id_list.each do |id|
        comment =  ActivityComment.find_by(id: id)
        comment_id = id
        result.append(
            {
                comment_id: comment_id,
                content: comment.content,
                like_count: pro_comment_hash_count[comment_id].nil? ? 0 : pro_comment_hash_count[comment_id],
                is_like: !(pro_comment_hash[comment_id].nil?),
                time: calculate_past_time(comment.created_at),
                user_name: comment.user.nickname, #todo:微信名
                user_protrait: comment.user.avatar_url
            }
        )
      end
      render status: 200, json: response_json(
          true,
          data:
              {
                  comments: result,
                  reach_end: is_end
              }
      )
    end
  end

end

