class AddPoliticalStatusToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :political_status, foreign_key: true
  end
end
