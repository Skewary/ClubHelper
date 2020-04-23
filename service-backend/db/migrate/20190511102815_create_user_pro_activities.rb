class CreateUserProActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :user_pro_activities do |t|
      t.references :user, foreign_key: true
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
