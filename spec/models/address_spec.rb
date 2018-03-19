require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'relationships' do
    it { should belong_to(:zipcode)}
  end
end
