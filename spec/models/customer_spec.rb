require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it { should have_many :invoices}
    it { should have_many(:merchants).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "business intelligence" do
    before(:each) do
      @m1, @m2 = create_list(:merchant, 2)
      @c1, @c2, @c3 = create_list(:customer, 3)

      @i11 = create(:invoice, merchant: @m1, customer: @c1, created_at: @dt1)
      @i12, @i13, @i14 = create_list(:invoice, 3, merchant: @m1, customer: @c2, created_at: @dt1)
      @i21, @i22, @i23 = create_list(:invoice, 3, merchant: @m2, customer: @c2)
      @i24 = create(:invoice, merchant: @m2, customer: @c3)

      @t111 = create(:transaction, invoice: @i11) # @c1
      @t121 = create(:transaction, invoice: @i12) # 2 successes for @m1
      @t131 = create(:transaction, invoice: @i13)
      @t141 = create(:transaction, invoice: @i14, result: "failed")
      @t211 = create(:transaction, invoice: @i21, result: "failed")
      @t212 = create(:transaction, invoice: @i21) # 3 successes for @m2
      @t221 = create(:transaction, invoice: @i22)
      @t231 = create(:transaction, invoice: @i23)
      @t241 = create(:transaction, invoice: @i23, result: "failed") # @c3
    end

    it "#favorite_merchants" do
      expect(@c1.favorite_merchants(1)).to eq([@m1])
      expect(@c2.favorite_merchants(4)).to eq([@m2, @m1])
      expect(@c3.favorite_merchants(1)).to eq([])
    end
  end
end
