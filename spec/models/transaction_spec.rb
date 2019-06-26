require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "relationships" do
    it { should belong_to :invoice }
  end

  describe "class methods" do
    it "scope: successful" do
      @t1, @t2 = create_list(:transaction, 2)
      @t3, @t4 = create_list(:transaction, 2, result: "failed")
      expect(Transaction.successful).to eq([@t1, @t2])
    end
  end
end
