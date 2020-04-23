class CreateClubs < ActiveRecord::Migration[5.1]
  def change
    create_table :clubs do |t|
      t.string :name, null: false
      t.string :english_name
      t.text :introduction
      t.integer :level, null: false
      t.references :club_category, foreign_key: true

      t.index [:level]
      t.index [:club_category_id, :level]
      t.index [:level, :club_category_id]

      t.timestamps
    end
  end
end
