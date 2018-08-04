require 'rails_helper'

RSpec.describe UserWaterQuestion, type: :model do
  before :each do
    country = Country.create(name: "Country-land")
    region = Region.create(name: "Region-land", country_id: country.id)
    city = City.create(name: "City", region_id: region.id)
    neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
    zip = Zipcode.create(zipcode: 80291)
    address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                              neighborhood_id: neighborhood.id,
                              city_id: city.id,
                              )
    user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                        password: 'password', generation: 1)
    house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
    user.houses << house
    @u_question_list = UserWaterQuestion.create(user_id: user.id, house_id: house.id)
  end
  context 'relationships' do
    it {should belong_to(:house)}
    it {should belong_to(:user)}
  end
  context 'current number of user questions' do
    it "has 5" do
        expect(@u_question_list.q_count).to eq(4)
        #however it has 5 questions
        expect(@u_question_list.attributes.keys.include?("quest1")).to be true
        expect(@u_question_list.attributes.keys.include?("quest2")).to be true
        expect(@u_question_list.attributes.keys.include?("quest3")).to be true
        expect(@u_question_list.attributes.keys.include?("quest4")).to be true
        expect(@u_question_list.attributes.keys.include?("quest5")).to be true
        expect(@u_question_list.attributes.keys.include?("quest6")).to be false
    end
    it 'updates completion for question 1' do
      @u_question_list.quest1 = "A"
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(25)
    end
    it 'updates completion for question 1' do
      @u_question_list.quest2 = "A"
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(25)
    end
    it 'updates completion for question 1' do
      @u_question_list.quest3 = "A"
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(25)
    end
    it 'DOES NOT update completion for question 4' do
      @u_question_list.quest4 = "A"
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(0)
    end
    it 'updates completion for question 1' do
      @u_question_list.quest5 = "A"
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(25)
    end
    it 'calculates accurate completion percentage' do
      @u_question_list.quest1 = "A"
      @u_question_list.quest2 = "A"
      @u_question_list.quest5 = "A"
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(75)

      @u_question_list.quest5 = nil
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(50)
    end
    it 'at 100% completion percentage it is complete' do
      @u_question_list.quest1 = "A"
      @u_question_list.quest2 = "A"
      @u_question_list.quest5 = "A"
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(75)
        expect(UserWaterQuestion.last.completed).to eq(false)

      @u_question_list.quest3 = "A"
      @u_question_list.save
        expect(UserWaterQuestion.last.completion_percentage).to eq(100)
        expect(UserWaterQuestion.last.completed).to eq(true)
    end
  end
end
