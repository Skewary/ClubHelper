class AddColumnToPostsAndPostComments < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :user, foreign_key: true
    add_reference :post_comments, :user, foreign_key: true
    add_index :posts, [:user_id, :club_id]
    add_index :posts, [:club_id, :user_id]
    add_index :post_comments, [:user_id, :post_id]
    add_index :post_comments, [:post_id, :user_id]
  end
end
