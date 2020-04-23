class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :filename, null: false
      t.string :tag
      t.integer :category, null: false
      t.string :token, null: false

      t.index [:tag]
      t.index [:category]
      t.index [:token]
      t.index [:category, :token]

      t.timestamps
    end
  end
end
