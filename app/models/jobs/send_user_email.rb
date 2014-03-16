module Jobs
  class SendUserEmail
  	extend Resque::Plugins::ExponentialBackoff
    @queue = :send_user_email

    def self.perform(user_email_id)
      UserEmail.find(user_email_id).async_send!
    end
  end
end