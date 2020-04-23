class AddNicknameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nickname, :string
    rename_column :users, :name, :username
    change_column :users, :real_name, :string, null: true
    change_column :users, :student_id, :string, null: true
    change_column :users, :email, :string, null: true
    change_column :users, :open_id, :string, null: true
  end
end
