module Jobs
  class ListBlasterIntermediate
    @queue = :list_cutter_queue

    def self.perform(intermediate_result_id)
    	ListIntermediateResult.find(intermediate_result_id).update_results!
    end
  end
end