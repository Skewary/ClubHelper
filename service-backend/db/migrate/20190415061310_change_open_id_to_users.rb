class ChangeOpenIdToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :open_id, :string, null: true
  end
end
