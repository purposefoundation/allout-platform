module Jobs
  class UpdateCampaignShareStat
    @queue = :counters

    def self.perform
      CampaignShareStat.update!
    end
  end
end
