class UserProActivityComment < ApplicationRecord
  belongs_to :user
  belongs_to :activity_comment
end
