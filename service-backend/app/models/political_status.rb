class PoliticalStatus < ApplicationRecord
  has_many :users

  validates :name, presence: true, length: {minimum: 1, maximum: 32},
            uniqueness: {case_sensitive: false}
  validates :code, presence: true, uniqueness: {case_sensitive: false}
end
