class Feedback < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}

  validates :user_id, presence: true
  validates :content, presence: true, length: {minimum: 1, maximum: 4096}
  
end
