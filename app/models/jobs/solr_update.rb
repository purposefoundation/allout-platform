module Jobs
	class SolrUpdate
	  @queue = :solr

	  def self.perform(classname, id)
	    classname.constantize.find(id).solr_index
	  end
	end
end