class AddPostUrlsToActivity < ActiveRecord::Migration[5.1]
  def change
    remove_column :activities, :post_picture_url
    add_column :activities, :post_horizontal_picture_url, :string
    add_column :activities, :post_vertical_picture_url, :string
  end
end
