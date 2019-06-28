require 'rails_helper'

RSpec.describe Api::V1::Merchants::MostRevenueController do
  describe "GET #index" do
    before(:each) do
      @m1, @m2, @m3, @m4 = create_list(:merchant, 4)

      @date = "2012-03-16"
      @dt1 = "2012-03-16 00:54:09 UTC"
      @dt2 = "2012-03-16 00:12:09 UTC"

      @c1, @c2, @c3, @c4 = create_list(:customer, 4)

      @it11, @it12, @it13 = create_list(:item, 3, merchant: @m1)
      @it21, @it22, @it23 = create_list(:item, 3, merchant: @m2)
      @it31 = create(:item, merchant: @m3)
      @it41 = create(:item, merchant: @m4)

      @i11 = create(:invoice, merchant: @m1, customer: @c1, created_at: @dt1)
      @i12, @i13, @i14 = create_list(:invoice, 3, merchant: @m1, customer: @c2, created_at: @dt1)
      @i21, @i22 = create_list(:invoice, 2, merchant: @m2, customer: @c2)
      @i31 = create(:invoice, merchant: @m3, customer: @c3, created_at: @dt2)

      @t111 = create(:transaction, invoice: @i11)
      @t121 = create(:transaction, invoice: @i12)
      @t131 = create(:transaction, invoice: @i13)
      @t141 = create(:transaction, invoice: @i14, result: "failed")
      @t211 = create(:transaction, invoice: @i21, result: "failed")
      @t212 = create(:transaction, invoice: @i21)
      @t221 = create(:transaction, invoice: @i22)
      @t311 = create(:transaction, invoice: @i31)

      # @m1 revenue = 3*1 #3# + 2*2*46 #184# + 2*7*5 #70# + 0 = 257. item_ct = 3 + 2*2 + 2*7 + 0 = 21
      @ii111 = create(:invoice_item, invoice: @i11, quantity: 3, unit_price: 1, item: @it11)
      @ii121, @ii122 = create_list(:invoice_item, 2, invoice: @i12, quantity: 2, unit_price: 46, item: @it12)
      @ii131, @ii132 = create_list(:invoice_item, 2, invoice: @i13, quantity: 7, unit_price: 5, item: @it13)
      @ii141 = create(:invoice_item, invoice: @i14, quantity: 400, unit_price: 57, item: @it12) # no successful transactions - not included

      # @m2 revenue = 2*20*75 #3000# + 2*35*560 #39200# = 42200. item_ct = 2*20 + 2*35 = 110
      @ii211, @ii212 = create_list(:invoice_item, 2, invoice: @i21, quantity: 20, unit_price: 75, item: @it21)
      @ii221, @ii222 = create_list(:invoice_item, 2, invoice: @i22, quantity: 35, unit_price: 560, item: @it22)

      # @m3 revenue = 3*700*1 = 2100. item_ct = 3*700 = 2100
      @ii311, @ii312, @ii313 = create_list(:invoice_item, 3, invoice: @i31, quantity: 700, unit_price: 1, item: @it31)

      # @m4 has no invoices/revenue -- will not show up at all
    end

    it "returns http success" do
      get "/api/v1/merchants/most_revenue?quantity=2"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for x merchants with the highest revenue" do
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
