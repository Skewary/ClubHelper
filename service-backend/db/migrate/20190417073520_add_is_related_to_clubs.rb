class AddIsRelatedToClubs < ActiveRecord::Migration[5.1]
  def up
    ApplicationRecord.transaction do
      add_column :clubs, :is_related_to_wechat, :boolean, null: false
      Club.all.each {|club| club.save!}
    end
  end

  def down
    remove_column :clubs, :is_related_to_wechat
  end
end
