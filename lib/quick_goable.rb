module QuickGoable
  def self.included(base)
    base.searchable :auto_index => false, :auto_remove => false do
      text :name_stored_text_substring, :stored => true do
        name
      end
      integer :movement_id, :stored => true do
        respond_to?(:movement_id) ? send(:movement_id) : movement.try(:id) #TODO 'try' can be removed once we fix data with foreign keys.
      end
      string :to_param, :stored => true
    end

    #after_commit   :resque_solr_update, :if => :persisted?
    #before_destroy :resque_solr_remove

    protected

    def resque_solr_update
      Resque.enqueue(Jobs::SolrUpdate, self.class.to_s, id)
    end

    def resque_solr_remove
      Resque.enqueue(Jobs::SolrRemove, self.class.to_s, id)
    end
  end
end
