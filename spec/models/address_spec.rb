require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should validate_presence_of(:address_line_1)}
end
