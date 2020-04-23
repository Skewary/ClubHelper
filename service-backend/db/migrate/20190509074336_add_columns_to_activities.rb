class AddColumnsToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :introduction_article_url, :string
    add_column :activities, :introduction_article_title, :string
    add_column :activities, :retrospect_article_url, :string
    add_column :activities, :retrospect_article_title, :string
    add_column :activities, :message_push_time, :datetime
  end
end
