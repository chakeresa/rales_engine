class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.revenue_by_date(date = nil)
    # TO DO: make helper method #date_criteria(date)
    if date
      beginning_of_day = Time.zone.parse(date)
      end_of_day = beginning_of_day + 1.days
      date_criteria = {created_at: beginning_of_day..end_of_day}
    else
      date_criteria = nil
    end

    self.joins(:invoice_items, :transactions)
        .where(date_criteria)
        .merge(Transaction.successful)
        .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
