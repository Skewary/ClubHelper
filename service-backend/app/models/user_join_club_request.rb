class UserJoinClubRequest < ApplicationRecord
  belongs_to :user
  belongs_to :club

  validates :user_id, presence: true
  validates :club_id, presence: true
  validates :message, presence: true, length: {maximum: 128}, allow_blank: true

  module Status
    extend ApplicationRecord::ApplicationConstants

    CONFIRMING = 0 # 正在确认
    REJECTED = 1 # 已拒绝
    ACCEPTED = 2 # 已通过
  end
  validates :status, presence: true, inclusion: {in: Status.constant_values}
end
