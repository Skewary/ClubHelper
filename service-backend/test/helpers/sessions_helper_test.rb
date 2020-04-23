require 'test_helper'
class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:three)
    log_in(@user,true)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert logged_in?
  end

end