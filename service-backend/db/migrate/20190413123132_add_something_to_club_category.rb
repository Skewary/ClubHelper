class AddSomethingToClubCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :club_categories, :icon_url, :string
  end
end
