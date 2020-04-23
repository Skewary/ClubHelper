class Club < ApplicationRecord
  belongs_to :club_category
  has_many :user_follow_clubs, dependent: :destroy
  has_many :follow_users, through: :user_follow_clubs, source: :user
  has_many :user_join_clubs, dependent: :destroy
  has_many :join_users, through: :user_join_clubs, source: :user
  has_many :articles, dependent: :destroy
  has_many :club_to_activities, dependent: :destroy
  has_many :activities, through: :club_to_activities
  has_many :posts, dependent: :destroy
  has_many :join_requests, dependent: :destroy, class_name: :UserJoinClubRequest, foreign_key: :club_id
  has_many :club_contain_images, dependent: :destroy
  has_many :album_images, through: :club_contain_images, source: :image

  validates :name, presence: true, length: {minimum: 1, maximum: 32},
            uniqueness: {case_sensitive: false}
  validates :english_name, presence: true, length: {minimum: 1, maximum: 128},
            uniqueness: {case_sensitive: false}, allow_nil: true
  validates :introduction, presence: true, length: {maximum: 65536},
            allow_blank: true
  validates :tags_json, presence: true

  module Level
    extend ApplicationRecord::ApplicationConstants

    UNKNOWN = 0
    ONE_STAR = 1
    TWO_STAR = 2
    THREE_STAR = 3
    FOUR_STAR = 4
    FIVE_STAR = 5
  end
  validates :level, presence: true, inclusion: {in: Level.constant_values}
  # TODO : 建议tags手写一个validation判定标签合法性
  # 具体怎么写问google（中文搜索引擎找到答案的可能性基本没有）

  before_validation do
    self.is_related_to_wechat ||= false
    self.tags ||= []
  end

  def tags=(value)
    self.tags_json = value.to_json
  end

  def tags
    self.tags_json.present? ? self.tags_json.from_json_to_sym : nil
  end

  def detail_information
    {
        id: self.id,
        name: self.name,
        english_name: self.english_name,
        introduction: self.introduction,
        level: self.level,
        followers_count: self.follow_users.count,
        members_count: self.join_users.count,
        category: self.club_category.nil? ? "" : self.club_category.name,
        category_icon: self.club_category.nil? ? "" : self.club_category.icon_url,
        qq_group_number: self.qq_group_number,
        icon_url: self.icon_url,
        wechat_public_account: self.wechat_public_account,
        video_url: self.video_url,
        tags: self.tags,
        introduction_url: self.introduction_url,
        picture_list: self.album_images.collect(&:download_url)
    }
  end

  def brief_information
    {
        id: self.id,
        name: self.name,
        category: self.club_category.nil? ? "" : self.club_category.name,
        level: self.level,
        #followers_count: self.follow_users.count,
        icon_url: self.icon_url,
        applying: self.has_activities_applying,
        unevaluated: self.has_activities_unevaluated
    }
  end

  def icon_url
    _image = Image.find_by(id: icon_image_id)
    if _image
      _image.download_url
    else
      $cos_default_club_logo
    end
  end

end
