module Jobs
  class SendAutofireEmail
    @queue = :send_user_email

    def self.perform(action_page_id, member_id, additional_tokens)
    	Rails.logger.debug("additional_tokens #{additional_tokens}")
      member = User.find(member_id)
      email = AutofireEmail.find_by_action_page_id_and_language_id(action_page_id, member.language.id)
      SendgridMailer.user_email(email, member, additional_tokens) if (email && email.enabled_and_valid?)
    end
  end
end