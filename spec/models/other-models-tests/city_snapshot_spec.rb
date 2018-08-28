require 'rails_helper'

RSpec.describe CitySnapshot, type: :model do
  context 'relationships' do
    it {should belong_to(:city)}
  end
end
