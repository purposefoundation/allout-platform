module Jobs
  class UpdateMemberCountCalculator
    @queue = :counters

    def self.perform
      MemberCountCalculator.update_all_counts!
    end
  end
end
