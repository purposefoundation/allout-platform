# == Schema Information
#
# Table name: unique_activity_by_emails
#
#  id          :integer          not null, primary key
#  email_id    :integer
#  activity    :string(64)
#  total_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# This is an aggregation table created for performance reasons
# It consists of push-related stats
#
class UniqueActivityByEmail < ActiveRecord::Base
  def self.update!
    only_events_created_after = self.last_updated_time
    time_now = Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')

    update_other_activities only_events_created_after, time_now
    update_email_activities only_events_created_after, time_now
  end

  def self.force_update!(start_date, end_date)
    only_events_created_after = start_date.to_datetime.utc.strftime('%Y-%m-%d %H:%M:%S')
    only_events_created_before = end_date.to_datetime.utc.strftime('%Y-%m-%d %H:%M:%S')
    self.where(:updated_at => only_events_created_after..only_events_created_before).delete_all
    time_now = Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')

    update_other_activities_between only_events_created_after, only_events_created_before, time_now
    update_email_activities_between only_events_created_after, only_events_created_before, time_now
  end

  def self.force_update_all!
    delete_all
    current_date = Date.parse("1/1/2008")
    while current_date <= Date.current do
      next_date = current_date + 7.days
      UniqueActivityByEmail.force_update!(current_date, next_date)
      current_date = next_date
    end
  end

  def self.reset!
    delete_all
    update!
  end

  private

  def self.update_other_activities(last_updated_at, time_now)
    sql = <<-SQL
      INSERT INTO `#{self.table_name}` (email_id, activity, total_count, updated_at)
      SELECT email_id, activity, COUNT(DISTINCT email_id, activity, user_id) as count, TIMESTAMP('#{time_now}', '%d-%m-%Y %h:%i:%s')
        FROM `#{UserActivityEvent.table_name}`
        WHERE email_id IS NOT NULL
        AND activity NOT IN ('email_viewed', 'email_sent', 'email_clicked', 'email_spammed')
        AND created_at > '#{last_updated_at}'
        GROUP BY email_id, activity
        ON DUPLICATE KEY UPDATE total_count = total_count + VALUES(total_count), updated_at = TIMESTAMP('#{time_now}', '%d-%m-%Y %h:%i:%s');
    SQL

    self.connection.execute(sql)
  end

  def self.pushes_with_emails_in_last_30_days(time_now)
    Push.find_by_sql <<-SQL
      SELECT *
      FROM #{Push.table_name}
      WHERE id IN (
        SELECT DISTINCT(p.id)
        FROM `#{Push.table_name}` p
        JOIN `#{Blast.table_name}` b ON b.push_id = p.id
        JOIN `#{Email.table_name}` e ON e.blast_id = b.id
        WHERE e.updated_at > TIMESTAMP('#{time_now}') - INTERVAL 30 day
      )
    SQL
  end

  def self.update_email_activities(last_updated_at, time_now)
    pushes_with_emails_in_last_30_days(time_now).each do |push|
      update_email_activities_by_push(push, last_updated_at, time_now)
    end
  end

  def self.update_email_activities_by_push(push, last_updated_at, time_now)
    self.connection.execute query_for_activity_stats_by_push(push.id, last_updated_at, time_now, UserActivityEvent::Activity::EMAIL_SENT)
    self.connection.execute query_for_activity_stats_by_push(push.id, last_updated_at, time_now, UserActivityEvent::Activity::EMAIL_VIEWED)
    self.connection.execute query_for_activity_stats_by_push(push.id, last_updated_at, time_now, UserActivityEvent::Activity::EMAIL_CLICKED)
    self.connection.execute query_for_activity_stats_by_push(push.id, last_updated_at, time_now, UserActivityEvent::Activity::EMAIL_SPAMMED)
  end

  def self.query_for_activity_stats_by_push(push_id, last_updated_at, time_now, activity)
    "INSERT INTO #{self.table_name} (email_id, activity, total_count, updated_at)
     SELECT email_id, '#{activity.to_s}', count(distinct email_id, user_id) as count, TIMESTAMP('#{time_now}', '%d-%m-%Y %h:%i:%s')
     FROM #{Push.activity_class_for(activity).table_name}
     WHERE push_id = #{push_id}
     AND created_at > '#{last_updated_at}'
     GROUP BY email_id
     ON DUPLICATE KEY UPDATE total_count = total_count + VALUES(total_count), updated_at = TIMESTAMP('#{time_now}', '%d-%m-%Y %h:%i:%s');"
  end

  def self.last_updated_time
    result = select("MAX(updated_at) AS updated_at").first.try(:updated_at) || Time.at(0)
    result.to_formatted_s(:db)
  end

  def self.update_other_activities_between(last_updated_at, upper_limit, time_now)
    sql = <<-SQL
      INSERT INTO `#{self.table_name}` (email_id, activity, total_count, updated_at)
      SELECT email_id, activity, COUNT(DISTINCT email_id, activity, user_id) as count, MAX(created_at)
        FROM `#{UserActivityEvent.table_name}`
        WHERE email_id IS NOT NULL
        AND activity NOT IN ('email_viewed', 'email_sent', 'email_clicked', 'email_spammed')
        AND created_at > '#{last_updated_at}'
        AND created_at < '#{upper_limit}'
        GROUP BY email_id, activity
        ON DUPLICATE KEY UPDATE total_count = total_count + VALUES(total_count), updated_at = TIMESTAMP('#{upper_limit}', '%d-%m-%Y %h:%i:%s');
    SQL

    self.connection.execute(sql)
  end

  def self.pushes_with_emails_in_range(start_date, end_date)
    Push.find_by_sql <<-SQL
      SELECT *
      FROM #{Push.table_name}
      WHERE id IN (
        SELECT DISTINCT(p.id)
        FROM `#{Push.table_name}` p
        JOIN `#{Blast.table_name}` b ON b.push_id = p.id
        JOIN `#{Email.table_name}` e ON e.blast_id = b.id
        WHERE e.updated_at > TIMESTAMP('#{start_date}')
        AND e.updated_at < TIMESTAMP('#{end_date}')
      )
    SQL
  end

  def self.update_email_activities_between(last_updated_at, upper_limit, time_now)
    pushes_with_emails_in_range(last_updated_at, upper_limit).each do |push|
      update_email_activities_by_push_between(push, last_updated_at, upper_limit, time_now)
    end
  end

  def self.update_email_activities_by_push_between(push, last_updated_at, upper_limit, time_now)
    self.connection.execute query_for_activity_stats_by_push_between(push.id, last_updated_at, upper_limit, time_now, UserActivityEvent::Activity::EMAIL_SENT)
    self.connection.execute query_for_activity_stats_by_push_between(push.id, last_updated_at, upper_limit, time_now, UserActivityEvent::Activity::EMAIL_VIEWED)
    self.connection.execute query_for_activity_stats_by_push_between(push.id, last_updated_at, upper_limit, time_now, UserActivityEvent::Activity::EMAIL_CLICKED)
    self.connection.execute query_for_activity_stats_by_push_between(push.id, last_updated_at, upper_limit, time_now, UserActivityEvent::Activity::EMAIL_SPAMMED)
  end

  def self.query_for_activity_stats_by_push_between(push_id, last_updated_at, upper_limit, time_now, activity)
    "INSERT INTO #{self.table_name} (email_id, activity, total_count, updated_at)
     SELECT email_id, '#{activity.to_s}', count(distinct email_id, user_id) as count, MAX(created_at)
     FROM #{Push.activity_class_for(activity).table_name}
     WHERE push_id = #{push_id}
     AND created_at > '#{last_updated_at}'
     AND created_at < '#{upper_limit}'
     GROUP BY email_id
     ON DUPLICATE KEY UPDATE total_count = total_count + VALUES(total_count), updated_at = TIMESTAMP('#{upper_limit}', '%d-%m-%Y %h:%i:%s');"
  end
end
