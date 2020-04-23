require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:three)
    post session_login_path, params:
        {
            username: @user.email,
            password: 'password'
        }
  end

  test "should create comment" do
    ac = Activity.first
    content = "这个活动不错"
    post comments_new_path(ac.id), params: {content: content}
    assert_response :success
    comment_id = JSON.parse(@response.body)["data"]["activity_comment_id"]
    comment = ActivityComment.find_by(id: comment_id)
    assert @user.activity_comments.include?(comment)
    assert_match content, comment.content
  end

  test "should like comment" do
    comment = ActivityComment.first
    post like_comment_path(comment.id)
    record = UserProActivityComment.find_by(activity_comment_id: comment.id, user_id: @user.id)
    assert !record.nil?
  end

  test "should get activity comment time_sorted" do
    ac = Activity.first
    ac.comments.create(content: "aaaaa")
    ac.comments.create(content: "bbbbb")
    get comments_list_sortbytime_path(ac.id), params: {page: 1, per_page_num: ac.comments.count}
    assert_response :success
    puts @response.body
  end

  test "should dislike activity comment" do
    comment = ActivityComment.first
    @user.pro_activity_comment(comment)
    delete dislike_comment_path(comment.id)
    record = UserProActivityComment.find_by(activity_comment_id: comment.id, user_id: @user.id)
    assert record.nil?
  end

end
