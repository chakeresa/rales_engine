class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.revenue_by_date(date)
    beginning_of_day = Time.zone.parse(date)
    end_of_day = beginning_of_day + 1.days
    date_range = beginning_of_day..end_of_day

    self.joins(:invoice_items, :transactions)
        .where(created_at: date_range)
        .merge(Transaction.successful)
        .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
