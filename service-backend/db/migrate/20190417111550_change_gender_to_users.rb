class ChangeGenderToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :gender, :integer, null: true
  end
end
