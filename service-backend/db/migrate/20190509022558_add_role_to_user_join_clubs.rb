class AddRoleToUserJoinClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :user_join_clubs, :role, :integer, null: false
    add_index :user_join_clubs, [:role]
    add_index :user_join_clubs, [:user_id, :role]
    add_index :user_join_clubs, [:club_id, :role]
  end
end
