require 'rails_helper'

RSpec.describe User, type: :model do
  context 'relationships' do
    it {should have_many(:groups)}
    it {should have_many(:trips)}
    it {should have_many(:admins)}
    it {should have_and_belong_to_many(:friendships)}
  end
end
