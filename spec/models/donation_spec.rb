# == Schema Information
#
# Table name: donations
#
#  id                     :integer          not null, primary key
#  user_id                :integer          not null
#  content_module_id      :integer          not null
#  amount_in_cents        :integer          not null
#  payment_method         :string(32)       not null
#  frequency              :string(32)       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  active                 :boolean          default(TRUE)
#  last_donated_at        :datetime
#  page_id                :integer          not null
#  email_id               :integer
#  recurring_trigger_id   :string(255)
#  last_tried_at          :datetime
#  identifier             :string(255)
#  receipt_frequency      :string(255)
#  flagged_since          :datetime
#  flagged_because        :string(255)
#  dismissed_at           :datetime
#  currency               :string(255)
#  amount_in_dollar_cents :integer
#  order_id               :string(255)
#  transaction_id         :string(255)
#  subscription_id        :string(255)
#  subscription_amount    :integer
#

require "spec_helper"

describe Donation do
  class RecordingGateway < ActiveMerchant::Billing::BogusGateway
    attr_accessor :added_trigger
    def add_trigger(amount, creditcard, options = {})
      @added_trigger = [amount, creditcard, options]
      super(amount, creditcard, options)
    end
    def delete(options={})
      @added_trigger = nil
    end

    def trigger(amount, options = {})
      @added_trigger[0] = amount
      @added_trigger[2] = options

      super(amount, options)
    end
  end


  def validated_donation(attrs={})
    donation = FactoryGirl.build(:donation)
    donation.attributes = attrs
    donation.valid?
    donation
  end

  def existing_recurring_donation(frequency, post_process_attrs)
    donation = FactoryGirl.create(:donation, :frequency => frequency)
    donation.process!
    donation.update_attributes!(post_process_attrs)
    donation.should have(1).transactions
    donation
  end

  before do
    bank = Money::Bank::Base.new
    def bank.exchange_with(from, to_currency)
      return from if same_currency?(from.currency, to_currency)
      Money.new(from.cents * 2)
    end

    Money.default_bank = bank
  end  

  it "should create a user activity event after a new donation is created" do
    user = FactoryGirl.create(:user)
    content_module = FactoryGirl.create(:donation_module)
    page = FactoryGirl.create(:action_page)
    
    donation = FactoryGirl.create(:donation, :user => user, :action_page => page, :content_module => content_module)

    donation_events = UserActivityEvent.where(:user_response_id => donation.id).all
    donation_events.length.should eql 1
    donation_events.first.user.should eql user
    donation_events.first.content_module.should eql content_module
    donation_events.first.page.should eql page
  end

  it "should allow multiple action_taken user activity events for the same user and donation module" do
    user = FactoryGirl.create(:user)
    content_module = FactoryGirl.create(:donation_module)
    page = FactoryGirl.create(:action_page)
    
    first_donation = FactoryGirl.create(:donation, :user => user, :action_page => page, :content_module => content_module)
    second_donation = FactoryGirl.create(:donation, :user => user, :action_page => page, :content_module => content_module)

    UserActivityEvent.where(:user_id => user.id, :page_id => page.id, :activity => 'action_taken',
                            :content_module_id => content_module.id, :user_response_type => 'Donation').all.count.should == 2
  end

  describe "amounts" do
    it "converts user's currency cents into US dollars" do
      donation = FactoryGirl.create(:donation, :currency => :brl, :amount_in_cents => 235)
      donation.amount_in_dollar_cents.should == 470
    
      donation = FactoryGirl.create(:donation, :currency => :brl, :amount_in_cents => 1)
      donation.amount_in_dollar_cents.should == 2

      donation = FactoryGirl.create(:donation, :currency => :brl, :amount_in_cents => "99")
      donation.amount_in_dollar_cents.should == 198

      donation = FactoryGirl.create(:donation, :currency => :usd, :amount_in_cents => 10)
      donation.amount_in_dollar_cents.should == 10
    end
  end
  
  describe "validation" do
    it "must have a positive amount_in_cents" do
      validated_donation(:amount_in_cents => "10.99").should be_valid
      validated_donation(:amount_in_cents => "0.0").should_not be_valid
      validated_donation(:amount_in_cents => "Ten").should_not be_valid
    end

    it "must have amount_in_cents if active" do
      validated_donation(:amount_in_cents => 0, :active => false).should be_valid
      validated_donation(:amount_in_cents => 0, :active => true).should_not be_valid
      validated_donation(:amount_in_cents => 100, :active => true).should be_valid
    end

    it "must have transaction_id if one off" do
      validated_donation(:frequency => :one_off, :transaction_id => '123456').should be_valid
      validated_donation(:frequency => :one_off, :transaction_id => nil).should_not be_valid
    end

    it "can have nil transaction_id if recurring" do
      validated_donation(:frequency => :monthly, :subscription_id => '123456', :transaction_id => '654321').should be_valid
      validated_donation(:frequency => :monthly, :subscription_id => '123456', :transaction_id => nil).should be_valid
    end
  end

  describe "stats_by_action_page" do

    it "should calculate donation stats by page" do
      a_page = FactoryGirl.create(:action_page)
      a_module = FactoryGirl.create(:donation_module, :pages => [a_page])
      another_page = FactoryGirl.create(:action_page)
      another_module = FactoryGirl.create(:donation_module, :pages => [another_page])

      FactoryGirl.create(:donation, :currency => :usd, :amount_in_cents => 500, :content_module => a_module, :action_page => a_page)
      FactoryGirl.create(:donation, :currency => :usd, :amount_in_cents => 700, :content_module => a_module, :action_page => a_page)
      FactoryGirl.create(:donation, :currency => :usd, :amount_in_cents => 200, :content_module => another_module, :action_page => another_page)

      Donation.stats_by_action_page(a_page.id)[0].should == 2
      Donation.stats_by_action_page(a_page.id)[1].should == 1200

      Donation.stats_by_action_page(another_page.id)[0].should == 1
      Donation.stats_by_action_page(another_page.id)[1].should == 200

    end

    it "should return zero if no donations" do
      a_page = FactoryGirl.create(:action_page)
      a_module = FactoryGirl.create(:donation_module, :pages => [a_page])

      Donation.stats_by_action_page(a_page.id)[0].should == 0
      Donation.stats_by_action_page(a_page.id)[1].should == 0
    end

  end
  describe "#made_to" do
    it "should return the campaign the donation was made to" do
      donation = FactoryGirl.create(:donation, :frequency => "monthly", :subscription_id => '12345')
      donation.made_to.should eql "Dummy Campaign Name"
    end
  end

  it "should calculate the total of donations by page" do
    a_page = FactoryGirl.create(:action_page)
    a_module = FactoryGirl.create(:donation_module, :pages => [a_page])
    another_page = FactoryGirl.create(:action_page)
    another_module = FactoryGirl.create(:donation_module, :pages => [another_page])

    FactoryGirl.create(:donation, :currency => :usd, :amount_in_cents => 500, :content_module => a_module, :action_page => a_page)
    FactoryGirl.create(:donation, :currency => :usd, :amount_in_cents => 700, :content_module => a_module, :action_page => a_page)
    FactoryGirl.create(:donation, :currency => :usd, :amount_in_cents => 200, :content_module => another_module, :action_page => another_page)

    Donation.total_in_dollar_cents_by_action_page(a_page.id).should == 1200
    Donation.total_in_dollar_cents_by_action_page(another_page.id).should == 200
  end

  it "should provide receipt information as a token for autofire emails" do
    a_page = FactoryGirl.create(:action_page)
    a_language = FactoryGirl.create(:language, :iso_code => 'en')
    a_module = FactoryGirl.create(:donation_module, :pages => [a_page], :language => a_language)
    a_user = FactoryGirl.create(:user, :first_name => 'Don', :last_name => 'Ramon', :postcode => '10010', :movement => a_page.movement)

    donation = FactoryGirl.create(:donation,
        :currency => :brl,
        :amount_in_cents => 500000,
        :order_id => 'order123',
        :transaction_id => 'transaction123',
        :frequency => 'one_off',
        :user => a_user,
        :content_module => a_module,
        :action_page => a_page)

    donation.autofire_tokens.should == {
      'DONATION_FREQUENCY'=> '',
      'DONATION_AMOUNT' => 'R$ 5,000.00',
      'DONATION_DATE' => Date.today.to_s,
      'DONATION_TRANSACTION_ID' => 'Transaction ID: transaction123',
      'DONATION_CANCELLATION' => ' '
    }
  end

  it "should provide receipt information (considering donation frequency) as a token for autofire emails" do
    a_page = FactoryGirl.create(:action_page)
    a_language = FactoryGirl.create(:language, :iso_code => 'en')
    a_module = FactoryGirl.create(:donation_module, :pages => [a_page], :language => a_language)
    a_user = FactoryGirl.create(:user, :first_name => 'Don', :last_name => 'Ramon', :postcode => '10010', :movement => a_page.movement)

    donation = FactoryGirl.create(:donation,
                                  :currency => :brl,
                                  :amount_in_cents => 500000,
                                  :subscription_amount => 100000,
                                  :frequency => 'monthly',
                                  :order_id => 'order123',
                                  :transaction_id => 'transaction123',
                                  :subscription_id => 'transaction123',
                                  :user => a_user,
                                  :content_module => a_module,
                                  :action_page => a_page)

    donation.autofire_tokens.should == {
        'DONATION_FREQUENCY'=> 'monthly',
        'DONATION_AMOUNT' => 'R$ 1,000.00',
        'DONATION_DATE' => Date.today.to_s,
        'DONATION_TRANSACTION_ID' => 'Transaction ID: transaction123',
        'DONATION_CANCELLATION' => 'To cancel or modify your recurring donation, email us at donate@allout.org'
    }
  end

  describe "confirm" do
    it "should mark as active" do
      donation = FactoryGirl.create(:donation, :active => false, :order_id => '1123789', :transaction_id => "23423434")

      donation.active.should be_false

      donation.confirm

      donation.active.should be_true
    end
  end

  describe "add_payment" do

    it "should create transaction" do

      donation = FactoryGirl.create(:donation, :active => false, :frequency => :monthly, :amount_in_cents => 10, :currency => 'usd', :subscription_id => '12345', :order_id => '1123789', :transaction_id => "23423434")

      transaction = mock()
      Transaction.should_receive(:new).with(:donation => donation,
          :external_id => donation.transaction_id,
          :invoice_id => donation.order_id,
          :amount_in_cents => 100,
          :currency => donation.currency,
          :successful => true).and_return(transaction)

      transaction.should_receive(:save!)

      transaction_id = "23423434"
      invoice_id = "1123789"
      donation.add_payment(100, transaction_id, invoice_id)

    end

    it "should add payment amount to donation when amount is zero" do
      donation = FactoryGirl.create(:donation, :active => false, :frequency => :monthly, :amount_in_cents => 0, :currency => 'usd', :subscription_id => '12345', :order_id => '1123789', :transaction_id => "23423434")

      donation.amount_in_cents.should == 0

      transaction_id = "23423434"
      invoice_id = "1123789"
      donation.add_payment(100, transaction_id, invoice_id)

      donation.amount_in_cents.should == 100
      donation.amount_in_dollar_cents.should == 100
    end

    it "should add payment amount to donation when amount is greater than zero" do
      donation = FactoryGirl.create(:donation, :active => false, :frequency => :monthly, :amount_in_cents => 100, :currency => 'usd', :subscription_id => '12345', :order_id => '1123789', :transaction_id => "23423434")

      donation.amount_in_cents.should == 100
      donation.amount_in_dollar_cents.should == 100

      transaction_id = "23423434"
      invoice_id = "1123789"
      donation.add_payment(800, transaction_id, invoice_id)

      donation.amount_in_cents.should == 900
      donation.amount_in_dollar_cents.should == 900
    end

    it "should activate donation on initial payment" do
      donation = FactoryGirl.create(:donation, :active => false, :frequency => :monthly, :amount_in_cents => 0, :currency => 'usd', :subscription_id => '12345', :order_id => '1123789', :transaction_id => "23423434")

      donation.active.should be_false

      transaction_id = "23423434"
      invoice_id = "1123789"
      donation.add_payment(100, transaction_id, invoice_id)

      donation.active.should be_true
    end
  end

  describe "a donation created via take action" do
    let(:user) { FactoryGirl.create(:user, :email => 'noone@example.com') }
    let(:ask) { FactoryGirl.create(:donation_module) }
    let(:page) { FactoryGirl.create(:action_page) }
    let(:email) { FactoryGirl.create(:email) }

    let(:successful_purchase_response) do
      <<-XML
        <transaction>
          <amount type="integer">100</amount>
          <on_test_gateway type="boolean">true</on_test_gateway>
          <created_at type="datetime">2013-12-12T22:47:05Z</created_at>
          <updated_at type="datetime">2013-12-12T22:47:05Z</updated_at>
          <currency_code>USD</currency_code>
          <succeeded type="boolean">true</succeeded>
          <state>succeeded</state>
          <token>CtK2hq1rB9yvs0qYvQz4ZVUwdKh</token>
          <transaction_type>Purchase</transaction_type>
          <order_id nil="true"/>
          <ip nil="true"/>
          <description nil="true"/>
          <email nil="true"/>
          <merchant_name_descriptor nil="true"/>
          <merchant_location_descriptor nil="true"/>
          <gateway_specific_fields nil="true"/>
          <gateway_specific_response_fields nil="true"/>
          <gateway_transaction_id>59</gateway_transaction_id>
          <message key="messages.transaction_succeeded">Succeeded!</message>
          <gateway_token>7V55R2Y8oZvY1u797RRwMDakUzK</gateway_token>
          <response>
            <success type="boolean">true</success>
            <message>Successful purchase</message>
            <avs_code nil="true"/>
            <avs_message nil="true"/>
            <cvv_code nil="true"/>
            <cvv_message nil="true"/>
            <pending type="boolean">false</pending>
            <error_code></error_code>
            <error_detail nil="true"/>
            <cancelled type="boolean">false</cancelled>
            <created_at type="datetime">2013-12-12T22:47:05Z</created_at>
            <updated_at type="datetime">2013-12-12T22:47:05Z</updated_at>
          </response>
          <payment_method>
            <token>SvVVGEsjBXRDhhPJ7pMHCnbSQuT</token>
            <created_at type="datetime">2013-11-06T18:28:14Z</created_at>
            <updated_at type="datetime">2013-12-12T22:47:05Z</updated_at>
            <email nil="true"/>
            <data nil="true"/>
            <storage_state>retained</storage_state>
            <last_four_digits>1111</last_four_digits>
            <card_type>visa</card_type>
            <first_name>Gia</first_name>
            <last_name>Hammes</last_name>
            <month type="integer">4</month>
            <year type="integer">2020</year>
            <address1 nil="true"/>
            <address2 nil="true"/>
            <city nil="true"/>
            <state nil="true"/>
            <zip nil="true"/>
            <country nil="true"/>
            <phone_number nil="true"/>
            <full_name>Gia Hammes</full_name>
            <payment_method_type>credit_card</payment_method_type>
            <errors>
            </errors>
            <verification_value></verification_value>
            <number>XXXX-XXXX-XXXX-1111</number>
          </payment_method>
          <api_urls>
          </api_urls>
        </transaction>
      XML
    end

    let(:failed_purchase_response) do
      <<-XML
        <transaction>
          <amount type="integer">100</amount>
          <on_test_gateway type="boolean">false</on_test_gateway>
          <created_at type="datetime">2013-12-21T12:51:49Z</created_at>
          <updated_at type="datetime">2013-12-21T12:51:49Z</updated_at>
          <currency_code>USD</currency_code>
          <succeeded type="boolean">false</succeeded>
          <state>failed</state>
          <token>Hj5BPvWQJ0EPH6egV8hIztWMCOY</token>
          <transaction_type>Purchase</transaction_type>
          <order_id nil="true"/>
          <ip nil="true"/>
          <description nil="true"/>
          <email nil="true"/>
          <merchant_name_descriptor nil="true"/>
          <merchant_location_descriptor nil="true"/>
          <gateway_specific_fields nil="true"/>
          <gateway_specific_response_fields nil="true"/>
          <gateway_transaction_id nil="true"/>
          <message key="messages.payment_method_invalid">The payment method is invalid.</message>
          <gateway_token>GnWTB6GhqChi7VHGQSCgKDUZvNF</gateway_token>
          <payment_method>
            <token>Klrks0iaZLWbKQnDwiB4nBZYob5</token>
            <created_at type="datetime">2013-12-21T12:51:48Z</created_at>
            <updated_at type="datetime">2013-12-21T12:51:48Z</updated_at>
            <email nil="true"/>
            <data nil="true"/>
            <storage_state>cached</storage_state>
            <last_four_digits></last_four_digits>
            <card_type nil="true"/>
            <first_name></first_name>
            <last_name></last_name>
            <month nil="true"/>
            <year nil="true"/>
            <address1 nil="true"/>
            <address2 nil="true"/>
            <city nil="true"/>
            <state nil="true"/>
            <zip nil="true"/>
            <country nil="true"/>
            <phone_number nil="true"/>
            <full_name></full_name>
            <payment_method_type>credit_card</payment_method_type>
            <errors>
              <error attribute="first_name" key="errors.blank">First name can't be blank</error>
              <error attribute="last_name" key="errors.blank">Last name can't be blank</error>
              <error attribute="month" key="errors.invalid">Month is invalid</error>
              <error attribute="year" key="errors.expired">Year is expired</error>
              <error attribute="year" key="errors.invalid">Year is invalid</error>
              <error attribute="number" key="errors.blank">Number can't be blank</error>
            </errors>
            <verification_value></verification_value>
            <number></number>
          </payment_method>
          <api_urls>
          </api_urls>
        </transaction>
      XML
    end

    let(:action_info) do
      {
        :confirmed => false,
        :frequency => :monthly,
        :currency => 'USD',
        :amount => 100,
        :payment_method => 'credit_card',
        :email => @email,
        :transaction_id => 'CtK2hq1rB9yvs0qYvQz4ZVUwdKh',
        :subscription_amount => 100,
        :payment_method_token =>'SvVVGEsjBXRDhhPJ7pMHCnbSQuT',
        :card_last_four_digits => '1111',
        :card_exp_month => '4',
        :card_exp_year => '2020'
      }
    end

    describe "#make_payment_on_recurring_donation" do
      let(:donation) { ask.take_action(user, action_info, page) }

      it "should not call #purchase_on_spreedly if the frequency is :one_off" do
        donation.update_attribute('frequency', :one_off)
        donation.make_payment_on_recurring_donation
        donation.should_not_receive(:purchase_on_spreedly)
      end

      it "should not call #purchase_on_spreedly if the donation is inactive" do
        donation.update_attribute(:active, false)
        donation.should_not_receive(:purchase_on_spreedly)
        donation.make_payment_on_recurring_donation
      end

      #make_payment_on_recurring_donation
      describe "a successful payment" do
        before :each do
          donation.stub(:purchase_on_spreedly) { Spreedly::Transaction.new_from(Nokogiri::XML(successful_purchase_response)) }
        end

        it "should call #add_payment" do
          donation.stub(:enqueue_recurring_payment)
          donation.should_receive(:add_payment)
          donation.make_payment_on_recurring_donation
        end

        it "should call #enqueue_recurring_payment" do
          donation.should_receive(:enqueue_recurring_payment)
          donation.make_payment_on_recurring_donation
        end
      end

      describe "an unsuccessful payment" do
        it "should call #handle_failed_recurring_payment for an unsuccessful payment" do
          donation.stub(:purchase_on_spreedly) { Spreedly::Transaction.new_from(Nokogiri::XML(failed_purchase_response)) }
          donation.should_receive(:handle_failed_recurring_payment)
          donation.make_payment_on_recurring_donation
        end
      end
    end

    # a donation created via take action
    describe "enqueue_recurring_payment" do
      let(:donation) { ask.take_action(user, action_info, page) }

      it "calls Resque.enqueue when a monthly recurring donation is active" do
        donation.active.should == true
        Resque.should_receive(:enqueue)
        donation.enqueue_recurring_payment
      end

      it "does not call Resque.enqueue when a recurring donation is inactive" do
        donation.update_attribute('active', :false)
        Resque.should_not_receive(:enqueue)
        donation.enqueue_recurring_payment
      end

      it "does not call Resque.enqueue for a one_off donation" do
        donation.update_attribute('frequency', :one_off)
        Resque.should_not_receive(:enqueue)
        donation.enqueue_recurring_payment
      end
    end

    # a donation created via take action
    describe "#deactivate" do
      let(:donation) { ask.take_action(user, action_info, page) }

      it "sets the active attribute to false for a donation" do
        donation.active.should == true
        donation.deactivate
        donation.active.should == false
      end
    end

    # a donation created via take action
    describe "#handle_failed_recurring_payment" do
      let(:donation) { ask.take_action(user, action_info, page) }
      let(:transaction) { Spreedly::Transaction.new_from(Nokogiri::XML(failed_purchase_response)) }

      it "should call deactivate on the donation" do
        donation.should_receive(:deactivate)
        donation.handle_failed_recurring_payment(transaction)
      end
    end
  end
end
