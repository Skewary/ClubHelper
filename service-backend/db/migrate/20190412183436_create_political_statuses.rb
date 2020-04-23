class CreatePoliticalStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :political_statuses do |t|
      t.string :name, null: false, unique: true
      t.integer :code, null: false, unique: true

      t.index [:name]
      t.index [:code]

      t.timestamps
    end
  end
end
