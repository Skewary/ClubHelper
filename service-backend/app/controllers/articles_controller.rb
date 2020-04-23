class ArticlesController < ApplicationController
  before_action :login_only

  def get_latest_news_list # 按照请求的页数和每页的记录数, 获得 所有社团 的 最近新闻
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    start_pos = (page - 1) * per_page
    result = Article.joins(:club).where("clubs.is_related_to_wechat = ?", 1)
                 .order(publish_time: :desc, id: :desc)
                 .limit(per_page).offset(start_pos)
    total_num = Article.joins(:club).where("clubs.is_related_to_wechat = ?", 1).count
    is_end = (page >= (total_num * 1.0 / per_page).ceil)
    data = []
    result.each do |news|
      data.append(news.get_article_information_hash)
    end
    render status: 200, json: response_json(
        true,
        message: "Get latest articles successfully!",
        data:
            {
                data_list: data,
                reach_end: is_end
            }
    )
  end

  def get_latest_news_by_kind # 按照请求的页数和每页的记录数, 根据输入社团类别查询新闻
    page = params[:page].to_i
    name = params[:category_name]
    per_page = params[:per_page_num].to_i
    category_id = ClubCategory.find_by_name(name)
    start_pos = (page - 1) * per_page
    result = Article.joins(:club).where("clubs.is_related_to_wechat = ? AND clubs.club_category_id = ?", 1, category_id)
                 .order(publish_time: :desc, id: :desc)
                 .limit(per_page).offset(start_pos)
    total_num = Article.joins(:club).where("clubs.is_related_to_wechat = ? AND clubs.club_category_id = ?", 1, category_id).count
    is_end = (page >= (total_num * 1.0 / per_page).ceil)
    data = []
    result.each do |news|
      data.append(news.get_article_information_hash)
    end
    render status: 200, json: response_json(
        true,
        message: "Get latest articles successfully!",
        data:
            {
                data_list: data,
                reach_end: is_end
            }
    )
  end

  def get_latest_news_by_follow # 查询当前用户关注的所有社团的新闻
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    start_pos = (page - 1) * per_page
    #user = User.find_by_id(1)
    user = current_user
    club_list = UserFollowClub.where(user_id: user.id)
    my_club_list = []
    club_list.each do |record|
      my_club_list.append(record.club_id)
    end
    result = Article.joins(:club).where("clubs.is_related_to_wechat = ? AND clubs.id in (?) ", 1, my_club_list)
                 .order(publish_time: :desc, id: :desc)
                 .limit(per_page).offset(start_pos)
    total_num = Article.joins(:club).where("clubs.is_related_to_wechat = ? AND clubs.id in (?) ", 1, my_club_list).count
    is_end = (page >= (total_num * 1.0 / per_page).ceil)
    data = []
    result.each do |news|
      puts news.nil?
      data.append(news.get_article_information_hash)
    end
    render status: 200, json: response_json(
        true,
        message: "Get latest articles successfully!",
        data:
            {
                data_list: data,
                reach_end: is_end
            }
    )
  end

  def get_latest_news_by_join # 查询用户当前join的社团的最新新闻
    page = params[:page].to_i
    per_page = params[:per_page_num].to_i
    start_pos = (page - 1) * per_page
    #user = User.find_by_id(1)
    user = current_user
    club_list = UserJoinClub.where(user_id: user.id)
    my_club_list = []
    club_list.each do |record|
      my_club_list.append(record.club_id)
    end
    result = Article.joins(:club).where("clubs.is_related_to_wechat = ? AND clubs.id in (?) ", 1, my_club_list)
                 .order(publish_time: :desc, id: :desc)
                 .limit(per_page).offset(start_pos)
    total_num = Article.joins(:club).where("clubs.is_related_to_wechat = ? AND clubs.id in (?) ", 1, my_club_list).count
    is_end = (page >= (total_num * 1.0 / per_page).ceil)
    data = []
    result.each do |news|
      puts news.nil?
      data.append(news.get_article_information_hash)
    end
    render status: 200, json: response_json(
        true,
        message: "Get latest articles successfully!",
        data:
            {
                data_list: data,
                reach_end: is_end
            }
    )
  end
end
