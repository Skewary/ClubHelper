class CreateColleges < ActiveRecord::Migration[5.1]
  def change
    create_table :colleges do |t|
      t.string :name, null: true, unique: true
      t.integer :code, null: true, unique: true

      t.index [:name]
      t.index [:code]

      t.timestamps
    end
  end
end
