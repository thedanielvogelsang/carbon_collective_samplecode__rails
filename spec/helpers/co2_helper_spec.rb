require 'rails_helper'

RSpec.describe Co2Helper, type: :helper do
  context "methods" do
    it "can convert electricity kwhs to carbon accurately" do
      kwhs = 1000
      co2_print = helper.kwhs_to_carbon(kwhs)
        expect(co2_print.to_i).to eq(1222)
    end
    it "can convert gas therms to carbon accurately" do
      therms = 1000
      co2_print = helper.therms_to_carbon(therms)
        expect(co2_print.to_i).to eq(12081)
    end
    it 'accurately combines kwhs and carbon' do
      kwhs = 1000
      therms = 1000
      co2_print = helper.combine_average_use(1000, 1000)
        expect(co2_print.to_i).to eq(13303)
    end
  end
end
