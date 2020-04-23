class UserJoinClub < ApplicationRecord
  belongs_to :user
  belongs_to :club

  validates :user_id, presence: true
  validates :club_id, presence: true

  module Role
    extend ApplicationRecord::ApplicationConstants

    NOT_MEMBER = -1 #非成员
    MEMBER = 0 # 成员
    ADMIN = 1 # 管理员
    MASTER = 2 # 社长
  end
  validates :role, presence: true, inclusion: {in: Role.constant_values}

  def self.user_managing_clubs(user)
    Club.where(id: UserJoinClub.where(user: user).where(role: [Role::ADMIN, Role::MASTER]).collect(&:club_id))
  end

end
