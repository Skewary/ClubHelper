require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test  "should log in " do
      post '/session/login', params:
          {
          username: "787797770@qq.com",
          password: "password",
          remember: "yes"
          }
      assert_response 200
    get '/session/current'
    assert_match "787797770",@response.body
  end

  test "should not find user" do
    post '/session/login', params:
        {
            username: "787797770@qq.com",
            password: "pasord",
            remember: "yes"
        }
    assert_response 403
  end

    test "should lock user" do
      post '/session/login', params:
          {
              username: "11111@qq.com",
              password: "password",
              remember: "yes"
          }
      assert_response 403
    end

  test "should register" do
    post '/session/register', params:
        {
            username: "aaaa",
            nickname: "nammm",
            real_name: "ral",
            student_id: "1234",
            email: "123748@qq.com",
            gender: 1,
            password: "password",
            password_confirmation: "password"
        }
    assert_response 200
  end

  test "should not register" do
    post '/session/register', params:
        {
            nickname: "nammm",
            real_name: "ral",
            student_id: "1234",
            email: "123748@qq.com",
            gender: 1,
            password: "password"
        }
    assert_response 400
  end



end
