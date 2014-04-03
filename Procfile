web: bundle exec rails server puma -p $PORT -e ${RACK_ENV-development}
clock: bundle exec clockwork lib/tasks/clock.rb
scheduler: bundle exec rake resque:scheduler
worker: QUEUE=${DEFAULT_QUEUE-default} bundle exec rake jobs:work
resque_blaster_queue: bundle exec rake resque:work QUEUE=blaster_queue
resque: bundle exec rake resque:work QUEUES=send_proof_email,sign_petition,event_tracking,update_share_cache,update_page_action_taken_counter,send_join_email,send_user_email,assign_random_value_to_user,reporting,list_cutter_queue