module Jobs
  class BlastJob
    extend Resque::Plugins::Retry
    @retry_limit = 2
    @retry_delay = 1200
    @queue = :blaster_queue

    def self.perform(email_id, list_id, options)
      list = List.find(list_id)
      email = Email.find(email_id)

      user_ids = list.filter_by_rules_excluding_users_from_push(email, options)
      email.deliver_blast_in_batches(user_ids)
      email.update_attributes(:sent => true, :sent_at => Time.now.utc)
      email.blast.update_attribute(:run_at, nil)
      email.blast.save!
      list.saved_intermediate_result.update_results_from_sent_email!(email, user_ids.count)
    rescue Exception => e
      email.blast.update_attribute(:run_at, nil)
      PushLog.log_exception(email, "N/A", e)
      raise
    end
  end
end
