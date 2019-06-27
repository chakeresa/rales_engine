require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many :items }
  end

  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "class methods" do
    before(:each) do
      @count = 5
      @name = "Bob"
      @first_merchant = create(:merchant, name: @name, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2013-03-27 14:53:59 UTC")
      @sec_merchant = create(:merchant, name: @name, created_at: "2013-03-27 14:53:59 UTC", updated_at: "2014-03-27 14:53:59 UTC")
      @m3, @m4, @m5 = create_list(:merchant, @count - 2, created_at: "2014-03-27 14:53:59 UTC", updated_at: "2015-03-27 14:53:59 UTC")
    end

    it "::search by id" do
      merch_to_find = Merchant.all.second

      expect(Merchant.search(id: merch_to_find.id)).to eq(merch_to_find)
    end

    it "::search by name" do
      merch_to_find = Merchant.all.last

      expect(Merchant.search(name: merch_to_find.name)).to eq(merch_to_find)
    end

    it "::search by created_at" do
      merch_to_find = Merchant.all.second

      expect(Merchant.search(created_at: merch_to_find.created_at)).to eq(merch_to_find)
    end

    it "::search by updated_at" do
      merch_to_find = Merchant.all.second

      expect(Merchant.search(updated_at: merch_to_find.updated_at)).to eq(merch_to_find)
    end

    it "::search_all by id" do
      merch_to_find = Merchant.all.second

      expect(Merchant.search_all(id: merch_to_find.id)).to eq([merch_to_find])
    end

    it "::search_all by name" do
      expect(Merchant.search_all(name: @name)).to eq([@first_merchant, @sec_merchant])
    end

    it "::search_all by created_at" do
      merch_to_find = Merchant.all.last

      expect(Merchant.search_all(created_at: merch_to_find.created_at)).to eq([@m3, @m4, @m5])
    end

    it "::search_all by updated_at" do
      merch_to_find = Merchant.all.last

      expect(Merchant.search_all(updated_at: merch_to_find.updated_at)).to eq([@m3, @m4, @m5])
    end

    it "::random" do
      expect(Merchant.random).to satisfy { |actual| [@first_merchant, @sec_merchant, @m3, @m4, @m5].include?(actual) }
    end
  end

  describe "business logic" do
    before(:each) do
      @m1, @m2, @m3, @m4 = create_list(:merchant, 4)

      @date = "2012-03-16"
      @dt1 = "2012-03-16 00:54:09 UTC"
      @dt2 = "2012-03-16 00:12:09 UTC"

      @i11, @i12, @i13, @i14 = create_list(:invoice, 4, merchant: @m1, created_at: @dt1)
      @i21, @i22 = create_list(:invoice, 2, merchant: @m2)
      @i31 = create(:invoice, merchant: @m3, created_at: @dt2)

      @t111 = create(:transaction, invoice: @i11)
      @t121 = create(:transaction, invoice: @i12)
      @t131 = create(:transaction, invoice: @i13)
      @t141 = create(:transaction, invoice: @i14, result: "failed")
      @t211 = create(:transaction, invoice: @i21, result: "failed")
      @t212 = create(:transaction, invoice: @i21)
      @t221 = create(:transaction, invoice: @i22)
      @t311 = create(:transaction, invoice: @i31)

      # @m1 revenue = 3*1 + 2*2*46 + 2*7*5 + 0 = 257. item_ct = 3 + 2*2 + 2*7 + 0 = 21
      @ii111 = create(:invoice_item, invoice: @i11, quantity: 3, unit_price: 1)
      @ii121, @ii122 = create_list(:invoice_item, 2, invoice: @i12, quantity: 2, unit_price: 46)
      @ii131, @ii132 = create_list(:invoice_item, 2, invoice: @i13, quantity: 7, unit_price: 5)
      @ii141 = create(:invoice_item, invoice: @i14, quantity: 400, unit_price: 57) # no successful transactions - not included

      # @m2 revenue = 2*20*75 + 2*35*560 = 42200. item_ct = 2*20 + 2*35 = 110
      @ii211, @ii212 = create_list(:invoice_item, 2, invoice: @i21, quantity: 20, unit_price: 75)
      @ii221, @ii222 = create_list(:invoice_item, 2, invoice: @i22, quantity: 35, unit_price: 560)

      # @m3 revenue = 3*700*1 = 2100. item_ct = 3*700 = 2100
      @ii311, @ii312, @ii313 = create_list(:invoice_item, 3, invoice: @i31, quantity: 700, unit_price: 1)

      # @m4 has no invoices/revenue -- will not show up at all
    end

    it "::top_x_by_revenue" do
      expect(Merchant.top_x_by_revenue(1)).to eq([@m2])
      expect(Merchant.top_x_by_revenue(2)).to eq([@m2, @m3])
      expect(Merchant.top_x_by_revenue(3)).to eq([@m2, @m3, @m1])
      expect(Merchant.top_x_by_revenue(4)).to eq([@m2, @m3, @m1])

      top_3_revenues_expected = [42200, 2100, 257]
      top_3_revenues_actual = Merchant.top_x_by_revenue(3).map(&:revenue)
      expect(top_3_revenues_actual).to eq(top_3_revenues_expected)

      top_2_revenues_expected = [42200, 2100]
      top_2_revenues_actual = Merchant.top_x_by_revenue(2).map(&:revenue)
      expect(top_2_revenues_actual).to eq(top_2_revenues_expected)
    end

    it "::top_x_by_items_sold_ct" do
      expect(Merchant.top_x_by_items_sold_ct(1)).to eq([@m3])
      expect(Merchant.top_x_by_items_sold_ct(2)).to eq([@m3, @m2])
      expect(Merchant.top_x_by_items_sold_ct(3)).to eq([@m3, @m2, @m1])
      expect(Merchant.top_x_by_items_sold_ct(4)).to eq([@m3, @m2, @m1])

      top_3_counts_expected = [2100, 110, 21]
      top_3_counts_actual = Merchant.top_x_by_items_sold_ct(3).map(&:item_ct)
      expect(top_3_counts_actual).to eq(top_3_counts_expected)

      top_2_counts_expected = [2100, 110]
      top_2_counts_actual = Merchant.top_x_by_items_sold_ct(2).map(&:item_ct)
      expect(top_2_counts_actual).to eq(top_2_counts_expected)
    end

    it "#revenue_by_date" do
      expect(@m1.revenue_by_date(nil)).to eq(257)
      expect(@m2.revenue_by_date(nil)).to eq(42200)
      expect(@m3.revenue_by_date(nil)).to eq(2100)
      expect(@m4.revenue_by_date(nil)).to eq(0)

      expect(@m1.revenue_by_date(@date)).to eq(257)
      expect(@m2.revenue_by_date(@date)).to eq(0)
      expect(@m3.revenue_by_date(@date)).to eq(2100)
      expect(@m4.revenue_by_date(@date)).to eq(0)
    end
  end
end
