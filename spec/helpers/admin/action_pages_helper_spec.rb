require "spec_helper"

describe Admin::ActionPagesHelper do
  it "should link to the images module" do
    expected = %Q{<a href="/admin/images" class="add-module-link images_module" target="_blank">lorem ipsum</a>}
    external_module_link(Image, "lorem ipsum").should eql(expected)
  end

  describe 'disabled_class,' do
		context 'content module is a petition, taf, or donation,' do
		  it "should return 'disabled'" do
		  	action_sequence = create(:action_sequence)
				petition_page = create(:action_page, name: 'Petition', action_sequence: action_sequence)
				petition_module = FactoryGirl.build(:petition_module)
				petition_page.content_modules << petition_module
				disabled_class(petition_module, petition_page).should == 'disabled'

				action_sequence = create(:action_sequence)
				taf_page = create(:action_page, name: 'Taf', action_sequence: action_sequence)
				tell_a_friend_module = FactoryGirl.build(:tell_a_friend_module)
				taf_page.content_modules << tell_a_friend_module
				disabled_class(tell_a_friend_module, taf_page).should == 'disabled'

				action_sequence = create(:action_sequence)
				donation_page = create(:action_page, name: 'Donation', action_sequence: action_sequence)
				donation_module = FactoryGirl.build(:donation_module)
				donation_page.content_modules << donation_module

				disabled_class(donation_module, donation_page).should == 'disabled'
		  end
		end

		context 'content module is not a petition, taf, or donation,' do
			it 'should return an empty string' do
				action_sequence = create(:action_sequence)
				donation_page = create(:action_page, name: 'Donation', action_sequence: action_sequence)
				html_module = FactoryGirl.build(:html_module)
				donation_page.content_modules << html_module
				disabled_class(html_module, donation_page).should == ''
			end
		end
  end

  describe "options_for_pages_with_counter" do
    it "should return pages which have counters" do
			action_sequence = create(:action_sequence)
			petition_page = create(:action_page, name: 'Petition', action_sequence: action_sequence)
			petition_page.content_modules << build(:petition_module)
			donation_page = create(:action_page, name: 'Donation', action_sequence: action_sequence)
			donation_page.content_modules << build(:donation_module)
			join_page = create(:action_page, name: 'Join', action_sequence: action_sequence)
			join_page.content_modules << build(:join_module)
			action_sequence.reload
			options_for_pages_with_counter(action_sequence).should == [['Select an Action Page', nil], [petition_page.name, petition_page.id], [donation_page.name, donation_page.id]]
    end
  end

  describe "preview_url_for_action_page" do
    it "should fallback to the url in the db for movement" do
      movement = create(:movement, name: "Sample Movement", url: "http://www.samplemovement.org")
      campaign = create(:campaign, movement: movement)
      language = create(:language)
      action_page = create(:action_page, action_sequence: create(:action_sequence, campaign: campaign))
      preview_url_for_action_sequence(language.iso_code, movement, action_page).should == "#{movement.url}/#{language.iso_code}/actions/#{action_page.id}/preview"
    end
  end

end