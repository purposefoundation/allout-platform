web: bundle exec rails server puma -p $PORT -e ${RACK_ENV-development}
scheduler: bundle exec rake resque:scheduler
resque_blaster_queue: bundle exec rake resque:work QUEUE=blaster_queue
resque: bundle exec rake resque:work QUEUES=send_proof_email,list_cutter_queue,sign_petition,event_tracking,update_share_cache,update_page_action_taken_counter,send_join_email,send_user_email,assign_random_value_to_user,reporting,solr,counters,send_platform_user_email,