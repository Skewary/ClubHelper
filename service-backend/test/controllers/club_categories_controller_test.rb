require 'test_helper'

class ClubCategoriesControllerTest < ActionDispatch::IntegrationTest



  test "should get index" do
    get '/club_categories/index'
    assert_response :success
  end

  test "should get get_clubs_by_category" do
    get '/club_categories/1/get_clubs'
    assert_response :success
  end

end
