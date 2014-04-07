require File.expand_path('../../../config/boot',        __FILE__)
require File.expand_path('../../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(5.minutes, 'Update Member Counts') { Resque.enqueue(Jobs::UpdateMemberCountCalculator) }
every(7.minutes, 'Update Campaign Share Stats') { Resque.enqueue(Jobs::UpdateCampaignShareStat) }
every(10.minutes, 'Update Email Blast Stats' ) { Resque.enqueue(Jobs::UpdateUniqueActivityByEmail) }
every(1.day, 'Preview Pages Cleanup', :at => '05:00') { Resque.enqueue(Jobs::CleanPreviewPages) }
every(1.day, 'Homepage draft cleanup', :at => '05:00') { Resque.enqueue(Jobs::CleanHomepageDrafts) }
