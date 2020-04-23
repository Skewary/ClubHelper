class ChangeEndTimeOnActivities < ActiveRecord::Migration[5.1]
  def up
    change_column :activities, :end_time, :datetime, null: true
  end

  def down
    change_column :activities, :end_time, :datetime, null: false
  end
end
