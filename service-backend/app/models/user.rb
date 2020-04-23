class User < ApplicationRecord
  belongs_to :college, optional: true
  belongs_to :political_status, optional: true

  has_many :user_follow_clubs, dependent: :destroy
  has_many :followed_clubs, through: :user_follow_clubs, source: :club
  has_many :user_join_clubs, dependent: :destroy
  has_many :joined_clubs, through: :user_join_clubs, source: :club
  has_many :user_join_activities, dependent: :destroy
  has_many :joined_activities, through: :user_join_activities, source: :activity
  has_many :user_follow_activities, dependent: :destroy
  has_many :followed_activities, through: :user_follow_activities, source: :activity
  has_many :user_follow_posts, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :followed_posts, through: :user_follow_posts, source: :post
  has_many :user_pro_post_comments, dependent: :destroy
  has_many :proed_post_comments, through: :user_pro_post_comments, source: :post_comment
  has_many :activity_comments, dependent: :destroy
  has_many :user_pro_activity_comments, dependent: :destroy
  has_many :proed_activity_comments, through: :user_pro_activity_comments, source: :activity_comment
  has_many :user_pro_activities, dependent: :destroy
  has_many :proed_activities, through: :user_pro_activities, source: :activity
  has_many :join_club_requests, dependent: :destroy, class_name: :UserJoinClubRequest, foreign_key: :user_id
  has_many :feedbacks, dependent: :destroy

  validates :nickname, presence: true, length: {minimum: 1}
  validates :username, presence: true, length: {minimum: 1, maximum: 64},
            uniqueness: {case_sensitive: false}
  validates :real_name, presence: true, length: {minimum: 1, maximum: 16}, allow_nil: true
  validates :student_id, presence: true, length: {minimum: 1, maximum: 16},
            uniqueness: {case_sensitive: false}, allow_nil: true
  validates :email, length: {minimum: 1, maximum: 255},
            format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
            uniqueness: {case_sensitive: false}, allow_nil: true
  validates :password, presence: true, length: {minimum: 6}, on: :create

  module Status
    extend ApplicationRecord::ApplicationConstants

    LOCKED = 0
    NORMAL = 1
  end
  validates :status, presence: true, inclusion: {in: Status.constant_values}

  module Role
    extend ApplicationRecord::ApplicationConstants

    GUEST = 0
    STUDENT = 1
    ADMIN = 2
    ROOT = 3
  end
  validates :role, presence: true, inclusion: {in: Role.constant_values}

  module Gender
    extend ApplicationRecord::ApplicationConstants

    # SECRET = 0
    MALE = 1
    FEMALE = 2
  end
  validates :gender, presence: true, inclusion: {in: Gender.constant_values}, allow_nil: true
  validates :id_number, presence: true, length: {maximum: 18, minimum: 18},
            format: {with: /\A\d{17}[\dX]\z/i}, allow_nil: true

  validates :open_id, presence: true, uniqueness: {case_sensitive: true}, allow_nil: true
  validates :union_id, presence: true, uniqueness: {case_sensitive: true}, allow_nil: true

  DEFAULT_POLITICAL_STATUS_CODE = 2
  before_validation do
    self.nickname ||= self.username
    self.status ||= Status::NORMAL
    self.role ||= Role::GUEST
    self.political_status_id ||= PoliticalStatus
                                     .find_by(code: DEFAULT_POLITICAL_STATUS_CODE).id
    self.id_number.upcase! if self.id_number.present?

    if self.nickname
      self.nickname = filter_four_byte_chars self.nickname
      self.nickname = self.open_id unless self.nickname.present?
    end
  end

  before_validation on: [:create] do
    if self.password.nil? && self.password_confirmation.nil?
      self.password = timestamp_random_sha1
      self.password_confirmation = self.password
    end
  end

  def is_normal? # 是否正常
    self.status == Status::NORMAL
  end

  def is_locked? # 是否被锁定
    self.status == Status::LOCKED
  end

  def is_guest? # 是否为访客
    is_normal? && (self.role == Role::GUEST)
  end

  def is_student? # 是否是学生
    is_normal? && ([Role::STUDENT, Role::ADMIN, Role::ROOT].include?(self.role))
  end

  def is_admin?
    is_normal? && ([Role::ADMIN, Role::ROOT].include?(self.role))
  end

  def is_root? # 是否为root
    is_normal? && (self.role == Role::ROOT)
  end

  # 用户密码支持
  has_secure_password

  # 会话保存支持
  attr_accessor :remember_token

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def self.find_by_username_or_email(username) # 根据名称或者邮箱寻找用户
    by_username = self.where("LOWER(username) = LOWER(?)", username)
    by_email = self.where("LOWER(email) = LOWER(?)", username)
    by_username.or(by_email).first
  end

  def is_member_of_club?(club)
    joined_clubs.include?(club)
  end

  def is_follower_of_club?(club)
    followed_clubs.include?(club)
  end

  def follow_club(club)
    user_follow_clubs.find_or_create_by(club_id: club.id, user_id: self.id)
  end

  def unfollow_club(club)
    record = user_follow_clubs.find_by(club_id: club.id, user_id: self.id)
    if !record.nil?
      record.destroy
    end
  end

  def follow_activity(activity)
    user_follow_activities.find_or_create_by(activity_id: activity.id, user_id: self.id)
  end

  def unfollow_activity(activity)
    record = user_follow_activities.find_by(activity_id: activity.id, user_id: self.id)
    if !record.nil?
      record.destroy
    end
  end

  def is_follower_of_activity?(activity)
    self.followed_activities.include?(activity)
  end

  def pro_activity(activity)
    user_pro_activities.find_or_create_by(activity_id: activity.id, user_id: self.id)
  end

  def unpro_activity(activity)
    record = user_pro_activities.find_by(activity_id: activity.id, user_id: self.id)
    if !record.nil?
      record.destroy
    end
  end

  def is_pro_activity?(activity)
    self.proed_activities.include?(activity)
  end

  def pro_activity_comment(comment)
    user_pro_activity_comments.create!(activity_comment_id: comment.id)
  end

  def unpro_activity_comment(comment)
    user_pro_activity_comments.find_by(activity_comment_id: comment.id).destroy
  end

  def get_user_info
    political_status = self.political_status.nil? ? nil : self.political_status.name
    college = self.college.nil? ? nil : self.college.name
    {
        id: self.id,
        user_name: self.username,
        nickname: self.nickname,
        portrait_url: self.avatar_url,
        is_student: self.is_student?,
        right_level: User::Role.value_to_key(self.role),
        real_name: self.real_name,
        phone: self.phone_number,
        gender: User::Gender.value_to_key(self.gender),
        political_status: political_status,
        college: college,
        student_id: self.student_id
    }
  end

  def get_admin_list
    UserJoinClub.where(user_id: self.id, role: [Role::ADMIN, Role::ROOT]).
        group(:club_id).count.keys
  end

  private

  include EncodingHelper
  extend EncodingHelper
end
