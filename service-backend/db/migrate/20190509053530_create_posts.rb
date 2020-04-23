class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :club, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.integer :category, null: false
      t.integer :status, null: false

      t.index [:title]
      t.index [:category]
      t.index [:status]
      t.index [:club_id, :title]
      t.index [:club_id, :category]
      t.index [:club_id, :status]

      t.timestamps
    end
  end
end
