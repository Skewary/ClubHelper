class FeedbacksController < ApplicationController
  before_action :login_only,:user_init
  
  def user_init
    @user = current_user
  end

  def new
    begin
      content = params[:content]
      comment = @user.feedbacks.create!(content: content, response: '-')
      render status: 200, json: response_json(
        true,
        message: "Create feedback success"
      )
    rescue Exception => e
      render status: 400, json: response_json(
          false,
          message: e.message,
      )
    end
  end
end
