module Jobs
	class SolrRemove
	  @queue = :solr

	  def self.perform(classname, id)
	    Sunspot.remove_by_id(classname, id)
	  end
	end
end