require 'rails_helper'

RSpec.describe RegionSnapshot, type: :model do
  context 'relationships' do
    it {should belong_to(:region)}
  end
end
