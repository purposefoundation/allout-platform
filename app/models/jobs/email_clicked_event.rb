module Jobs
  class EmailClickedEvent
    extend Resque::Plugins::Retry
    @retry_limit = 2
    @retry_delay = 1200
    @queue = :event_tracking

    def self.perform(movement_id,page_type,page_id,t)
      email_tracking_hash = EmailTrackingHash.decode(t)
      if email_tracking_hash.valid?
        movement = Movement.find(movement_id)
        page = (page_type == "Homepage" ? movement.homepage : movement.find_page(page_id))
        user = email_tracking_hash.user
        email = email_tracking_hash.email
        page.register_click_from email, user
      else
        Rails.logger.debug "Invalid Decoded Email Tracking Hash: #{email_tracking_hash}"
        Rails.logger.debug "Invalid tracking hash: #{t}"
      end
    end
  end
end
