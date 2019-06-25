require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    xit { should have_many :transactions }
    xit { should have_many(:items).through(:invoice_items) }
  end
end
