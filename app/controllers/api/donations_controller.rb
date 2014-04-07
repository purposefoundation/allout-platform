class Api::DonationsController < Api::BaseController
    def show
        donation = Donation.find_by_subscription_id(params[:subscription_id])

        if !donation
            render :status => 404, :text => "Can't find donation with subscription id #{params[:subscription_id]}"
        else
            render :json => donation.to_json(:include => [:user, :action_page])
        end
    end

	def confirm_payment
    Rails.logger.info('Payment confirmation received')

		donation = Donation.find_by_transaction_id(params[:transaction_id])
		render :status => :not_found, :text => "Can't find donation with transaction id #{params[:transaction_id]}" and return if donation.nil?

		donation.confirm
		render :nothing => true, :status => :ok
	end

	def add_payment
    Rails.logger.info('Payment added')
		donation = Donation.find_by_subscription_id(params[:subscription_id])
		render :status => :not_found, :text => "Can't find donation with subscription id #{params[:subscription_id]}" and return if donation.nil?

		donation.add_payment(params[:amount_in_cents].to_i, params[:transaction_id], params[:order_number])
		render :nothing => true, :status => :ok
	end

  def handle_failed_payment
    Rails.logger.info('Failed Payment notification received')

    page = movement.find_published_page("#{params['action_page']}")
    member = movement.members.find_by_email(params['member_email'])
    donation = Donation.find_by_subscription_id(params['subscription_id'])
    new_params = {:movement => movement.id,
                :action_page => page.id,
                :error_code => params['error_code'],
                :message => params['message'],
                :member_email => params['member_email'],
                :reference => params['reference'],
                :member_first_name => member.first_name,
                :member_last_name => member.last_name,
                :member_country_iso => member.language.iso_code,
                :member_country_iso => member.country_iso,
                :donation_payment_method => donation.payment_method,
                :donation_amount_in_cents => params['donation_amount_in_cents'],
                :donation_currency => donation.currency
                 }

    Resque.enqueue(Jobs::SendDonationError, new_params)

    render :nothing => true, :status => :ok
  end

end
