module Jobs
  class EmailOpenedEvent
    extend Resque::Plugins::Retry
    @queue = :event_tracking
    @retry_limit = 2
    @retry_delay = 1200

    def self.perform(t)
      email_tracking_hash=EmailTrackingHash.decode(t)
      if email_tracking_hash.valid?
        user =  email_tracking_hash.user
        email = email_tracking_hash.email
        begin
          UserActivityEvent.email_viewed!(user, email)
        rescue Exception => e
          Rails.logger.debug "Failed to Record Email View: #{e}"
        end
      else
        Rails.logger.debug "Invalid Decoded Email Tracking Hash: #{email_tracking_hash}"
        Rails.logger.debug "Invalid tracking hash: #{t}"
      end
    end
  end
end