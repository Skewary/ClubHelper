module MessagesHelper
  class TemplateMessageHelper
    def self.user_to_key(user, type = 'form_ids')
      "user_#{user.id}_#{type}_key"
    end
  end
end
