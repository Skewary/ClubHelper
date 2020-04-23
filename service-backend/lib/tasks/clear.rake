namespace :destroy_database do
  task clean: :environment do
    table = [#College, PoliticalStatus,
        ClubCategory,
        Club, Activity, ActivityComment, Article, Post, PostComment,
        ClubToActivity, User,
        UserFollowClub, UserJoinClub, UserJoinClubRequest,
        UserFollowActivity, UserProActivity, UserJoinActivity,
        UserFollowPost, UserProPostComment,
        UserProActivityComment
    ]
    table.reverse.each do |tb|
      tb.delete_all
    end
  end
end