module Jobs
  class ScheduleStatsUpdate
    @queue = :stats_update_queue

    def self.perform
    	UniqueActivityByEmail.update!
    end
  end
end