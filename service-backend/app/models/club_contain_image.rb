class ClubContainImage < ApplicationRecord
  belongs_to :club
  belongs_to :image

  validates :club_id, presence: true
  validates :image_id, presence: true
end
