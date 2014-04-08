module Jobs
  class BlastJob
    @queue = :blaster_queue

    def self.perform(args)
      list = List.find(args['list_id'])
      email = Email.find(args['email_id'])
      options = args['options'].symbolize_keys

      user_ids = list.filter_by_rules_excluding_users_from_push(email, options)
      Rails.logger.debug "LIST_CUTTER_DEBUG: Email ID #{email.id}, sent to #{user_ids.count}"
      email.deliver_blast_in_batches(user_ids)
      email.update_attributes(:sent => true, :sent_at => Time.now.utc)
      email.update_attribute(:run_at, nil)
      email.save!
      list.saved_intermediate_result.update_results_from_sent_email!(email, user_ids.count)
    rescue Exception => e
      email.update_attribute(:run_at, nil)
      PushLog.log_exception(email, "N/A", e)
      raise
    end
  end
end
