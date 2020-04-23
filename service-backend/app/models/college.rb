class College < ApplicationRecord
  has_many :users

  validates :name, presence: true, length: {minimum: 1, maximum: 32},
            uniqueness: {case_sensitive: false}
  validates :code, presence: true, numericality: {
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 79
  }, uniqueness: {case_sensitive: false}
end
