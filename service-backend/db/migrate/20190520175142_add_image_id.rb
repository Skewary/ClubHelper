class AddImageId < ActiveRecord::Migration[5.1]
  def change
    ActiveRecord::Base.transaction do
      add_column :activities, :post_horizontal_image_id, :integer
      add_column :activities, :post_vertical_image_id, :integer
      add_column :articles, :cover_image_id, :integer
      add_column :clubs, :icon_image_id, :integer

      base_img_dir = 'public/img'
      base_cos_public_image_dir = $cos_public_picture

      Activity.all.each do |activity|
        _post_horizontal_picture_url = activity.post_horizontal_picture_url
        _post_vertical_picture_url = activity.post_vertical_picture_url
        if _post_horizontal_picture_url
          _post_horizontal_image = Image.upload_image!(Rails.root / Path.new("#{base_img_dir}#{_post_horizontal_picture_url}").to_s)
          activity.post_horizontal_image_id = _post_horizontal_image.id
        end
        if _post_vertical_picture_url
          _post_vertical_image = Image.upload_image!(Rails.root / Path.new("#{base_img_dir}#{_post_vertical_picture_url}").to_s)
          activity.post_vertical_image_id = _post_vertical_image.id
        end
        activity.save!
      end
      Article.all.each do |article|
        _cover_picture_url = article.cover_picture_url
        if _cover_picture_url
          _cover_image = Image.upload_image!(Rails.root / Path.new("#{base_img_dir}#{_cover_picture_url}").to_s)
          article.cover_image_id = _cover_image.id
        end
        article.save!
      end
      Club.all.each do |club|
        _icon_url = club.icon_url
        if _icon_url
          _icon_image = Image.upload_image!(Rails.root / Path.new("#{base_img_dir}#{_icon_url}").to_s)
          club.icon_image_id = _icon_image.id
        end
        club.save!
      end
      ClubCategory.all.each do |club_category|
        _icon_url = club_category.icon_url
        if _icon_url
          club_category.icon_url = "#{base_cos_public_image_dir}#{_icon_url}"
        end
        club_category.save!
      end
    end

    remove_column :activities, :post_horizontal_picture_url
    remove_column :activities, :post_vertical_picture_url
    remove_column :articles, :cover_picture_url
    remove_column :clubs, :icon_url
  end
end
