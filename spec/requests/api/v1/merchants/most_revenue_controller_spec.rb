require 'rails_helper'

RSpec.describe Api::V1::Merchants::MostRevenueController do
  describe "GET #index" do
    before(:each) do
      @m1, @m2, @m3, @m4 = create_list(:merchant, 4)

      @i11, @i12, @i13 = create_list(:invoice, 3, merchant: @m1)
      @i21, @i22 = create_list(:invoice, 2, merchant: @m2)
      @i31 = create(:invoice, merchant: @m3)

      # @m1 revenue = 3*1 + 2*2*46 + 2*7*5 = 257
      @ii111 = create(:invoice_item, invoice: @i11, quantity: 3, unit_price: 1)
      @ii121, @ii122 = create_list(:invoice_item, 2, invoice: @i12, quantity: 2, unit_price: 46)
      @ii131, @ii132 = create_list(:invoice_item, 2, invoice: @i13, quantity: 7, unit_price: 5)

      # @m2 revenue = 2*20*75 + 2*35*560 = 42200
      @ii211, @ii212 = create_list(:invoice_item, 2, invoice: @i21, quantity: 20, unit_price: 75)
      @ii221, @ii222 = create_list(:invoice_item, 2, invoice: @i22, quantity: 35, unit_price: 560)

      # @m3 revenue = 3*700*1 = 2100
      @ii311, @ii312, @ii313 = create_list(:invoice_item, 3, invoice: @i31, quantity: 700, unit_price: 1)

      # @m4 has no invoices/revenue -- will not show up at all

      # TO DO: add failed transactions corresponding with these invoices. If an invoice has only "failed" for all transaction "result"s (no "succcess"), that invoice should not be counted towards revenue. Check that invoice status is "shipped"?
    end

    it "returns http success" do
      get "/api/v1/merchants/most_revenue?quantity=2"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all merchants with a particular name" do
      get "/api/v1/merchants/most_revenue?quantity=2"
      merchants = parse_api_1point0_response

      expect(merchants.class).to eq(Array)
      expect(merchants.count).to eq(2)

      expected_first =  {
        "id" => @m2.id.to_s,
        "type" => "merchant",
        "attributes" => {
          "id" => @m2.id,
          "name" => @m2.name
        }
      }
      expect(merchants.first).to eq(expected_first)
    end
  end
end
