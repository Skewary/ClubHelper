class ClubCategoriesController < ApplicationController
  before_action :check_category, only: [:clubs_sort_by_star]

  def check_category # 检查输入的社团种类id对应的社团种类是否存在
    id = params[:category_id]
    @category = ClubCategory.find_by(id: id)
    if @category.nil?
      render status: 404, json: response_json(
          false,
          code: ClubCategoryErrorCode::CATEGORY_NOT_EXIST,
          message: "Category not found!"
      )
      false
    else
      true
    end
  end


  def index # 列出所有的社团种类
    data = []
    ClubCategory.find_each do |record|
      data.append(
          {
              id: record.id,
              name: record.name,
              picture_url: record.icon_url
          }
      )
    end

    render status: 200, json: response_json(
        true,
        message: "Get all club categories successfully!",
        data:
            {
                categories: data
            }
    )
  end

  def get_clubs_by_category # 返回输入社团种类对应的所有的社团列表
    data = []
    kind = params[:category_id]
    result = Club.where(:club_category_id => kind)
    result.each do |club|
      data.append(club.brief_information)
    end
    render status: 200, json: response_json(
        true,
        message: "Get all clubs for input category successfully!",
        data:
            {
                clubs: data
            }
    )
  end

  def clubs_sort_by_star # 返回所有的社团列表(按照星级排序)
    clubs = @category.clubs.order(level: :desc).map(&:brief_information)
    render status: 200, json: response_json(
        true,
        message: "Get all clubs sort by star successfully!",
        data:
            {
                clubs: clubs
            }
    )
  end
end
