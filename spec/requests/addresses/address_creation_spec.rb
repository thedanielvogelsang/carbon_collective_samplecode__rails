require 'rails_helper'

RSpec.describe Address do
  before(:each) do
    @user = User.create(email: 'new_email@gmail.com', password: 'abc123', first: 'Daniel')
  end
  it 'can be created with a user_id' do
    VCR.use_cassette('addresses/address_can_be_created') do
      byebug
      visit("/addresses/new?id=#{@user.id}")
      fill_in "address_geocoder_string", with: "4589 Zuni St Denver CO"
      click_on "Start Carbon Savings"
      expect(page).to have_content("Daniel's House")
      expect(Address.last).to be_truthy
    end
  end
end
