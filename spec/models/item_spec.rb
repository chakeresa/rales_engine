require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "business logic" do
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

    it "::top_x_by_revenue" do
      expect(Item.top_x_by_revenue(1)).to eq([@it22])
      expect(Item.top_x_by_revenue(2)).to eq([@it22, @it21])
      expect(Item.top_x_by_revenue(3)).to eq([@it22, @it21, @it31])
      expect(Item.top_x_by_revenue(20)).to eq([@it22, @it21, @it31, @it12, @it13, @it11]) # @it41 has no sales

      top_3_revenues_expected = [39200, 3000, 2100]
      top_3_revenues_actual = Item.top_x_by_revenue(3).map(&:revenue)
      expect(top_3_revenues_actual).to eq(top_3_revenues_expected)

      top_2_revenues_expected = [39200, 3000]
      top_2_revenues_actual = Item.top_x_by_revenue(2).map(&:revenue)
      expect(top_2_revenues_actual).to eq(top_2_revenues_expected)
    end

    it "::top_x_by_items_sold_ct" do
      expect(Item.top_x_by_items_sold_ct(1)).to eq([@it31])
      expect(Item.top_x_by_items_sold_ct(2)).to eq([@it31, @it22])
      expect(Item.top_x_by_items_sold_ct(3)).to eq([@it31, @it22, @it21])
      expect(Item.top_x_by_items_sold_ct(10)).to eq([@it31, @it22, @it21, @it13, @it12, @it11]) # @it41 has no sales

      top_3_counts_expected = [2100, 70, 40]
      top_3_counts_actual = Item.top_x_by_items_sold_ct(3).map(&:item_ct)
      expect(top_3_counts_actual).to eq(top_3_counts_expected)

      top_2_counts_expected = [2100, 70]
      top_2_counts_actual = Item.top_x_by_items_sold_ct(2).map(&:item_ct)
      expect(top_2_counts_actual).to eq(top_2_counts_expected)
    end
  end

  it "business logic - #best_day" do
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

    expect(@item.best_day).to eq(@d21.to_date)
  end
end
