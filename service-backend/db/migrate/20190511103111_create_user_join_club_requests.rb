class CreateUserJoinClubRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :user_join_club_requests do |t|
      t.references :user, foreign_key: true
      t.references :club, foreign_key: true
      t.string :message, null: false
      t.integer :status, null: false

      t.index [:user_id, :club_id]
      t.index [:club_id, :user_id]
      t.index [:user_id, :status]
      t.index [:user_id, :club_id, :status]
      t.index [:club_id, :status]
      t.index [:club_id, :user_id, :status]

      t.timestamps
    end
  end
end
