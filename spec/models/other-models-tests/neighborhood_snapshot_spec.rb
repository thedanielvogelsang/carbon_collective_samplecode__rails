require 'rails_helper'

RSpec.describe NeighborhoodSnapshot, type: :model do
  context 'relationships' do
    it {should belong_to(:neighborhood)}
  end
end
