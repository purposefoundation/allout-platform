module Jobs
  class CleanPreviewPages
    @queue = :counters

    def self.perform
      Page.clean_preview_pages!
    end
  end
end
