class Post < ApplicationRecord
  belongs_to :club
  belongs_to :user
  has_many :comments, dependent: :destroy, class_name: :PostComment, foreign_key: :post_id
  has_many :user_follow_posts, dependent: :destroy
  has_many :follow_users, through: :user_follow_posts, source: :user

  validates :club_id, presence: true
  validates :title, presence: true, length: {minimum: 3, maximum: 128}
  validates :content, presence: true, length: {minimum: 1, maximum: 65536}

  module Category
    extend ApplicationRecord::ApplicationConstants

    NORMAL = 0 # 普通
    ESSENTIAL = 1 # 精品
    TOP = 2 # 置顶
  end
  validates :category, presence: true, inclusion: {in: Category.constant_values}

  module Status
    extend ApplicationRecord::ApplicationConstants

    NORMAL = 0 # 普通
    CLOSED = 1 # 已关闭（禁止继续跟帖）
    HIDDEN = 2 # 隐藏（仅对管理员展示，普通用户无权访问）
  end
  validates :status, presence: true, inclusion: {in: Status.constant_values}

  before_validation do
    self.category ||= Category::NORMAL
    self.status ||= Status::NORMAL
  end

  def get_post_detail_info
    identity = UserJoinClub.find_by(user_id: self.user.id, club_id: self.club.id)
    if identity.nil?
      identity = UserJoinClub::Role.value_to_key(UserJoinClub::Role::NOT_MEMBER)
    else
      identity = UserJoinClub::Role.value_to_key(identity.role)
    end
    user = self.user
    {
        id: self.id,
        user_name: user.nickname,
        user_identity: identity,
        portrait_url: user.avatar_url,
        content: self.content,
        answers_count: self.comments.count,
        last_update_time: calculate_past_time(self.updated_at),
        answers_list: self.comments.order(status: :desc, created_at: :desc).map(&:get_comment_info),
        set_top: self.category == Category::TOP
    }
  end

  def get_post_brief_info
    {
        id: self.id,
        content: self.content,
        answers_count: self.comments.count,
        last_update_time: calculate_past_time(self.created_at),
        top_answer: (self.comments.order(status: :desc, created_at: :desc).first.nil?) ? " " :
                        (self.comments.order(status: :desc, created_at: :desc).first.content),
        set_top: self.category == Category::TOP
    }
  end

end
