class CreateUserProActivityComments < ActiveRecord::Migration[5.1]
  def change
    create_table :user_pro_activity_comments do |t|
      t.references :user, foreign_key: true
      t.references :activity_comment, foreign_key: true

      t.timestamps
    end
  end
end
