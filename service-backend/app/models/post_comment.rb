class PostComment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :user_pro_post_comments, dependent: :destroy
  has_many :pro_users, through: :user_pro_post_comments, source: :user

  validates :post_id, presence: true
  validates :content, presence: true, length: {minimum: 1, maximum: 4096}

  module Status
    extend ApplicationRecord::ApplicationConstants

    NORMAL = 0
    TOP = 1
  end
  validates :status, presence: true, inclusion: {in: Status.constant_values}

  before_validation do
    self.status ||= Status::NORMAL
  end

  def get_comment_info
    identity = UserJoinClub.find_by(user_id: self.user.id, club_id: self.post.club.id)
    if identity.nil?
      identity = UserJoinClub::Role.value_to_key(UserJoinClub::Role::NOT_MEMBER)
    else
      identity = UserJoinClub::Role.value_to_key(identity.role)
    end
    user = self.user
    {
        id: user.id,
        user_name: user.nickname,
        user_identity: identity,
        portrait_url: user.avatar_url,
        content: self.content,
        time: calculate_past_time(self.created_at),
        set_top: self.status == Status::TOP,
        answer_id: self.id # 需要将id返回方便后面查找关注人数
    }
  end

end
