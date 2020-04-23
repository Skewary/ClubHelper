class AddColumnsToClubs < ActiveRecord::Migration[5.1]
  def change
    ApplicationRecord.transaction do
      add_column :clubs, :introduction_url, :string
      add_column :clubs, :tags_json, :string, null: false
      Club.all.each do |club|
        club.save!
      end
    end
  end
end
