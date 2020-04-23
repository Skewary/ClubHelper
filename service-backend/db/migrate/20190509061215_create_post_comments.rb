class CreatePostComments < ActiveRecord::Migration[5.1]
  def change
    create_table :post_comments do |t|
      t.references :post, foreign_key: true
      t.text :content, null: false
      t.integer :status, null: false

      t.index [:status]
      t.index [:post_id, :status]

      t.timestamps
    end
  end
end
