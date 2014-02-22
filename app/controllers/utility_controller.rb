class UtilityController < ApplicationController

  def clear_cache
    render :text=>Rails.cache.clear 
  end

end
