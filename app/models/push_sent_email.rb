# == Schema Information
#
# Table name: push_sent_emails
#
#  movement_id :integer          not null
#  user_id     :integer          not null
#  push_id     :integer          not null
#  email_id    :integer          not null
#  created_at  :datetime
#

class PushSentEmail < ActiveRecord::Base
end
