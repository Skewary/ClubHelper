class AddApplyEvaluateBooleanToClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :clubs, :has_activities_applying, :boolean, null: false
    add_column :clubs, :has_activities_unevaluated, :boolean, null: false
  end
end
