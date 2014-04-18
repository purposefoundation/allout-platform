def successful_payment_method_response_xml
  <<-XML
      <payment_method>
        <token>CATQHnDh14HmaCrvktwNdngixMm</token>
        <created_at type="datetime">2013-12-21T12:51:47Z</created_at>
        <updated_at type="datetime">2013-12-21T12:51:47Z</updated_at>
        <email>frederick@example.com</email>
        <data>
          <frequency>weekly</frequency>
          <currency>usd</currency>
          <amount>2000</amount>
        </data>
        <storage_state>cached</storage_state>
        <last_four_digits>1111</last_four_digits>
        <card_type>visa</card_type>
        <first_name>Bob</first_name>
        <last_name>Smith</last_name>
        <month type="integer">1</month>
        <year type="integer">2020</year>
        <address1>345 Main Street</address1>
        <address2>Apartment #7</address2>
        <city>Wanaque</city>
        <state>NJ</state>
        <zip>07465</zip>
        <country>United States</country>
        <phone_number>201-332-2122</phone_number>
        <full_name>Bob Smith</full_name>
        <payment_method_type>credit_card</payment_method_type>
        <errors>
        </errors>
        <verification_value>XXX</verification_value>
        <number>XXXX-XXXX-XXXX-1111</number>
      </payment_method>
  XML
end

def successful_payment_method_response_without_frequency_xml
  <<-XML
      <payment_method>
        <token>CATQHnDh14HmaCrvktwNdngixMm</token>
        <created_at type="datetime">2013-12-21T12:51:47Z</created_at>
        <updated_at type="datetime">2013-12-21T12:51:47Z</updated_at>
        <email>frederick@example.com</email>
        <data>
          <frequency></frequency>
          <currency>usd</currency>
          <amount>2000</amount>
        </data>
        <storage_state>cached</storage_state>
        <last_four_digits>1111</last_four_digits>
        <card_type>visa</card_type>
        <first_name>Bob</first_name>
        <last_name>Smith</last_name>
        <month type="integer">1</month>
        <year type="integer">2020</year>
        <address1>345 Main Street</address1>
        <address2>Apartment #7</address2>
        <city>Wanaque</city>
        <state>NJ</state>
        <zip>07465</zip>
        <country>United States</country>
        <phone_number>201-332-2122</phone_number>
        <full_name>Bob Smith</full_name>
        <payment_method_type>credit_card</payment_method_type>
        <errors>
        </errors>
        <verification_value>XXX</verification_value>
        <number>XXXX-XXXX-XXXX-1111</number>
      </payment_method>
  XML
end

def successful_payment_method_response_without_amount_xml
  <<-XML
      <payment_method>
        <token>CATQHnDh14HmaCrvktwNdngixMm</token>
        <created_at type="datetime">2013-12-21T12:51:47Z</created_at>
        <updated_at type="datetime">2013-12-21T12:51:47Z</updated_at>
        <email>frederick@example.com</email>
        <data>
          <frequency>weekly</frequency>
          <currency>usd</currency>
          <amount></amount>
        </data>
        <storage_state>cached</storage_state>
        <last_four_digits>1111</last_four_digits>
        <card_type>visa</card_type>
        <first_name>Bob</first_name>
        <last_name>Smith</last_name>
        <month type="integer">1</month>
        <year type="integer">2020</year>
        <address1>345 Main Street</address1>
        <address2>Apartment #7</address2>
        <city>Wanaque</city>
        <state>NJ</state>
        <zip>07465</zip>
        <country>United States</country>
        <phone_number>201-332-2122</phone_number>
        <full_name>Bob Smith</full_name>
        <payment_method_type>credit_card</payment_method_type>
        <errors>
        </errors>
        <verification_value>XXX</verification_value>
        <number>XXXX-XXXX-XXXX-1111</number>
      </payment_method>
  XML
end

def failed_payment_method_response_xml
  <<-XML
      <errors>
        <error key="errors.payment_method_not_found">Unable to find the specified payment method.</error>
      </errors>
  XML
end

