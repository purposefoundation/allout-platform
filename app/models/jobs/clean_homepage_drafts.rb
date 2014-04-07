module Jobs
  class CleanHomepageDrafts
    @queue = :counters

    def self.perform
      Homepage.clean_drafts!
    end
  end
end
