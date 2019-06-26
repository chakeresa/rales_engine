require 'rails_helper'

RSpec.describe Api::V1::MerchantsController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @name = "Bob"
      @first_merchant = create(:merchant, name: @name)
      @sec_merchant = create(:merchant, name: @name)
      create_list(:merchant, @count - 2)
    end

    it "returns http success" do
      get "/api/v1/merchants/find_all?name=#{@name}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all merchants with a particular name" do
      get "/api/v1/merchants/find_all?name=#{@name}"
      merchants = parse_api_1point0_response

      expect(merchants.class).to eq(Array)
      expect(merchants.count).to eq(2)

      expected_first =  {
        "id" => @first_merchant.id.to_s,
        "type" => "merchant",
        "attributes" => {
          "id" => @first_merchant.id,
          "name" => @name
        }
      }
      expect(merchants.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 5
      @first_merchant = create(:merchant, name: "Bob")
      @other_merchants =  create_list(:merchant, @count - 1)
    end

    it "returns http success" do
      get "/api/v1/merchants/find?id=#{@first_merchant.id}"
      expect(response).to have_http_status(:success)
    end

    it "finds a merchant by id" do
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

    it "finds a merchant by name" do
      merchant_resource = @other_merchants.first
      get "/api/v1/merchants/find?name=#{merchant_resource.name}"
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

    xit "finds a merchant by created_at" do
      merchant_resource = @other_merchants.first
      get "/api/v1/merchants/find?created_at=#{merchant_resource.created_at}"
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

    xit "finds a merchant by updated_at" do
      merchant_resource = @other_merchants.first
      get "/api/v1/merchants/find?updated_at=#{merchant_resource.updated_at}"
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
