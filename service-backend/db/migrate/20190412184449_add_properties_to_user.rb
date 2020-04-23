class AddPropertiesToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :gender, :integer, null: false
    add_column :users, :phone_number, :string
    add_column :users, :id_number, :string

    add_index :users, [:gender]
    add_index :users, [:phone_number]
    add_index :users, [:id_number]
  end
end
