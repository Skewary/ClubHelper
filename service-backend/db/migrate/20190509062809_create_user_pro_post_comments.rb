class CreateUserProPostComments < ActiveRecord::Migration[5.1]
  def change
    create_table :user_pro_post_comments do |t|
      t.references :user, foreign_key: true
      t.references :post_comment, foreign_key: true

      t.index [:user_id, :post_comment_id]
      t.index [:post_comment_id, :user_id]

      t.timestamps
    end
  end
end
