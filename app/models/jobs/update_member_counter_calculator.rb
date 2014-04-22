module Jobs
  class UpdateMemberCountCalculator
  	include Resque::Plugins::UniqueJob
    @queue = :counters

    def self.perform
      MemberCountCalculator.update_all_counts!
    end
  end
end
