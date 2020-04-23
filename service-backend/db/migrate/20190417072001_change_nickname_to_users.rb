class ChangeNicknameToUsers < ActiveRecord::Migration[5.1]
  def up
    ApplicationRecord.transaction do
      User.all.each {|user| user.save!}
      change_column :users, :nickname, :string, null: false
    end
  end

  def down
    change_column :users, :nickname, :string, null: true
  end
end
