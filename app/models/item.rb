class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.top_x_by_revenue(limit)
    self.select(:id, :name, :description).select(:unit_price, :merchant_id)
        .select("SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
        .joins(invoices: :transactions)
        .merge(Transaction.successful)
        .group(:id)
        .order("revenue DESC")
        .limit(limit)
  end

  def details_for_serialization
    select([:id, :name, :description]).select([:unit_price, :merchant_id])
  end
end
