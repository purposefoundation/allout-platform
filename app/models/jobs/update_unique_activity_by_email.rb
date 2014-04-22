module Jobs
  class UpdateUniqueActivityByEmail
  	include Resque::Plugins::UniqueJob
    @queue = :counters

    def self.perform
      UniqueActivityByEmail.update!
    end
  end
end
