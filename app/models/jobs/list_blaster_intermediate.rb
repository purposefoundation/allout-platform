module Jobs
  class ListBlasterIntermediate
  	extend Resque::Plugins::Retry

    @retry_limit = 3
    @retry_delay = 5
    @queue = :list_cutter_queue

    def self.perform(intermediate_result_id)
    	ListIntermediateResult.find(intermediate_result_id).update_results!
    end
  end
end