def successful_purchase_response_xml
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
          <data>
            <frequency>weekly</frequency>
            <currency>usd</currency>
            <amount>2000</amount>
          </data>
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

def failed_purchase_response_xml
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
          <data>
            <frequency>weekly</frequency>
            <currency>usd</currency>
            <amount>2000</amount>
          </data>
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

def successful_purchase_and_hash_response
  { :token=>"CtK2hq1rB9yvs0qYvQz4ZVUwdKh",
    :created_at=>'2013-12-12 22:47:05 UTC',
    :updated_at=>'2013-12-12 22:47:05 UTC',
    :state=>"succeeded",
    :message=>"Succeeded!",
    :succeeded=>true,
    :order_id=>"",
    :ip=>"",
    :description=>"",
    :gateway_token=>"7V55R2Y8oZvY1u797RRwMDakUzK",
    :merchant_name_descriptor=>"",
    :merchant_location_descriptor=>"",
    :on_test_gateway=>true,
    :currency_code=>"USD",
    :amount=>100,
    :payment_method=>{
      :token=>"SvVVGEsjBXRDhhPJ7pMHCnbSQuT",
      :created_at=>"2013-11-06 18:28:14 UTC",
      :updated_at=>"2013-12-12 22:47:05 UTC",
      :email=>"",
      :storage_state=>"retained",
      :data=>{:classification=>"501-c-3"},
      :first_name=>"Gia",
      :last_name=>"Hammes",
      :full_name=>"Gia Hammes",
      :month=>"4", :year=>"2020",
      :number=>"XXXX-XXXX-XXXX-1111",
      :last_four_digits=>"1111",
      :card_type=>"visa",
      :verification_value=>"",
      :address1=>"",
      :address2=>"",
      :city=>"",
      :state=>"",
      :zip=>"",
      :country=>"",
      :phone_number=>""}
  }
end

def failed_purchase_and_hash_response
  { :code=>422,
    :errors=>{
    :attribute=>"first_name",
    :key=>"errors.blank",
    :message=>"First name can't be blank" 
  },
  :payment_method=>{
    :token=>"CATQHnDh14HmaCrvktwNdngixMm",
    :created_at=>"2013-12-21 12:51:47 UTC",
    :updated_at=>"2013-12-21 12:51:47 UTC",
    :email=>"frederick@example.com",
    :storage_state=>"cached",
    :data=>{
      :classification=>"501-c-3",
      :currency=>"USD"
    },
    :first_name=>"Bob",
    :last_name=>"Smith",
    :full_name=>"Bob Smith",
    :month=>"1",
    :year=>"2020",
    :number=>"XXXX-XXXX-XXXX-1111",
    :last_four_digits=>"1111",
    :card_type=>"visa",
    :verification_value=>"XXX",
    :address1=>"345 Main Street",
    :address2=>"Apartment #7",
    :city=>"Wanaque",
    :state=>"NJ",
    :zip=>"07465",
    :country=>"United States",
    :phone_number=>"201-332-2122"
  }
  }
end

def valid_donation_action_info
  { :confirmed => false,
    :classification => '501-c-3',
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
    :card_exp_year => '2020' }
end

def found_payment_method
  { :token=>"FiVwzY9orntKySuOGszbdiG16HW",
    :created_at=>"2014-01-22T23:31:18Z",
    :updated_at=>"2014-01-22T23:31:21Z",
    :email=>"122q@example.com",
    :storage_state=>"retained",
    :data=>"<frequency>annual</frequency>\n    <currency>usd</currency>\n    <amount>2000</amount>",
    :first_name=>"Q",
    :last_name=>"Q",
    :full_name=>"Q Q",
    :month=>"5",
    :year=>"2017",
    :number=>"XXXX-XXXX-XXXX-1111",
    :last_four_digits=>"1111",
    :card_type=>"visa",
    :verification_value=>"",
    :address1=>"",
    :address2=>"",
    :city=>"",
    :state=>"",
    :zip=>"",
    :country=>"",
    :phone_number=>"",
    :errors=>[] }
end
