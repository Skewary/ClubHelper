class ClubDiscussionsController < ApplicationController
  before_action :login_only, :init
  before_action :init
  before_action :question_exist, only: [:delete_question, :top_question, :untop_question,
                                        :add_answer, :delete_answer, :top_answer,
                                        :untop_answer, :like_answer, :unlike_answer]
  before_action :answer_exist, only: [:delete_answer, :top_answer, :untop_answer,
                                      :like_answer, :unlike_answer]

  before_action :check_admin_by_url, only: [:delete_question, :top_question, :untop_question]
  before_action :check_admin_by_question, only: [:delete_answer, :top_answer, :untop_answer]
  # attributes.deep_symbolize_keys
  def init
    @user = current_user
  end

  def question_exist # 根据输入的question_id判断问题是否存在
    question_id = params[:question_id]
    @post = Post.find_by(id: question_id)
    if @post.nil?
      render status: 404, json: response_json(
          false,
          message: "Question not found!"
      )
      false
    else
      true
    end

  end

  def answer_exist # 根据输入的answer_id判断问题是否存在
    answer_id = params[:answer_id]
    @answer = PostComment.find_by(id: answer_id)
    if @answer.nil?
      render status: 404, json: response_json(
          false,
          message: "Answer not found!"
      )
      false
    else
      true
    end
  end

  def check_admin_by_url # 检查是否是某个社团的管理员
    club_id = params[:club_id]
    check_administrator(@user.id, club_id) {return false}
    true
  end

  def check_admin_by_question
    check_administrator(@user.id, @post.club_id) {return false}
    true
  end

  def add_question # 所有用户可以使用,增加一个新问题
    club_id = params[:club_id]
    content = params[:content]
    question = Post.create(content: content, user_id: @user.id, club_id: club_id, category: 0, status: 0, title: "default_title")
    render status: 200, json: response_json(
        true,
        message: "Add a question successfully!",
        data:
            {
                id: question.id
            }
    )
  end

  def delete_question # 删除一个问题
    club_id = params[:club_id]
    question_id = params[:question_id]
    # 需要先删除所有回答以及回答的关注情况,再删除问题
    answer_list = @post.comments #所有回答
    if not answer_list.nil?
      answer_list.each do |answer|
        answer.user_pro_post_comments.destroy_all #删除这个回答的所有关注情况
        answer.destroy # 删除这个回答
      end
    end
    @post.destroy # 删除整个问题
    render status: 200, json: response_json(
        true,
        message: "Remove a question successfully!"
    )
  end

  def top_question # 管理员置顶一个问题
    club_id = params[:club_id]
    question_id = params[:question_id]
    @post.update(category: Post::Category::TOP)
    render status: 200, json: response_json(
        true,
        message: "Top a question successfully!"
    )
  end

  def untop_question # 管理员以及以上权限可以取消置顶问题
    club_id = params[:club_id]
    question_id = params[:question_id]
    @post.update(category: Post::Category::NORMAL)
    render status: 200, json: response_json(
        true,
        message: "Untop a question successfully!"
    )
  end

  def get_all_brief_question # 所有用户可以得到所有的简单信息
    club_id = params[:club_id]
    question_list = []
    questions_record = Post.where(club_id: club_id)
                           .order(Category: :desc, created_at: :desc)
    questions_record.each do |record|
      question_list.append(record.get_post_brief_info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get club's brief posts successfully!",
        data:
            {
                questions: question_list
            }
    )
  end

  def get_brief_question_by_page # 按页获得所有的问题的简单信息
    question_list = []
    club_id = params[:club_id]
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    start_pos = (page - 1) * per_page
    questions_record = Post.where(club_id: club_id)
                           .order(Category: :desc, created_at: :desc, id: :desc)
                           .limit(per_page).offset(start_pos)
    questions_record.each do |record|
      question_list.append(record.get_post_brief_info)
    end
    render status: 200, json: response_json(
        true,
        message: "Get club's brief posts successfully!",
        data:
            {
                questions: question_list
            }
    )
  end

  def get_all_detail_question # 获得所有问题的详细信息
    club_id = params[:club_id]
    question_list = []
    questions_record = Post.where(club_id: club_id)
                           .order(Category: :desc, created_at: :desc)
    like_comment_hash_count = UserProPostComment.group(:post_comment_id).count
    questions_record.each do |record|
      post_detail = record.get_post_detail_info

      post_detail[:answers_list].each do |answer|
        answer[:like_num] = like_comment_hash_count[answer[:answer_id]] || 0
        answer[:is_like] = !UserProPostComment.find_by(post_comment_id: answer[:answer_id], user_id: @user.id).nil?
      end
      question_list.append(post_detail)
    end
    render status: 200, json: response_json(
        true,
        message: "Get club's detail posts successfully!",
        data:
            {
                questions: question_list
            }
    )

  end

  def get_detail_question_by_page # 按照分页获得所有问题的详细信息
    question_list = []
    club_id = params[:club_id]
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    start_pos = (page - 1) * per_page
    questions_record = Post.where(club_id: club_id)
                           .order(Category: :desc, created_at: :desc, id: :desc)
                           .limit(per_page).offset(start_pos)
    like_comment_hash_count = UserProPostComment.group(:post_comment_id).count
    questions_record.each do |record|
      post_detail = record.get_post_detail_info
      post_detail[:answers_list].each do |answer|
        answer[:like_num] = like_comment_hash_count[answer[:answer_id]] || 0
        answer[:is_like] = !UserProPostComment.find_by(post_comment_id: answer[:answer_id], user_id: @user.id).nil?
      end
      question_list.append(post_detail)
    end
    render status: 200, json: response_json(
        true,
        message: "Get club's detail posts successfully!",
        data:
            {
                questions: question_list
            }
    )

  end

  def add_answer # 新增一个答案
    question_id = params[:question_id]
    content = params[:content]
    answer = PostComment.create(content: content, user_id: @user.id, post_id: question_id)
    render status: 200, json: response_json(
        true,
        message: "Add answer successfully!",
        data:
            {
                id: answer.id
            }
    )
  end

  def delete_answer # 管理员删除一个回答
    answer_id = params[:answer_id]
    question_id = params[:question_id]
    # 需要先删除所有回答的关注情况(否则会报外键错误)
    @answer.user_pro_post_comments.destroy_all
    #UserProPostComment.where(post_comment_id: answer_id).destroy_all
    @answer.destroy
    render status: 200, json: response_json(
        true,
        message: "Remove a answer successfully!"
    )
  end

  def top_answer # 管理员置顶一个回答
    answer_id = params[:answer_id]
    question_id = params[:question_id]
    @answer.update(status: PostComment::Status::TOP)
    render status: 200, json: response_json(
        true,
        message: "Top an answer successfully!"
    )
  end

  def untop_answer # 管理员取消置顶一个答案
    answer_id = params[:answer_id]
    question_id = params[:question_id]
    @answer.update(status: PostComment::Status::NORMAL)
    render status: 200, json: response_json(
        true,
        message: "Untop an answer successfully!"
    )
  end

  def like_answer # 用户点赞一个答案
    answer_id = params[:answer_id]
    question_id = params[:question_id]
    UserProPostComment.find_or_create_by(user_id: @user.id, post_comment_id: answer_id)
    render status: 200, json: response_json(
        true,
        message: "Like an answer successfully!"
    )
  end

  def unlike_answer # 取消点赞一个答案
    answer_id = params[:answer_id]
    question_id = params[:question_id]
    record = UserProPostComment.find_by(user_id: @user.id, post_comment_id: answer_id)
    if record.nil?# 如果这个问题所对应的答案并不存在
      render status: 404, json: response_json(
          false,
          message: "User hasn't liked this answer!"
      )
    else
      record.destroy
      render status: 200, json: response_json(
          true,
          message: "Unlike an answer successfully!"
      )
    end
  end

end
