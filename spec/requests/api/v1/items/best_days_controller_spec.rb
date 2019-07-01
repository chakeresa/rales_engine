require 'rails_helper'

RSpec.describe Api::V1::Items::BestDaysController do
  describe "GET #show" do
    before(:each) do
      @item = create(:item)
      @other_item = create(:item)

      @d11 = "2012-03-16 00:54:09 UTC"
      @d12 = "2012-03-16 00:10:09 UTC"
      @d21 = "2012-03-17 00:54:09 UTC"
      @d31 = "2012-03-18 00:54:09 UTC"

      @i1 = create(:invoice, created_at: @d11) # 10 sold items
      @i2 = create(:invoice, created_at: @d12) # 10 sold items + 300 of other_item
      @i3 = create(:invoice, created_at: @d21) # 20 sold items -- tied with i1 + i2 (wins b/c most recent)
      @i4 = create(:invoice, created_at: @d31) # 5 sold items
      @i5 = create(:invoice, created_at: @d31) # 500 unsold items

      @ii11 = create(:invoice_item, item: @item, invoice: @i1, quantity: 10)
      @ii21 = create(:invoice_item, item: @item, invoice: @i2, quantity: 10)
      @ii22 = create(:invoice_item, item: @other_item, invoice: @i2, quantity: 300)
      @ii31 = create(:invoice_item, item: @item, invoice: @i3, quantity: 20)
      @ii41 = create(:invoice_item, item: @item, invoice: @i4, quantity: 5)
      @ii51 = create(:invoice_item, item: @item, invoice: @i5, quantity: 500)

      @t11 = create(:transaction, invoice: @i1)
      @t21 = create(:transaction, invoice: @i2)
      @t22, @t23 = create_list(:transaction, 2, invoice: @i2, result: "failed")
      @t31 = create(:transaction, invoice: @i3)
      @t41 = create(:transaction, invoice: @i4)
      @t51 = create(:transaction, invoice: @i5, result: "failed")

      get "/api/v1/items/#{@item.id}/best_day"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs the day with the most sales for a particular item's merchant (most recent if tied)" do
      actual = parse_api_1point0_response

      expected =  {
        "attributes" => {
          "best_day" => @d21.to_date.to_s,
        }
      }
      expect(actual).to eq(expected)
    end
  end
end
