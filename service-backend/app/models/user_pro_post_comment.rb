class UserProPostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post_comment
end
