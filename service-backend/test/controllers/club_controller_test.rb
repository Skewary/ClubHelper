require 'test_helper'

class ClubControllerTest < ActionDispatch::IntegrationTest
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

  test "should find club" do
    club = clubs(:microsoft)
    get clubs_brief_information_path(club.id)
    assert_response 200
    assert_match "mf_club", @response.body
  end

  test "should return follow list" do
    get clubs_followed_list_path
    assert_response 200
    #puts @user.followed_clubs
    #匹配正则表达式
    assert_match "acapella_club", @response.body
  end

  test "should get information" do
    club = clubs(:microsoft)
    #puts club.english_name
    #puts club.detail_information
    get clubs_information_path(club.id)
    assert_response 200
    assert_match "microsoft_club", @response.body
    #puts @response.body
  end

  test "should get clubs list" do
    get clubs_list_path
    assert_response 200
    count = JSON.parse(@response.body)["data"]["clubs"].count
    assert_equal Club.count, count
  end

  test "should get followed club" do
    club = clubs(:badminton)
    @user.follow_club(club)
    get clubs_followed_list_path
    assert_response 200
    id_list = JSON.parse(@response.body)["data"]["clubs"].map {|item| item["id"]}
    assert id_list.include?(club.id)
  end

  test "should send join requests" do
    club = clubs(:badminton)
    post join_club_path(club.id), params: {content: "想加入羽毛球"}
    assert_response 200
    #puts UserJoinClubRequest.find_by(user_id: @user.id, club_id: club.id).message
    assert !UserJoinClubRequest.find_by(user_id: @user.id, club_id: club.id).nil?
  end

  test "should get news list" do
    club = clubs(:badminton)
    get club_news_list_path(club.id), params: {page: 1}
    assert_response 200
    # puts @response.body
    assert_match club.articles.first.title, @response.body
  end

  test "should get activities per page" do
    club = clubs(:badminton)
    get clubs_activities_list_path(club.id), params: {page: 1, per_page_num: 1}
    assert_response 200
    # puts @response.body
    assert_match club.activities.first.name, @response.body
  end

  test "should follow club" do
    club = clubs(:badminton)
    post '/clubs/' + club.id.to_s + '/follow'
    assert !UserFollowClub.find_by(user_id: @user.id, club_id: club.id).nil?
  end

  test "should unfollow club" do
    club = clubs(:acapella)
    @user.follow_club(clubs(:acapella))
    delete '/clubs/' + club.id.to_s + '/follow'
    assert UserFollowClub.find_by(user_id: @user.id, club_id: club.id).nil?
  end

  test "should get members list" do
    club = clubs(:acapella)
    get clubs_members_list_path(club.id)
    puts @response.body
    assert_response 200
    assert_match @user.id.to_s, @response.body
  end


end
