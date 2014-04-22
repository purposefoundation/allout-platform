module Jobs
  class UpdateCampaignShareStat
  	include Resque::Plugins::UniqueJob
    @queue = :counters

    def self.perform
      CampaignShareStat.update!
    end
  end
end
