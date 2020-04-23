class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.datetime :publish_time, null: false
      t.string :cover_picture_url
      t.string :original_url
      t.references :club, foreign_key: true

      t.timestamps
    end
  end
end
