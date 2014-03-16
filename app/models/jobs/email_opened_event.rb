module Jobs
  class EmailOpenedEvent
    extend Resque::Plugins::Retry
    @queue = :event_tracking
    @retry_limit = 25
    @retry_delay = 120

    def self.perform(t)
      email_tracking_hash=EmailTrackingHash.decode(t)
      if email_tracking_hash.valid?
        user =  email_tracking_hash.user
        email = email_tracking_hash.email
        UserActivityEvent.email_viewed!(user, email)
      else
        raise "Invalid tracking hash: #{t}"
      end
    end
  end
end