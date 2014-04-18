module RemoveDuplicatesFromPage
	extend ActiveSupport::Concern
	def can_remove_from_page?(page)
	  Rails.cache.fetch("does_content_module_#{id}_on_page_#{page.id}_have_duplicates?", expires_in: 24.hours, raw: true) do
	    page.content_modules.where(:type => self.type).where(:language_id => self.language_id).count > 1
	  end
	end
end