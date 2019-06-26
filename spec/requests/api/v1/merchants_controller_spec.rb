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

    it "outputs data for all merchants" do
      merchants = parse_api_1point0_response

      expect(merchants.class).to eq(Array)
      expect(merchants.count).to eq(@count)

      expected_first =  {
        "id" => @first_merchant.id.to_s,
        "type" => "merchant",
        "attributes" => {
          "id" => @first_merchant.id,
          "name" => @first_merchant.name
        }
      }
      expect(merchants.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 5
      @first_merchant = create(:merchant)
      @other_merchants =  create_list(:merchant, @count - 1)
    end

    it "returns http success" do
      get "/api/v1/merchants/#{@first_merchant.id}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a single merchant" do
      get "/api/v1/merchants/#{@first_merchant.id}"
      merchant = parse_api_1point0_response

      expect(merchant.class).to eq(Hash)

      expected_hash =  {
        "id" => @first_merchant.id.to_s,
        "type" => "merchant",
        "attributes" => {
          "id" => @first_merchant.id,
          "name" => @first_merchant.name
        }
      }
      expect(merchant).to eq(expected_hash)
    end

    it "finds by id" do
      merchant_resource = @other_merchants.first
      get "/api/v1/merchants/find?id=#{merchant_resource.id}"
      merchant_json = parse_api_1point0_response

      expected_hash =  {
        "id" => merchant_resource.id.to_s,
        "type" => "merchant",
        "attributes" => {
          "id" => merchant_resource.id,
          "name" => merchant_resource.name
        }
      }
      expect(merchant_json).to eq(expected_hash)
    end
  end
end
