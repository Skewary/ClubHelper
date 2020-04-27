class Activity < ApplicationRecord
  has_many :user_join_activities, dependent: :destroy
  has_many :join_users, through: :user_join_activities, source: :user
  has_many :user_follow_activities, dependent: :destroy
  has_many :follow_users, through: :user_follow_activities, source: :user
  has_many :club_to_activities, dependent: :destroy
  has_many :clubs, through: :club_to_activities
  has_many :comments, dependent: :destroy, class_name: :ActivityComment, foreign_key: :activity_id
  has_many :user_pro_activities, dependent: :destroy
  has_many :pro_users, through: :user_pro_activities, source: :user

  validates :name, presence: true, length: {maximum: 64, minimum: 1}
  validates :start_time, presence: true
  # validates :end_time, presence: true
  validates :position, presence: true, length: {maximum: 64, minimum: 1}
  validates :max_people_limit, presence: true, length: {minimum: 1}, allow_nil: true
  # module RangeCategory
  #   extend ApplicationRecord::ApplicationConstants
  #
  #   # UNKNOWN = 0
  #   INNER_CLUB = 1
  #   PUBLIC = 2
  # end
  # validates :range_category, presence: true, inclusion: {in: RangeCategory.constant_values}

  def followers_count
    follow_users.count
  end

  def join_users_count
    join_users.count
  end

  def get_activity_information_hash
    {
        id: self.id,
        name: self.name, #活动名称
        place: self.position, #活动地点
        description: self.description, #活动描述
        start_time: activity_time(self.start_time), #开始时间
        end_time: activity_time(self.end_time), #活动结束时间
        post_url_horizontal: self.post_horizontal_picture_url, #海报横向照片
        post_url_vertical: self.post_vertical_picture_url, #海报纵向照片
        introduction_article_title: self.introduction_article_title,
        introduction_article_url: self.introduction_article_url,
        retrospect_article_title: self.retrospect_article_title,
        retrospect_article_url: self.retrospect_article_url,
        max_people_limit: self.max_people_limit, #活动最大人数
        need_enroll: self.need_enroll, #活动是否需要报名
        host_clubs: self.clubs.collect { |club| {id: club.id, name: club.name} },
        reason:self.reason,
        rank: self.rank,
        suggestion: self.suggestion,
        review_state: self.review_state,
        review_reason: self.review_reason
    }
  end

  def post_horizontal_picture_url
    _image = Image.find_by(id: post_horizontal_image_id)
    if _image
      _image.download_url
    else
      nil
    end
  end

  def post_vertical_picture_url
    _image = Image.find_by(id: post_vertical_image_id)
    if _image
      _image.download_url
    else
      nil
    end
  end
end
