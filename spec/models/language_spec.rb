# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string(255)      not null
#  first_name               :string(64)
#  last_name                :string(64)
#  mobile_number            :string(32)
#  home_number              :string(32)
#  street_address           :string(128)
#  suburb                   :string(64)
#  country_iso              :string(2)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  is_member                :boolean          default(TRUE), not null
#  encrypted_password       :string(255)      default("!K1T7en$!!2011G")
#  password_salt            :string(255)
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0)
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  deleted_at               :datetime
#  is_admin                 :boolean          default(FALSE)
#  created_by               :string(255)
#  updated_by               :string(255)
#  postcode_id              :integer
#  is_volunteer             :boolean          default(FALSE)
#  random                   :float
#  movement_id              :integer          not null
#  language_id              :integer
#  postcode                 :string(255)
#  join_email_sent          :boolean
#  name_safe                :boolean
#  source                   :string(255)
#  permanently_unsubscribed :boolean
#  state                    :string(64)
#

require "spec_helper"

describe Language do
  before do
    Language.create({:iso_code => "en", :name => "English", :native_name => "English"})
  end

  describe '#find_by_iso_code_cache' do
    it "should default to english if no ISO found" do
      Language.find_by_iso_code_cache("ra").name.should == "English"
    end

    it "should return English for en" do
      Language.find_by_iso_code_cache("en").name.should == "English"
    end
  end
end
