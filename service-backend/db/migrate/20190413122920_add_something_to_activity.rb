class AddSomethingToActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :range_category, :integer, null: false
    add_column :activities, :post_picture_url, :string
    add_column :activities, :need_enroll, :boolean
  end
end
