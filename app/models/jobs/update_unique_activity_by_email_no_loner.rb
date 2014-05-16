module Jobs
  class UpdateUniqueActivityByEmailNoLoner
    @queue = :counters

    def self.perform
      current_date = 7.days.ago
	    next_date = 1.day.from_now
	    UniqueActivityByEmail.force_update!(current_date, next_date)
    end
  end
end