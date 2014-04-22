class Api::SendgridController < Api::BaseController
  def event_handler
  	events = JSON.parse(request.body.read)
  	events.each do |each_param|
    	Resque.enqueue(Jobs::SendgridEvent,@movement.id,each_param)
    end
    head :ok
  end
end


#for batching, post as json but is not, just each line is json
# {"email":"foo@bar.com","timestamp":1322000095,"unique_arg":"my unique arg","event":"delivered"}
# {"email":"foo@bar.com","timestamp":1322000096,"unique_arg":"my unique arg","event":"open"}
