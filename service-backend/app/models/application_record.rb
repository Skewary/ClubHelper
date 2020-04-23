class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def error_messages
    self.errors.hash_messages
  end

  protected
  include GlobalHelper
  extend GlobalHelper
end
