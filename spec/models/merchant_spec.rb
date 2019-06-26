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
      create_list(:merchant, @count)
    end

    it "::search by id" do
      merch_to_find = Merchant.all.second

      expect(Merchant.search(id: merch_to_find.id)).to eq(merch_to_find)
    end

    it "::search by name" do
      merch_to_find = Merchant.all.second

      expect(Merchant.search(name: merch_to_find.name)).to eq(merch_to_find)
    end

    xit "::search by created_at" do
      merch_to_find = Merchant.all.second

      expect(Merchant.search(created_at: merch_to_find.created_at)).to eq(merch_to_find)
    end

    xit "::search by updated_at" do
      merch_to_find = Merchant.all.second

      expect(Merchant.search(updated_at: merch_to_find.updated_at)).to eq(merch_to_find)
    end
  end
end
