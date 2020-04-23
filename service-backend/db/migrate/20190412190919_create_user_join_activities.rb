class CreateUserJoinActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :user_join_activities do |t|
      t.references :user, foreign_key: true
      t.references :activity, foreign_key: true

      t.index [:user_id, :activity_id]
      t.index [:activity_id, :user_id]

      t.timestamps
    end
  end
end
