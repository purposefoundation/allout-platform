class StatsScheduler < ActiveRecord::Base
  def self.schedule_push_stats
    now = Time.zone.now
    6.times do
    	Resque.enqueue_at(now, Jobs::ScheduleStatsUpdate)
      now += 10.minutes
    end
  end
end
