require 'rails_helper'

RSpec.describe UserHouse, type: :model do
  context 'validations' do
    it {should validate_presence_of(:user)}
    it {should validate_presence_of(:house)}
  end
end
