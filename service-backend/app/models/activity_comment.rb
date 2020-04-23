class ActivityComment < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  has_many :user_pro_activity_comments, dependent: :destroy
  has_many :pro_users, through: :user_pro_activity_comments, source: :user

  validates :activity_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: {minimum: 1, maximum: 4096}
end
