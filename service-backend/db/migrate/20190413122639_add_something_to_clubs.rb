class AddSomethingToClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :clubs, :qq_group_number, :string
    add_column :clubs, :icon_url, :string
    add_column :clubs, :wechat_public_account, :string
    add_column :clubs, :video_url, :string
  end
end
