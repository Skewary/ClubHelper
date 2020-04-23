class AddNotifiedToUserFollowActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :user_follow_activities, :notified, :boolean
  end
end
