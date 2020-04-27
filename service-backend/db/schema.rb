# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200423075001) do

  create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.string "position", null: false
    t.text "description"
    t.integer "max_people_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "need_enroll"
    t.string "introduction_article_url"
    t.string "introduction_article_title"
    t.string "retrospect_article_url"
    t.string "retrospect_article_title"
    t.datetime "message_push_time"
    t.integer "post_horizontal_image_id"
    t.integer "post_vertical_image_id"
    t.integer "rank"
    t.text "reason"
    t.text "suggestion"
    t.integer "review_state", null: false
    t.text "review_reason"
    t.index ["end_time"], name: "index_activities_on_end_time"
    t.index ["name"], name: "index_activities_on_name"
    t.index ["position"], name: "index_activities_on_position"
    t.index ["start_time"], name: "index_activities_on_start_time"
  end

  create_table "activity_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.text "content"
    t.bigint "activity_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activity_comments_on_activity_id"
    t.index ["user_id"], name: "index_activity_comments_on_user_id"
  end

  create_table "activity_evalutions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "club_name"
    t.string "activity_name"
    t.string "rank"
    t.text "reason"
    t.text "suggestion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "title", null: false
    t.datetime "publish_time", null: false
    t.string "original_url"
    t.bigint "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cover_image_id"
    t.index ["club_id"], name: "index_articles_on_club_id"
  end

  create_table "club_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon_url"
    t.index ["name"], name: "index_club_categories_on_name"
  end

  create_table "club_contain_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "club_id"
    t.bigint "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id", "image_id"], name: "index_club_contain_images_on_club_id_and_image_id"
    t.index ["club_id"], name: "index_club_contain_images_on_club_id"
    t.index ["image_id", "club_id"], name: "index_club_contain_images_on_image_id_and_club_id"
    t.index ["image_id"], name: "index_club_contain_images_on_image_id"
  end

  create_table "club_to_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "club_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_club_to_activities_on_activity_id"
    t.index ["club_id"], name: "index_club_to_activities_on_club_id"
  end

  create_table "clubs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name", null: false
    t.string "english_name"
    t.text "introduction"
    t.integer "level", null: false
    t.bigint "club_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "qq_group_number"
    t.string "wechat_public_account"
    t.string "video_url"
    t.boolean "is_related_to_wechat", null: false
    t.string "introduction_url"
    t.string "tags_json", null: false
    t.integer "icon_image_id"
    t.boolean "has_activities_applying", null: false
    t.boolean "has_activities_unevaluated", null: false
    t.index ["club_category_id", "level"], name: "index_clubs_on_club_category_id_and_level"
    t.index ["club_category_id"], name: "index_clubs_on_club_category_id"
    t.index ["level", "club_category_id"], name: "index_clubs_on_level_and_club_category_id"
    t.index ["level"], name: "index_clubs_on_level"
  end

  create_table "colleges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
    t.integer "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_colleges_on_code"
    t.index ["name"], name: "index_colleges_on_name"
  end

  create_table "feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.text "content"
    t.bigint "user_id"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_feedbacks_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "filename", null: false
    t.string "tag"
    t.integer "category", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category", "token"], name: "index_images_on_category_and_token"
    t.index ["category"], name: "index_images_on_category"
    t.index ["tag"], name: "index_images_on_tag"
    t.index ["token"], name: "index_images_on_token"
  end

  create_table "political_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name", null: false
    t.integer "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_political_statuses_on_code"
    t.index ["name"], name: "index_political_statuses_on_name"
  end

  create_table "post_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "post_id"
    t.text "content", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["post_id", "status"], name: "index_post_comments_on_post_id_and_status"
    t.index ["post_id", "user_id"], name: "index_post_comments_on_post_id_and_user_id"
    t.index ["post_id"], name: "index_post_comments_on_post_id"
    t.index ["status"], name: "index_post_comments_on_status"
    t.index ["user_id", "post_id"], name: "index_post_comments_on_user_id_and_post_id"
    t.index ["user_id"], name: "index_post_comments_on_user_id"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "club_id"
    t.string "title", null: false
    t.text "content", null: false
    t.integer "category", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["category"], name: "index_posts_on_category"
    t.index ["club_id", "category"], name: "index_posts_on_club_id_and_category"
    t.index ["club_id", "status"], name: "index_posts_on_club_id_and_status"
    t.index ["club_id", "title"], name: "index_posts_on_club_id_and_title"
    t.index ["club_id", "user_id"], name: "index_posts_on_club_id_and_user_id"
    t.index ["club_id"], name: "index_posts_on_club_id"
    t.index ["status"], name: "index_posts_on_status"
    t.index ["title"], name: "index_posts_on_title"
    t.index ["user_id", "club_id"], name: "index_posts_on_user_id_and_club_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "user_follow_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "notified"
    t.index ["activity_id", "user_id"], name: "index_user_follow_activities_on_activity_id_and_user_id"
    t.index ["activity_id"], name: "index_user_follow_activities_on_activity_id"
    t.index ["user_id", "activity_id"], name: "index_user_follow_activities_on_user_id_and_activity_id"
    t.index ["user_id"], name: "index_user_follow_activities_on_user_id"
  end

  create_table "user_follow_clubs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_user_follow_clubs_on_club_id"
    t.index ["user_id"], name: "index_user_follow_clubs_on_user_id"
  end

  create_table "user_follow_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "user_id"], name: "index_user_follow_posts_on_post_id_and_user_id"
    t.index ["post_id"], name: "index_user_follow_posts_on_post_id"
    t.index ["user_id", "post_id"], name: "index_user_follow_posts_on_user_id_and_post_id"
    t.index ["user_id"], name: "index_user_follow_posts_on_user_id"
  end

  create_table "user_join_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "user_id"], name: "index_user_join_activities_on_activity_id_and_user_id"
    t.index ["activity_id"], name: "index_user_join_activities_on_activity_id"
    t.index ["user_id", "activity_id"], name: "index_user_join_activities_on_user_id_and_activity_id"
    t.index ["user_id"], name: "index_user_join_activities_on_user_id"
  end

  create_table "user_join_club_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "club_id"
    t.string "message", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id", "status"], name: "index_user_join_club_requests_on_club_id_and_status"
    t.index ["club_id", "user_id", "status"], name: "index_user_join_club_requests_on_club_id_and_user_id_and_status"
    t.index ["club_id", "user_id"], name: "index_user_join_club_requests_on_club_id_and_user_id"
    t.index ["club_id"], name: "index_user_join_club_requests_on_club_id"
    t.index ["user_id", "club_id", "status"], name: "index_user_join_club_requests_on_user_id_and_club_id_and_status"
    t.index ["user_id", "club_id"], name: "index_user_join_club_requests_on_user_id_and_club_id"
    t.index ["user_id", "status"], name: "index_user_join_club_requests_on_user_id_and_status"
    t.index ["user_id"], name: "index_user_join_club_requests_on_user_id"
  end

  create_table "user_join_clubs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", null: false
    t.index ["club_id", "role"], name: "index_user_join_clubs_on_club_id_and_role"
    t.index ["club_id"], name: "index_user_join_clubs_on_club_id"
    t.index ["role"], name: "index_user_join_clubs_on_role"
    t.index ["user_id", "role"], name: "index_user_join_clubs_on_user_id_and_role"
    t.index ["user_id"], name: "index_user_join_clubs_on_user_id"
  end

  create_table "user_pro_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_user_pro_activities_on_activity_id"
    t.index ["user_id"], name: "index_user_pro_activities_on_user_id"
  end

  create_table "user_pro_activity_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "activity_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_comment_id"], name: "index_user_pro_activity_comments_on_activity_comment_id"
    t.index ["user_id"], name: "index_user_pro_activity_comments_on_user_id"
  end

  create_table "user_pro_post_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.bigint "user_id"
    t.bigint "post_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_comment_id", "user_id"], name: "index_user_pro_post_comments_on_post_comment_id_and_user_id"
    t.index ["post_comment_id"], name: "index_user_pro_post_comments_on_post_comment_id"
    t.index ["user_id", "post_comment_id"], name: "index_user_pro_post_comments_on_user_id_and_post_comment_id"
    t.index ["user_id"], name: "index_user_pro_post_comments_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "username", null: false
    t.string "real_name"
    t.string "student_id"
    t.string "email"
    t.string "tag"
    t.integer "role", null: false
    t.integer "status", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.string "open_id"
    t.string "union_id"
    t.string "session_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "college_id"
    t.bigint "political_status_id"
    t.integer "gender"
    t.string "phone_number"
    t.string "id_number"
    t.string "nickname", null: false
    t.string "avatar_url"
    t.index ["college_id"], name: "index_users_on_college_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["gender"], name: "index_users_on_gender"
    t.index ["id_number"], name: "index_users_on_id_number"
    t.index ["open_id"], name: "index_users_on_open_id"
    t.index ["phone_number"], name: "index_users_on_phone_number"
    t.index ["political_status_id"], name: "index_users_on_political_status_id"
    t.index ["real_name"], name: "index_users_on_real_name"
    t.index ["role"], name: "index_users_on_role"
    t.index ["student_id"], name: "index_users_on_student_id"
    t.index ["union_id"], name: "index_users_on_union_id"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "activity_comments", "activities"
  add_foreign_key "activity_comments", "users"
  add_foreign_key "articles", "clubs"
  add_foreign_key "club_contain_images", "clubs"
  add_foreign_key "club_contain_images", "images"
  add_foreign_key "club_to_activities", "activities"
  add_foreign_key "club_to_activities", "clubs"
  add_foreign_key "clubs", "club_categories"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "post_comments", "posts"
  add_foreign_key "post_comments", "users"
  add_foreign_key "posts", "clubs"
  add_foreign_key "posts", "users"
  add_foreign_key "user_follow_activities", "activities"
  add_foreign_key "user_follow_activities", "users"
  add_foreign_key "user_follow_clubs", "clubs"
  add_foreign_key "user_follow_clubs", "users"
  add_foreign_key "user_follow_posts", "posts"
  add_foreign_key "user_follow_posts", "users"
  add_foreign_key "user_join_activities", "activities"
  add_foreign_key "user_join_activities", "users"
  add_foreign_key "user_join_club_requests", "clubs"
  add_foreign_key "user_join_club_requests", "users"
  add_foreign_key "user_join_clubs", "clubs"
  add_foreign_key "user_join_clubs", "users"
  add_foreign_key "user_pro_activities", "activities"
  add_foreign_key "user_pro_activities", "users"
  add_foreign_key "user_pro_activity_comments", "activity_comments"
  add_foreign_key "user_pro_activity_comments", "users"
  add_foreign_key "user_pro_post_comments", "post_comments"
  add_foreign_key "user_pro_post_comments", "users"
  add_foreign_key "users", "colleges"
  add_foreign_key "users", "political_statuses"
end
