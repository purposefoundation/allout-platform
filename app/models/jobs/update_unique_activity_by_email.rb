module Jobs
  class UpdateUniqueActivityByEmail
    @queue = :counters

    def self.perform
      UniqueActivityByEmail.update!
    end
  end
end
