class CreateUserJoinClubs < ActiveRecord::Migration[5.1]
  def change
    create_table :user_join_clubs do |t|
      t.references :user, foreign_key: true
      t.references :club, foreign_key: true

      t.timestamps
    end
  end
end
