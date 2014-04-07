module Jobs
  class SendPlatformUserEmail
  	extend Resque::Plugins::ExponentialBackoff
    @queue = :send_platform_user_email

    def self.perform(platform_user_id)
      PlatformUserMailer.subscription_confirmation_email(PlatformUser.find(platform_user_id)).deliver
    end
  end
end