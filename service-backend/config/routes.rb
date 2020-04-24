Rails.application.routes.draw do

  get 'political_statuses/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :system do
    get :time, to: 'system#system_time', as: :system_time
  end

  scope :session do
    scope :login do
      post '', to: 'session#login', as: :session_login
      post :wechat, to: 'session#login_wechat', as: :session_login_wechat
    end
    scope :register do
      post '', to: 'session#register', as: :session_register
      post :wechat, to: 'session#register_wechat', as: :session_register_wechat
    end
    scope :bind do
      post :wechat, to: 'session#bind_wechat', as: :session_bind_wechat
    end
    scope :student do
      put '', to: 'session#register_as_student', as: :session_register_as_student
    end
    scope :logout do
      delete '', to: 'session#logout', as: :session_logout
    end
    scope :current do
      root to: 'session#current', as: :session_current
      put :avatar, to: 'session#set_avatar', as: :session_set_avatar
    end
  end

  scope :comments do
    scope '/:comment_id' do
      scope '/like' do
        post '', to: 'comments#pro_comment', as: :like_comment
        delete '', to: 'comments#unpro_comment', as: :dislike_comment
      end
    end
  end

  scope :activities do
    scope "/list" do
      get "/hot", to: "activities#hottest_activities_list", as: :activities_hot_list
      get "/followed", to: "activities#followed_list_per_page", as: :activities_followed_list
      scope "/all" do
        get "/sortbyhot", to: "activities#list_hot_sorted_per_page", as: :activities_hot_list_per_page
        scope "/sortbytime" do
          get "", to: "activities#list_time_sorted_per_page", as: :activities_time_list_per_page
          get "/fastsearch", to: "activities#list_snapshot", as: :activities_snapshot_list
        end
      end
    end
    scope "/:activity_id" do
      get '', to: 'activities#information', as: :activities_information
      scope "/follow" do
        post '', to: 'activities#follow_activity', as: :follow_activity
        delete '', to: 'activities#unfollow_activity', as: :unfollow_activity
      end
      scope "/like" do
        post '', to: 'activities#like_activity', as: :like_activities
        delete '', to: 'activities#dislike_activity', as: :dislike_activities
      end
      scope '/comments' do
        post '', to: 'comments#new', as: :comments_new
        get '/sortbytime', to: 'comments#list_comments_per_page', as: :comments_list_sortbytime
      end
      scope '/wxacode' do
        get '', to: 'activities#get_wxacode'
      end
    end
  end

  scope :clubs do
    get "/list", to: 'clubs#get_all_clubs', as: :clubs_list
    get "/name", to: 'clubs#find_by_name', as: :clubs_find_by_name
    get "/followed", to: "clubs#followed_list", as: :clubs_followed_list #用户关注的所有社团
    get "/joined", to: "clubs#joined_list", as: :clubs_joined_list #用户加入的所有社团

    #加入社团的审核表
    get '/join_requests', to: 'clubs#join_requests_list', as: :clubs_join_request_list

    scope '/:club_id' do
      get '/information', to: 'clubs#information', as: :clubs_information #社团详细信息
      get '/brief', to: 'clubs#brief', as: :clubs_brief_information #社团简略
      scope '/list' do
        get '/news', to: 'clubs#news', as: :club_news_list #社团的所有新闻list,按页获取
        get '/activities', to: 'activities#club_activities_list_per_page', as: :clubs_activities_list #社团的所有公开活动
        #查看社员
        get '/members', to: 'clubs#members_list', as: :clubs_members_list
      end
      #加入社团
      post '/join', to: 'clubs#request_join_club', as: :join_club
      post '/follow', to: 'clubs#follow_club', as: :follow_club
      delete '/follow', to: 'clubs#unfollow_club', as: :unfollow_club
      # 问题相关的接口
      scope '/questions' do
        post '', to: 'club_discussions#add_question'
        scope '/:question_id' do
          delete '', to: 'club_discussions#delete_question'
          put '/top', to: 'club_discussions#top_question'
          put '/untop', to: 'club_discussions#untop_question'
        end
        scope '/brief' do
          get '', to: 'club_discussions#get_all_brief_question'
          get '/bypage', to: 'club_discussions#get_brief_question_by_page'
        end
        scope '/detail' do
          get '', to: 'club_discussions#get_all_detail_question'
          get '/bypage', to: 'club_discussions#get_detail_question_by_page'
        end
      end
    end

    # 以下为网页端社团管理接口
    scope :admin do
      scope :login do
        scope :qrcode do
          get :request, to: 'club_management#get_qrcode'
          post :check, to: 'club_management#check_qrcode'
          post :bind, to: 'club_management#bind_qrcode'
          post :verify, to: 'club_management#verify_qrcode'
        end
      end
      get :index, to: 'club_management#club_index'
      post '', to: 'club_management#club_create'
      scope ':club_id' do
        get '', to: 'club_management#club_profile'
        put '', to: 'club_management#club_update'
        delete '', to: 'club_management#club_destroy'
        scope :activity do
          get :index, to: 'club_management#activity_index'
          post '', to: 'club_management#activity_create'
          scope ':activity_id' do
            get '', to: 'club_management#activity_profile'
            put 'update', to: 'club_management#activity_update'
            put 'evaluate', to: 'activities_evaluate#evaluate'
            delete '', to: 'club_management#activity_destroy'
          end
        end
        scope :article do
          get :index, to: 'club_management#article_index'
          post '', to: 'club_management#article_create'
          scope ':article_id' do
            get '', to: 'club_management#article_profile'
            put '', to: 'club_management#article_update'
            delete '', to: 'club_management#article_destroy'
          end
        end
      end
    end
  end
  # 回答帖子的相关接口
  scope :questions do
    scope '/:question_id' do
      scope '/answers' do
        post '', to: 'club_discussions#add_answer'
        scope '/:answer_id' do
          delete '', to: 'club_discussions#delete_answer'
          put 'top', to: 'club_discussions#top_answer'
          put 'untop', to: 'club_discussions#untop_answer'
          scope '/like' do
            post '', to: 'club_discussions#like_answer'
            delete '', to: 'club_discussions#unlike_answer'
          end
        end
      end
    end
  end


  scope :users do
    get '/current', to: 'users#get_current_user_information'

    scope '/edit' do
      put '/phone_number', to: 'users#edit_phone_number'
      put '/political_status', to: 'users#edit_political_status'
    end

    scope '/my_follow_club' do
      scope '/:club_id' do
        post '', to: 'users#add_my_follow_club'
        delete '', to: 'users#remove_my_follow_club'
      end
    end
    scope '/my_follow_activity' do
      scope '/:activity_id' do
        post '', to: 'users#add_my_follow_activity'
        delete '', to: 'users#remove_my_follow_activity'
      end
    end

    scope :authenticate do
      post :unified, to: 'users#unified_authenticate'
    end
    scope '/club' do
      scope '/:club_id' do
        put '/level', to: 'users#update_club_level'
      end
    end
    scope '/admin' do
      scope '/:user_id' do
        scope '/club' do
          scope ':club_id' do
            post '', to: 'users#add_admin'
            delete '', to: 'users#delete_admin'
            get '', to: 'users#show_all_admin' # 显示所有的管理员
          end
        end
      end

      scope '/info' do
        scope '/:user_id' do
          scope '/club' do
            scope '/:club_id' do
              get '', to: 'users#get_user_info' # 社长准备添加管理员查询对应用户的信息
            end
          end
        end
      end

    end

    scope '/member' do
      scope '/joining' do
        scope '/club' do
          get '/:club_id', to: 'users#get_all_joining_user'
        end
      end
      scope '/:user_id' do
        scope '/club' do
          scope ':club_id' do
            post '', to: 'users#accept_member'
            delete '', to: 'users#reject_member'
          end
        end
      end
      scope '/remove' do
        scope '/:user_id' do
          scope '/club' do
            scope '/:club_id' do
              delete '', to: 'users#user_remove_member' # 强制删除某个社员
            end
          end
        end
      end
      scope '/info' do
        scope '/:user_id' do
          scope '/club' do
            scope '/:club_id' do
              get '', to: 'users#get_joining_user_info' # 得到申请入社社员的详细信息以及入社理由
            end
          end
        end
      end
    end

    get '/adminclubs', to: 'users#all_admin_clubs' #当前用户担任社团管理员的所有社团id列表
    get '/chiefclubs', to: 'users#all_cheif_club' # 当前用户担任社长的所有社团
    scope '/chief' do
      scope '/club' do
        get '/all', to: 'users#show_all_club'
        scope '/:club_id' do
          get '', to: 'users#apply_master_token'
          post '', to: 'users#apply_proprieter'
        end
      end
    end
    scope '/students' do
      post '/complete', to: 'users#complete_information'
    end
    scope '/union' do
      post '/clubcategory', to: 'users#add_club_category'
      post '/club', to: 'users#add_club'
    end
    get '/colleges', to: 'users#all_colleges'
    get '/politicalstatus', to: 'users#all_politicalstatus'
  end

  scope :articles do
    scope '/latest_news_list' do
      get '', to: 'articles#get_latest_news_list'
      scope '/category' do
        scope '/:category_name' do
          get '', to: "articles#get_latest_news_by_kind"
        end
      end
      get '/followed', to: "articles#get_latest_news_by_follow"
      get '/joined', to: "articles#get_latest_news_by_join"
    end
  end


  scope :club_categories do
    get 'index', to: 'club_categories#index'
    scope '/:category_id' do
      get '/get_clubs', to: 'club_categories#get_clubs_by_category', as: :club_categories_get_clubs
      get '/get_clubs_sortbystar', to: 'club_categories#clubs_sort_by_star', as: :club_categories_get_clubs_by_star
    end
  end

  scope :political_statuses do
    get 'index', to: 'political_statuses#index'
  end

  scope :image do
    post '', to: 'image#upload', as: :image_upload
    scope ':token' do
      get '', to: 'image#get', as: :image_open
    end
  end
  scope :feedbacks do
    post '', to: 'feedbacks#new', as: :feedbacks_new
  end

  scope :message do
    scope :template do
      post :update, to: 'messages#update_form_id'
    end
  end

end
