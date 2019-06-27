require 'rails_helper'

RSpec.describe Api::V1::Items::RandomController do
  describe "GET #show" do
    before(:each) do
      @i1, @i2, @i3 =  create_list(:item, 3)
      get "/api/v1/items/random"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns a random item" do
      item_json = parse_api_1point0_response

      expect(item_json["attributes"]["name"]).to satisfy { |actual_name| [@i1.name, @i2.name, @i3.name].include?(actual_name) }
    end
  end
end
