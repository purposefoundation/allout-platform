module Jobs
  class UpdateShareCache
  	include Resque::Plugins::UniqueJob
    @queue = :update_share_cache
  	extend Resque::Plugins::ExponentialBackoff

    def self.perform(page_id)
      Share.refresh_cache(page_id)
    end
  end
end