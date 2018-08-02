require 'rails_helper'

RSpec.describe CountrySnapshot, type: :model do
  context 'relationships' do
    it {should belong_to(:country)}
  end
end
