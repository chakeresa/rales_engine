class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  # TO DO: refactor using DATE_TRUNC like in Item#best_day
  def self.revenue_by_date(date = nil)
    self.joins(:invoice_items, :transactions)
        .where(date_criteria(date))
        .merge(Transaction.successful)
        .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
