class CreateActivityComments < ActiveRecord::Migration[5.1]
  def change
    create_table :activity_comments do |t|
      t.text :content
      t.references :activity, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
