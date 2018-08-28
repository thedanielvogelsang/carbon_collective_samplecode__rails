require 'rails_helper'

RSpec.describe HouseholdSnapshot, type: :model do
  context 'relationships' do
    it {should belong_to(:house)}
  end
end
