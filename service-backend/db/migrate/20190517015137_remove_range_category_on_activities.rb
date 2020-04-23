class RemoveRangeCategoryOnActivities < ActiveRecord::Migration[5.1]
  def change
    remove_column :activities, :range_category
  end
end
