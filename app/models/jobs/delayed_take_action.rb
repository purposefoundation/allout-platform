module Jobs
  class DelayedTakeAction
    @queue = :take_action_cache
  
    def self.perform(params, movement_id, action_info, member_id)
    	begin
	    	params.symbolize_keys!
	    	movement = Movement.find(movement_id)
	      @page = movement.find_published_page(params[:id])
	      if member_id
					member = Member.find(member_id)
				else
					member_attributes = (params[:member_info] || params[:platform_member]).merge(:movement_id => movement.id, :language => Language.find_by_iso_code_cache(params[:locale]))
			    member_scope = User.for_movement(movement).where(:email => member_attributes[:email])
			    member = member_scope.first || member_scope.build
			  end
				member.take_action_on!(@page, action_info, member_attributes)
			rescue DuplicateActionTakenError => duplicated_action_taken
				Rails.logger.error "DelayedTakeAction User Already Took Action #{member.inspect}"
			rescue => error
				Rails.logger.error "DelayedTakeAction Error #{error.inspect}" 
			end
    end  
  end
end