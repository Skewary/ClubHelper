class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :real_name, null: false
      t.string :student_id, null: false
      t.string :email, null: false
      t.string :tag
      t.integer :role, null: false
      t.integer :status, null: false
      t.string :password_digest
      t.string :remember_digest

      t.string :open_id, null: false
      t.string :union_id
      t.string :session_key

      t.index [:real_name]
      t.index [:student_id]
      t.index [:email]
      t.index [:role]
      t.index [:open_id]
      t.index [:union_id]

      t.timestamps
    end
  end
end
