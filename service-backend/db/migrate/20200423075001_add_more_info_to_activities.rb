class AddMoreInfoToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :rank, :integer
    add_column :activities, :reason, :text
    add_column :activities, :suggestion, :text
  end
end
