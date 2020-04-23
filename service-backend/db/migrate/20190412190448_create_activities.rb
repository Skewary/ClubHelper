class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :position, null: false
      t.text :description
      t.integer :max_people_limit

      t.index [:name]
      t.index [:position]
      t.index [:start_time]
      t.index [:end_time]

      t.timestamps
    end
  end
end
