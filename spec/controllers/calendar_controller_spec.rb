require 'rails_helper'

RSpec.describe CalendarController, type: :controller do

  describe "GET #post" do
    it "returns http success" do
      get :post
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

end
