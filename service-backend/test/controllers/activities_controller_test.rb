require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
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


  test "should get activities followed list" do
    activities = Activity.all
    count = activities.count
    activities.each do |ac|
      @user.follow_activity(ac)
    end
    get activities_followed_list_path, params: {page: 1, per_page_num: count}
    json_data = JSON.parse(@response.body)
    assert_response 200
    puts json_data["data"]
    assert json_data["data"]["activities"].count.eql?(count)
  end

  test "should get activities hot" do
    activity1 = Activity.first
    activity2 = Activity.second
    activity3 = Activity.third
    count = User.count
    User.all.each do |user|
      user.pro_activity(activity1)
    end
    count -= 1
    User.all[0..count].each do |user|
      user.pro_activity(activity2)
    end
    count -= 1
    User.all.each do |user|
      user.pro_activity(activity3)
    end
    get activities_hot_list_path, params: {count: 3}
    json_data = JSON.parse(@response.body)["data"]["activities"]
    assert_match activity1.name, json_data[0].to_s
    puts json_data[0]
    assert_match activity2.name, json_data[1].to_s
    assert_match activity3.name, json_data[2].to_s

  end

  test "should get activity information" do
    activity = Activity.first
    get activities_information_path(activity.id)
    puts @response.body
    assert_response :success
    assert_match activity.name, @response.body
  end

  test "should like activity" do
    activity = Activity.first
    post like_activities_path(activity.id)
    assert !UserProActivity.find_by(user_id: @user.id, activity_id: activity.id).nil?
  end

  test "should dislike activity" do
    activity = Activity.first
    @user.pro_activity(activity)
    delete dislike_activities_path(activity.id)
    assert UserProActivity.find_by(user_id: @user.id, activity_id: activity.id).nil?
  end

  test "should follow activity" do
    activity = Activity.first
    post follow_activity_path(activity.id)
    assert !UserFollowActivity.find_by(user_id: @user.id, activity_id: activity.id).nil?
  end

  test "should unfollow activity" do
    activity = Activity.first
    @user.unfollow_activity(activity)
    delete unfollow_activity_path(activity.id)
    assert UserFollowActivity.find_by(user_id: @user.id, activity_id: activity.id).nil?
  end

  test "should get activities hot per_page" do
    activity1 = Activity.first
    activity2 = Activity.second
    activity3 = Activity.third
    count = User.count
    User.all.each do |user|
      user.pro_activity(activity1)
    end
    User.all[0..(count - 2)].each do |user|
      user.pro_activity(activity2)
    end
    User.all[0..(count - 3)].each do |user|
      user.pro_activity(activity3)
    end
    puts activities_hot_list_per_page_path, params: {page: 1, per_page_num: Activity.all.count - 1}
    get activities_hot_list_per_page_path, params: {page: 1, per_page_num: Activity.all.count - 1}
    json_data = JSON.parse(@response.body)["data"]["activities"]
    puts @response.body
    puts json_data
    assert_match activity1.name, json_data[0]["activity_detail"].to_s
    assert_match activity2.name, json_data[1]["activity_detail"].to_s
    assert_match activity3.name, json_data[2]["activity_detail"].to_s
    assert_equal activity1.pro_users.count, json_data[0]["like_count"]
  end

  test "should get activities list time_sorted" do
    get activities_time_list_per_page_path, params: {page: 1, per_page_num: Activity.count}
    json_data = JSON.parse(@response.body)["data"]["activities"]
    assert_response :success
    puts json_data
    get activities_time_list_per_page_path, params: {page: 2, per_page_num: Activity.count - 1}
    assert_response :success
    json_data = JSON.parse(@response.body)["data"]["activities"]
    assert_response :success
    puts json_data
  end


  test "should get activities list snapshot" do
    get activities_snapshot_list_path, params: {page: 1, per_page_num: Activity.count}
    assert_response :success
  end

end
