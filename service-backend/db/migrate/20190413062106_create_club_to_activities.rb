class CreateClubToActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :club_to_activities do |t|
      t.references :club, foreign_key: true
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
