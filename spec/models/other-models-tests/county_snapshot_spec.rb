require 'rails_helper'

RSpec.describe CountySnapshot, type: :model do
  context 'relationships' do
    it {should belong_to(:county)}
  end
end
