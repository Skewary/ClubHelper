class Article < ApplicationRecord
  belongs_to :club

  validates :title, presence: true, length: {minimum: 1, maximum: 64}
  validates :publish_time, presence: true

  before_validation do
    self.publish_time ||= Time.now
  end

  def get_article_information_hash
    {
        id: self.id,
        news_picture: self.cover_picture_url,
        news_title: self.title,
        club_name: self.club.name,
        club_id: self.club.id,
        club_category: self.club.club_category.name,
        article_time: calculate_past_time(self.publish_time),
        news_url: self.original_url
        #read_frequency: news.read_freq
    }
  end

  def cover_picture_url
    _image = Image.find_by(id: cover_image_id)
    if _image
      _image.download_url
    else
      nil
    end
  end
end
