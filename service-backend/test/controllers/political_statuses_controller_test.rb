require 'test_helper'

class PoliticalStatusesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get political_statuses_index_url
    assert_response :success
  end

end
