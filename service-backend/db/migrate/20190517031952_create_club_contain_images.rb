class CreateClubContainImages < ActiveRecord::Migration[5.1]
  def change
    create_table :club_contain_images do |t|
      t.references :club, foreign_key: true
      t.references :image, foreign_key: true

      t.index [:club_id, :image_id]
      t.index [:image_id, :club_id]

      t.timestamps
    end
  end
end
