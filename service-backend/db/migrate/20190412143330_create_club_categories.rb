class CreateClubCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :club_categories do |t|
      t.string :name, null: false, unique: true

      t.index [:name]

      t.timestamps
    end
  end
end
