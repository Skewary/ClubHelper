class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.text :response

      t.timestamps
    end
    add_index :feedbacks, [:user_id, :created_at]
  end
end
