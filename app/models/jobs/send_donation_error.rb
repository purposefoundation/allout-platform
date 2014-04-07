module Jobs
  class SendDonationError
    #extend Resque::Plugins::Retry
    #@retry_limit = 2
    #@retry_delay = 1200
    @queue = :send_user_email

    def self.perform(params)
      params["movement"] = Movement.find(params["movement"])
      params["action_page"] = Page.find(params["action_page"])
      donation_error = DonationError.new(params.symbolize_keys!)
      mailer_pay = PaymentErrorMailer.report_error(donation_error)
      mailer_pay.deliver
    end
  end
end
