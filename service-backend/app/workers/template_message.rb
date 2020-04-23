class TemplateMessage
  include Sidekiq::Worker
  include WechatHelper
  include ApplicationHelper

  def perform
    UserFollowActivity.all.each do |record|
      template_id = 'Ua1ZhFJdMWwaH8wbWkVThtXPCMQ7bQDOGJ9-i5F0uag'
      activity = record.activity
      user = record.user
      unless record.notified
        if Time.now > activity.start_time - 1.day
          response = WechatClient.send_template_message(user, template_id, {
              keyword1: {
                  value: activity.name
              },
              keyword2: {
                  value: activity_time(activity.start_time)
              },
              keyword3: {
                  value: activity.position
              },
              keyword4: {
                  value: activity.description
              }
          })
          if response[:err_code] == 0
            record.notified = true
            record.save
            p "User #{user.id} received a template message"
          else
            p response[:err_msg]
          end
        end
      end
    end
  end
end
