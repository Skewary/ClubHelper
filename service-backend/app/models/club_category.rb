class ClubCategory < ApplicationRecord
  has_many :clubs

  validates :name, presence: true, length: {minimum: 1, maximum: 32},
            uniqueness: {case_sensitive: false}
end

