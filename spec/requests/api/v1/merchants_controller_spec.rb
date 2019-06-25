require 'rails_helper'

RSpec.describe Api::V1::MerchantsController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @first_merchant = create(:merchant)
      create_list(:merchant, @count - 1)
      get '/api/v1/merchants'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs merchant data" do
      merchants = parse_api_1point0_response

      expect(merchants.class).to eq(Array)
      expect(merchants.count).to eq(@count)

      expected_first =  {
        "id" => @first_merchant.id.to_s,
        "type" => "merchant",
        "attributes" => {
          "name" => @first_merchant.name
        }
      }
      expect(merchants.first).to eq(expected_first)
    end
  end
end
