class CreateUserFollowPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_follow_posts do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true

      t.index [:user_id, :post_id]
      t.index [:post_id, :user_id]

      t.timestamps
    end
  end
end
