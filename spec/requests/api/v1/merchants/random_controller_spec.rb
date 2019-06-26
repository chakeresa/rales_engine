require 'rails_helper'

RSpec.describe Api::V1::Merchants::RandomController do
  describe "GET #show" do
    before(:each) do
      @m1, @m2, @m3 =  create_list(:merchant, 3)
      get "/api/v1/merchants/random"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns a random merchant" do
      merchant_json = parse_api_1point0_response

      expect(merchant_json["attributes"]["name"]).to satisfy { |actual_name| [@m1.name, @m2.name, @m3.name].include?(actual_name) }
    end
  end
end
